// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSProgressBar.h"

@implementation JSProgressBar {
    UIView *_bar;
    CGFloat _progress;
}

#pragma mark - Private methods

- (void)update {
    _bar.frame = ({
        CGRect bounds = self.bounds;
        bounds.size.width *= _progress;
        bounds;
    });
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {

        _bar = ({
            UIView *view = [[UIView alloc] init];
            [self addSubview:view];
            view;
        });
    }
    return self;
}

#pragma mark - UIView methods

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self update];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self update];
}

#pragma mark - Interface methods

- (void)setBarColor:(UIColor *)color {
    _bar.backgroundColor = color;
}

- (void)setProgress:(CGFloat)progress {
    JSParameterAssert(progress >= 0.0);
    JSParameterAssert(progress <= 1.0);

    _progress = progress;
    [self update];
}

@end
