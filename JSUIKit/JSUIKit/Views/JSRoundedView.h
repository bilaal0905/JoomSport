// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@interface JSRoundedView : UIView;

- (instancetype)initWithView:(UIView *)view corners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)setCorners:(UIRectCorner)corners;

@end
