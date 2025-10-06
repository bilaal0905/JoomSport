// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSBackButton.h"

@implementation JSBackButton

#pragma mark - Interface methods

+ (instancetype)button:(UIColor *)color {
    JSParameterAssert(color);

    static CGFloat const padding = 7.0;

    JSBackButton *button = [self buttonWithType:UIButtonTypeSystem];
    button.tintColor = color;

    [button setImage:[UIImage imageNamed:@"back_button_arrow"] forState:UIControlStateNormal];

    button.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:14.0];
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, padding, 0.0, -padding);
    [button setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];

    return button;
}

@end
