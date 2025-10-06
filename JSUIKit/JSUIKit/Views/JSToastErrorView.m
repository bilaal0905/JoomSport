// Created for BearDev by drif
// drif@mail.ru

//@import JSUtils;
#import "/Users/user/Downloads/BaernerCup/BaernerCup 2023/JSUtils/JSUtils/Supporting Files/JSUtils.h"

#import "JSToastErrorView.h"
#import "JSUIKit.h"

@implementation JSToastErrorView

#pragma mark - Private methods

- (void)onTapRecognizer {
    JSBlock(self.onTap, nil);
}

#pragma mark - Interface methods

- (instancetype)initWithError:(NSString *)error {
    JSParameterAssert(error);

    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor js_R:235 G:200 B:196];

        [self addSubview:({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor js_R:131 G:53 B:54];
            label.text = error;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:14.0];

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[label]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        })];

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapRecognizer)]];
    }
    return self;
}

@end
