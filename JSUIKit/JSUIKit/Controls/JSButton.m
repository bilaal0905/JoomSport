// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSBlock;

#import "JSButton.h"

@implementation JSButton

#pragma mark - Private methods

- (void)onSelfTap {
    JSBlock(self.onTap, nil);
}

#pragma mark - NSObject methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(onSelfTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
