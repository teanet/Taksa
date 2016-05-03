#import "TKSBaseVC.h"

@interface TKSBaseVC ()

@property (nonatomic, strong, readonly) id viewModel;

@end

@implementation TKSBaseVC

@synthesize viewModel = _viewModel;

- (instancetype)initWithVM:(id)viewModel;
{
	self = [super initWithNibName:nil bundle:nil];
	if (self == nil) return nil;

	_viewModel = viewModel;

	return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	return [self initWithVM:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	return [self initWithVM:nil];
}

- (id)viewModel
{
	return _viewModel;
}

@end
