// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

typedef NS_ENUM(NSUInteger, JSAlphedViewDirection) {
    JSAlphedViewDirectionLeft,
    JSAlphedViewDirectionRight
};

@interface JSAlphedView : UIView

- (instancetype)initWithView:(UIView *)view direction:(JSAlphedViewDirection)direction;
- (void)setAlphaWidth:(CGFloat)alphaWidth;

@end
