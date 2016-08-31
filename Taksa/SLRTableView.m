#import "SLRTableView.h"

@implementation SLRTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView *resultView = [super hitTest:point withEvent:event];
	if ( resultView == self ) return nil;
	else return resultView;
}

@end
