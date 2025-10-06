// Created for BearDev by drif
// drif@mail.ru

#import "JSRoundedButton.h"
#import "UIView+JS.h"
#import "UIColor+JS.h"

@implementation JSRoundedButton

#pragma mark - UIView methods

- (CGSize)intrinsicContentSize {
    return CGSizeMake(0.0, 40.0);
}

#pragma mark - Interface methods

+ (instancetype)button {
    JSRoundedButton *button = [self buttonWithType:UIButtonTypeSystem];

    button.backgroundColor = UIColor.whiteColor;
    button.layer.cornerRadius = 8.0;

    button.titleLabel.font = [UIFont fontWithName:@"SFUIText-Medium" size:12.0];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumScaleFactor = 0.75;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0);
    [button setTitleColor:UIColor.js_Black forState:UIControlStateNormal];

    [button js_setupShadow];
    
    return button;
}

@end
