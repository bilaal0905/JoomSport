// Created for BearDev by drif
// drif@mail.ru

//@import JSUIKit.JSPxView;
#import "/Users/user/Downloads/BaernerCup/BaernerCup 2023/JSUtils/JSUtils/JSUtils.h"

#import "JSTitledView.h"
#import "UIColor+JS.h"
#import "JSBackButton.h"

@implementation JSTitledView {
    JSBackButton *_backButton;
    UILabel *_titleLabel;
    UIView *_contentContainer;
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {

        _backButton = ({
            JSBackButton *button = [JSBackButton button:UIColor.js_Green];

            button.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:button];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];

            button;
        });

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

        _contentContainer = ({
            UIView *view = [[UIView alloc] init];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-13-[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, view)]];

            view;
        });

        {
            JSPxView *view = [[JSPxView alloc] initWithType:JSPxViewTypeHorizontal];
            view.backgroundColor = UIColor.js_Separator;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view][_contentContainer]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view, _contentContainer)]];
        }
    }
    return self;
}

#pragma mark - Interface methods

- (JSBackButton *)backButton {
    return _backButton;
}

- (UILabel *)titleLabel {
    return _titleLabel;
}

- (UIView *)contentContainer {
    return _contentContainer;
}

@end
