// Created for BearDev by drif
// drif@mail.ru

#import "JSDetailsBackground.h"

@implementation JSDetailsBackground {
    UIImageView *_header;
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {

        _header = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleToFill;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(180)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (UIImageView *)header {
    return _header;
}

@end
