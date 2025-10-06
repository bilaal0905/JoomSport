// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSTextCellLayout.h"

@implementation JSTextCellLayout {
    CGFloat _width;
    CGRect _labelFrame;
    NSAttributedString *_text;
}

#pragma mark - Private methods

- (void)invalidate {
    static CGFloat const offset = 12.0;

    CGSize size = CGSizeMake(_width - 2.0 * offset, HUGE_VALF);
    CGRect rect = [_text boundingRectWithSize:size options:(NSStringDrawingOptions) (NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil];
    rect.origin = CGPointMake(offset, 20.0);
    _labelFrame = rect;
}

#pragma mark - Interface methods

- (instancetype)initWithText:(NSAttributedString *)text {
    JSParameterAssert(text);

    self = [super init];
    if (self) {
        _text = text.copy;
    }
    return self;
}

- (void)setWidth:(CGFloat)width {
    if (ABS(width) < DBL_EPSILON) {
        return;
    }

    if (ABS(width - _width) < DBL_EPSILON) {
        return;
    }

    _width = width;
    [self invalidate];
}

- (NSAttributedString *)text {
    return _text;
}

- (CGRect)labelFrame {
    return _labelFrame;
}

- (CGFloat)height {
    return CGRectGetMaxY(_labelFrame);
}

@end
