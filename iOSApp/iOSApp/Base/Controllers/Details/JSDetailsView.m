// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit.JSRoundedView;

#import "JSDetailsView.h"
#import "JSSubtitledLogoView.h"
#import "UIView+JS.h"

@implementation JSDetailsView {
    JSSubtitledLogoView *_logo;
    UIView *_container;
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {

        _container = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = UIColor.whiteColor;
            view;
        });

        JSRoundedView *roundedContainer = ({
            JSRoundedView *view = [[JSRoundedView alloc] initWithView:_container corners:(UIRectCorner) (UIRectCornerTopLeft | UIRectCornerTopRight) radius:6.0];
            [view js_setupShadow];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[view]-13-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-118-[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });

        _logo = ({
            JSSubtitledLogoView *view = [[JSSubtitledLogoView alloc] initWithLogoSize:60.0 fontSize:14.0 padding:10.0];
            view.label.textColor = UIColor.whiteColor;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-11-[view]-(>=0)-[roundedContainer]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(roundedContainer, view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[view]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (JSSubtitledLogoView *)logo {
    return _logo;
}

- (UIView *)container {
    return _container;
}

@end
