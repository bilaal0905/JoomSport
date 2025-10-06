// Created for BearDev by drif
// drif@mail.ru

#import "UIView+JS.h"

@implementation UIView (JS)

#pragma mark - Interface methods

- (void)js_setupShadow {
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.15;
    self.layer.shadowRadius = 5.0;
}

@end
