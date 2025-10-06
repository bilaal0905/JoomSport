// Created for BearDev by drif
// drif@mail.ru

#import "JSSeasonedView.h"
#import "JSRoundedButton.h"
#import "UIColor+JS.h"

@implementation JSSeasonedView {
    UILabel *_titleLabel;
    JSRoundedButton *_seasonButton;
    JSRoundedButton *_sortButton;
    UIView *_tableViewContainer;
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {

        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColor.js_Black;
            label.font = [UIFont fontWithName:@"SFUIText-Semibold" size:14.0];

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });

        _seasonButton = ({
            JSRoundedButton *button = [JSRoundedButton button];

            button.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:button];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-12-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, button)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.58 constant:1.0]];

            button;
        });

        _sortButton = ({
            JSRoundedButton *button = [JSRoundedButton button];

            button.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:button];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_seasonButton]-12-[button]-12-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_seasonButton, button)]];

            button;
        });

        _tableViewContainer = ({
            UIView *view = [[UIView alloc] init];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_seasonButton]-13-[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_seasonButton, view)]];

            view;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (UILabel *)titleLabel {
    return _titleLabel;
}

- (JSRoundedButton *)seasonButton {
    return _seasonButton;
}

- (JSRoundedButton *)sortButton {
    return _sortButton;
}

- (UIView *)tableViewContainer {
    return _tableViewContainer;
}

@end
