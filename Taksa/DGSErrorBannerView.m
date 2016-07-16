#import "DGSErrorBannerView.h"

#import "UIColor+DGSCustomColor.h"
#import "UIFont+DGSCustomFont.h"

CGFloat const kDGSErrorBannerImageWidth = 32.0;
CGFloat const kDGSErrorBannerSecondaryImageWidth = 28.0;

static CGFloat const kMinBannerHeight = 48.0;
static CGFloat const kButtonWidth = 48.0;
static CGFloat const kSpace = 8.0;
static CGFloat const kStatusBarHeight = 20.0;
static CGFloat const kSpringAnimationThreshold = 50.0;

static const UIViewAnimationOptions kBannerAnimationOptions =
	(UIViewAnimationOptionCurveEaseOut |
	 UIViewAnimationOptionBeginFromCurrentState);

@interface DGSErrorBannerView ()

@property (nonatomic, strong, readonly) UIView *banner;

@property (nonatomic, strong, readonly) UIView *imagesContainer;
@property (nonatomic, strong, readonly) UIImageView *imageViewFront;
@property (nonatomic, strong, readonly) UIImageView *imageViewBack;

@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) UIView *buttonsContainer;
@property (nonatomic, copy, readonly) NSArray<UIButton *> *buttons;

@property (nonatomic, weak, readonly) UIView *containerView;

@property (nonatomic, assign) BOOL shown;
@property (nonatomic, assign) BOOL shouldUpdateButtonsConstraints;

@end

@implementation DGSErrorBannerView

- (instancetype)initWithViewModel:(DGSErrorBannerVM *)viewModel
					containerView:(UIView *)containerView
{
	self = [super initWithFrame:CGRectZero];
	if (!self) return nil;

	_viewModel = viewModel;
	_containerView = containerView;

	_shown = NO;
	_shouldUpdateButtonsConstraints = YES;

	// Red banner
	_banner = [[UIView alloc] init];
	_banner.backgroundColor = [UIColor dgs_flamePeaColor];
	_banner.layer.shadowColor = [UIColor blackColor].CGColor;
	_banner.layer.shadowOpacity = 0.3;
	_banner.layer.shadowOffset = CGSizeMake(0.0, 1.0);
	[self addSubview:_banner];

	// Images
	_imagesContainer = [[UIView alloc] init];
	_imagesContainer.clipsToBounds = YES;
	[_banner addSubview:_imagesContainer];

	_imageViewFront = [[UIImageView alloc] init];
	_imageViewFront.contentMode = UIViewContentModeScaleAspectFill;
	[_imagesContainer addSubview:_imageViewFront];

	_imageViewBack = [[UIImageView alloc] init];
	_imageViewBack.contentMode = UIViewContentModeScaleAspectFill;
	_imageViewBack.clipsToBounds = YES;
	[_imagesContainer addSubview:_imageViewBack];

	// Buttons
	_buttonsContainer = [[UIView alloc] init];
	[_banner addSubview:_buttonsContainer];

	// Message
	_messageLabel = [[UILabel alloc] init];
	_messageLabel.textColor = [UIColor whiteColor];
	_messageLabel.font = [UIFont dgs_regularFontOfSize:15.0];
	_messageLabel.numberOfLines = 0;
	[_banner addSubview:_messageLabel];

	// Masonry
	[_banner mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self);
		make.top.equalTo(self);
		make.width.equalTo(self);
		make.height.mas_greaterThanOrEqualTo(kMinBannerHeight + kStatusBarHeight);
	}];

	[_imagesContainer mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_banner).with.offset(kSpace + kStatusBarHeight + kSpringAnimationThreshold);
		make.left.equalTo(_banner).with.offset(kSpace);
		make.height.lessThanOrEqualTo(@(kDGSErrorBannerImageWidth));
		make.width.lessThanOrEqualTo(@(kDGSErrorBannerImageWidth));
		make.bottom.lessThanOrEqualTo(_banner).with.offset(-kSpace);
	}];

	[_imageViewFront mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(_imagesContainer);
	}];

	[_imageViewBack mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(kDGSErrorBannerSecondaryImageWidth, kDGSErrorBannerSecondaryImageWidth));
		make.top.equalTo(_imagesContainer);
		make.left.equalTo(_imagesContainer);
	}];

	[_buttonsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(_banner);
	}];

	[_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(_banner).with.offset((kStatusBarHeight + kSpringAnimationThreshold) / 2.0);
		make.right.equalTo(_buttonsContainer.mas_left).with.offset(-kSpace);
		make.height.mas_greaterThanOrEqualTo(kDGSErrorBannerImageWidth);
		make.bottom.lessThanOrEqualTo(_banner).with.offset(-kSpace);
	}];

	[self setupReactiveStuff];

	return self;
}

- (instancetype)initWithViewModel:(DGSErrorBannerVM *)viewModel
{
	return [self initWithViewModel:viewModel
					 containerView:nil];
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[[[RACObserve(self.viewModel, model)
		distinctUntilChanged]
		deliverOnMainThread]
		subscribeNext:^(DGSErrorBannerModel *model) {
			@strongify(self);

			BOOL errorViewShouldBeShown = !!model;
			[self updateStateToShown:errorViewShouldBeShown];
		}];

	[[RACObserve([UIApplication sharedApplication], statusBarHidden)
		distinctUntilChanged]
		subscribeNext:^(id _) {
			@strongify(self);

			[self updateStateStatusBar];
		}];
}

// MARK: Layout

- (void)updateStateStatusBar
{
	if (self.shown)
	{
		[UIView animateWithDuration:0.3
							  delay:0.0
							options:kBannerAnimationOptions
						 animations:^{
							 [self showToScreen];
						 } completion:nil];
	}
}

- (void)updateStateToShown:(BOOL)shouldBeShown
{
	// Спрятана ошибка -> нужно показать
	// Показана ошибка -> нужно заапдейтить
	// Показана ошибка -> нужно спрятать
	if (!self.shown && shouldBeShown)
	{
		[self show];
	}
	else if (self.shown && shouldBeShown)
	{
		[self updateUIFromModel];
	}
	else if (self.shown && !shouldBeShown)
	{
		[self hide];
	}
}

- (void)updateConstraints
{
	if (self.shouldUpdateButtonsConstraints)
	{
		[self updateConstraintsButtons];
	}

	[self updateConstraintsMesssage];
	[self updateConstraintsButtonsContainer];

	[super updateConstraints];
}

- (void)updateConstraintsMesssage
{
	[self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		if (self.imageViewBack.image || self.imageViewFront.image)
		{
			make.left.equalTo(_imagesContainer.mas_right).with.offset(kSpace);
		}
		else
		{
			make.left.equalTo(_banner.mas_left).with.offset(kSpace);
		}
	}];
}

- (void)updateConstraintsButtonsContainer
{
	[self.buttonsContainer mas_updateConstraints:^(MASConstraintMaker *make) {
		if (self.imageViewBack.image || self.imageViewFront.image)
		{
			make.centerY.equalTo(self.imagesContainer);
		}
		else
		{
			make.centerY.equalTo(self.messageLabel);
		}

		if (self.viewModel.actions.count > 0)
		{
			make.width.greaterThanOrEqualTo(@0.0);
		}
		else
		{
			make.width.equalTo(@0.0);
		}
	}];
}

- (void)updateConstraintsButtons
{
	// Выкидываем старые кнопки и пихаем новые
	[_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];

	NSMutableArray<UIButton *> *buttons = [NSMutableArray arrayWithCapacity:self.viewModel.actions.count];

	[self.viewModel.actions enumerateObjectsUsingBlock:^(DGSErrorBannerAction *action, NSUInteger _, BOOL *__) {
		UIButton *button = [[UIButton alloc] init];
		[button setImage:action.image forState:UIControlStateNormal];
		[button addTarget:self action:@selector(handleActionTap:) forControlEvents:UIControlEventTouchUpInside];
		[_buttonsContainer addSubview:button];

		[button mas_updateConstraints:^(MASConstraintMaker *make) {
			make.size.mas_equalTo(CGSizeMake(kButtonWidth, kButtonWidth));
			make.top.equalTo(_buttonsContainer);
			make.bottom.equalTo(_buttonsContainer);
			if (buttons.lastObject)
			{
				make.left.equalTo(buttons.lastObject.mas_right);
			}
			else
			{
				make.left.equalTo(_buttonsContainer);
			}

			if (_viewModel.actions.lastObject == action)
			{
				make.right.equalTo(_buttonsContainer);
			}
		}];

		[buttons addObject:button];
	}];

	self.shouldUpdateButtonsConstraints = NO;
	_buttons = [buttons copy];
}

// MARK: Show/Hide

- (void)show
{
	[self addToViewHierarchyIfNeeded];
	[self updateUIFromModel];
	[self hideFromScreen];

	self.userInteractionEnabled = YES;
	self.shown = YES;

	[UIView animateWithDuration:0.5
						  delay:0.0
		 usingSpringWithDamping:0.7
		  initialSpringVelocity:0.75
						options:kBannerAnimationOptions
					 animations:^{
						 [self showToScreen];
					 }
					 completion:nil];
}

- (void)showToScreen
{
	BOOL statusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
	self.banner.transform = [self transformToShowBannerWithStatusBarHidden:statusBarHidden];
}

- (CGAffineTransform)transformToShowBannerWithStatusBarHidden:(BOOL)statusBarHidden
{
	CGFloat statusBarHeight = statusBarHidden
		? kStatusBarHeight
		: 0.0;
	return CGAffineTransformMakeTranslation(0.0, -kSpringAnimationThreshold - statusBarHeight);
}

- (void)hide
{
	self.userInteractionEnabled = NO;
	self.shown = NO;

	[UIView animateWithDuration:0.3
						  delay:0.0
						options:kBannerAnimationOptions
					 animations:^{
						 [self hideFromScreen];
					 } completion:^(BOOL finished) {
						 [self removeFromViewHierarchyIfNeeded];
					 }];
}

- (void)hideFromScreen
{
	self.banner.transform = CGAffineTransformMakeTranslation(0.0, -CGRectGetHeight(self.banner.frame));
}

- (void)addToViewHierarchyIfNeeded
{
	if ([self superview]) return;

	UIView *container = self.containerView;
	if (!container)
	{
		container = [[UIApplication sharedApplication].delegate window];
	}
	[container addSubview:self];
	[self mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(container);
	}];
}

- (void)removeFromViewHierarchyIfNeeded
{
	if (![self superview]) return;

	if (!self.shown)
	{
		[self removeFromSuperview];
	}
}

- (BOOL)shouldAlignMessageToLeft
{
	return (self.viewModel.actions.count > 0 ||
			self.viewModel.imageFront != nil ||
			self.viewModel.imageBack != nil);
}

- (void)updateMessageTextAlignment
{
	self.messageLabel.textAlignment = self.shouldAlignMessageToLeft
		? NSTextAlignmentLeft
		: NSTextAlignmentCenter;
}

- (void)updateUIFromModel
{
	[self updateMessageTextAlignment];

	self.imageViewFront.image = self.viewModel.imageFront;
	self.imageViewBack.image = self.viewModel.imageBack;
	self.messageLabel.attributedText = self.viewModel.attributedMessage;

	self.shouldUpdateButtonsConstraints = YES;

	[self setNeedsUpdateConstraints];
	[self layoutIfNeeded];
}

// MARK: Actions

- (void)handleActionTap:(UIButton *)button
{
	[self.viewModel performActionWithIndex:[self.buttons indexOfObject:button]];
}

// MARK: Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if (self.viewModel.autohideMode == DGSErrorBannerAutohideModeByTouch)
	{
		[self.viewModel hide];
	}
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	BOOL isInside = [super pointInside:point withEvent:event];
	if (isInside && self.viewModel.autohideMode == DGSErrorBannerAutohideModeByButtonTap)
	{
		point = [self convertPoint:point toView:self.banner];
		isInside = [self.banner pointInside:point withEvent:event];
	}

	return isInside;
}

@end
