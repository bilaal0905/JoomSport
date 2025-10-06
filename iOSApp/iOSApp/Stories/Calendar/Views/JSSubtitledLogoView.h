// Created for BearDev by drif
// drif@mail.ru

@import UIKit;
@import JSUtils.JSBlock;

@class JSLogoView;

@interface JSSubtitledLogoView : UIView

@property (nonatomic, copy) JSEventBlock onTap;

- (instancetype)initWithLogoSize:(CGFloat)logoSize fontSize:(CGFloat)fontSize padding:(CGFloat)padding;

- (JSLogoView *)logoView;
- (UILabel *)label;

@end
