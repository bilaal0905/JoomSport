// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSOnce;

#import "JSPxView.h"

@implementation JSPxView {
    JSPxViewType _type;
}

#pragma mark - Private methods

+ (CGFloat)pxHeight {
    JSOnceSetReturn(CGFloat, height, 1.0 / UIScreen.mainScreen.scale);
}

+ (CGSize)pxSizeHorizontal {
    JSOnceSetReturn(CGSize, size, CGSizeMake(0.0, self.class.pxHeight));
}

+ (CGSize)pxSizeVertical {
    JSOnceSetReturn(CGSize, size, CGSizeMake(self.class.pxHeight, 0.0));
}

#pragma mark - UIView methods

- (CGSize)intrinsicContentSize {
    return (_type == JSPxViewTypeHorizontal) ? self.class.pxSizeHorizontal : self.class.pxSizeVertical;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.intrinsicContentSize;
}

#pragma mark - Interface methods

- (instancetype)initWithType:(JSPxViewType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

@end
