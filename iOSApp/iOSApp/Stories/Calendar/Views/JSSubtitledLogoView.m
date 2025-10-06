// Created for BearDev by drif
// drif@mail.ru

#import "JSSubtitledLogoView.h"
#import "JSLogoView.h"
#import "UIColor+JS.h"

@implementation JSSubtitledLogoView {
    JSLogoView *_logoView;
    UILabel *_label;
    UITapGestureRecognizer *_tapRecognizer;
}

#pragma mark - Private methods

- (void)onTapRecognizer {
    JSBlock(self.onTap, nil);
}

#pragma mark - Interface methods

- (instancetype)initWithLogoSize:(CGFloat)logoSize fontSize:(CGFloat)fontSize padding:(CGFloat)padding {
    self = [super init];
    if (self) {

        _logoView = ({
            JSLogoView *view = [[JSLogoView alloc] init];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            NSDictionary *metrics = @{@"imageSize": @(logoSize)};

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[view(imageSize)]-(>=0)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(imageSize)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

            view;
        });

        _label = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColor.js_Black;
            label.font = [UIFont fontWithName:@"SFUIText-Semibold" size:fontSize];
            label.numberOfLines = 0;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_logoView]-(padding)-[label]|" options:0 metrics:@{@"padding": @(padding)} views:NSDictionaryOfVariableBindings(_logoView, label)]];

            label;
        });

        [self addGestureRecognizer:({
            _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapRecognizer)];
            _tapRecognizer.enabled = NO;
            _tapRecognizer;
        })];
    }
    return self;
}

#pragma mark - Interface methods

- (JSLogoView *)logoView {
    return _logoView;
}

- (UILabel *)label {
    return _label;
}

- (void)setOnTap:(JSEventBlock)onTap {
    _onTap = [onTap copy];
    _tapRecognizer.enabled = (_onTap != nil);
}

@end
