// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSUIKit.JSPxView;

#import "JSGameStagesView.h"
#import "UIColor+JS.h"

@implementation JSGameStagesView {
    NSArray *_labels;
    NSArray *_separators;

    CGFloat _cachedWidth;
    CGFloat _height;
}

#pragma mark - Private methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Semibold" size:12.0]);
}

- (void)initLabels:(NSArray *)stages {
    for (UILabel *label in _labels) {
        [label removeFromSuperview];
    }

    _labels = [stages js_map:^UILabel *(NSString *stage) {
        UILabel *label = [[UILabel alloc] init];
        label.font = self.class.font;
        label.textColor = UIColor.js_Black;

        label.text = stage;
        [label sizeToFit];

        [self addSubview:label];
        return label;
    }];
}

- (void)alignLine:(NSArray *)line {
    CGFloat delta = (CGRectGetWidth(self.bounds) - CGRectGetMaxX([line.lastObject frame])) / 2.0;
    for (UIView *view in line) {
        CGRect frame = view.frame;
        frame.origin.x += delta;
        view.frame = frame;
    }
}

- (void)layoutLabels {
    static CGFloat const lineHeight = 17.0;
    static CGFloat const linePadding = 5.0;
    static CGFloat const wordPadding = 10.0;

    for (UIView *view in _separators) {
        [view removeFromSuperview];
    }

    NSMutableArray *line = [[NSMutableArray alloc] init];
    NSMutableArray *separators = [[NSMutableArray alloc] init];

    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGFloat width = CGRectGetWidth(self.bounds);

    for (UILabel *label in _labels) {
        CGFloat w = CGRectGetWidth(label.bounds);

        if (x + 2 * wordPadding + w < width) {

            if (line.count > 0) {

                [separators addObject:({

                    JSPxView *view = [[JSPxView alloc] initWithType:JSPxViewTypeVertical];
                    view.backgroundColor = UIColor.js_Separator;
                    [view sizeToFit];

                    view.frame = ({
                        CGRect frame = view.frame;
                        frame.origin.x = x + wordPadding;
                        frame.origin.y = y;
                        frame.size.height = lineHeight;
                        frame;
                    });

                    [self addSubview:view];
                    [line addObject:view];

                    view;
                })];

                x += 2 * wordPadding;
            }
        }
        else {
            [self alignLine:line];

            x = 0.0;
            y += lineHeight + linePadding;

            [line removeAllObjects];
        }

        label.frame = ({
            CGRect frame = label.frame;
            frame.origin.x = x;
            frame.origin.y = y;
            frame.size.height = lineHeight;
            frame;
        });

        x += w;

        [line addObject:label];
    }

    [self alignLine:line];

    _separators = separators.copy;
    _height = CGRectGetMaxY([line.lastObject frame]);
}

#pragma mark - UIView methods

- (void)layoutSubviews {
    [super layoutSubviews];

    if (ABS(CGRectGetWidth(self.bounds)) < DBL_EPSILON) {
        return;
    }

    if (ABS(CGRectGetWidth(self.bounds) - _cachedWidth) > DBL_EPSILON) {
        _cachedWidth = CGRectGetWidth(self.bounds);
        [self layoutLabels];
    }

    if (ABS(CGRectGetHeight(self.bounds) - _height) > DBL_EPSILON) {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(0.0, _height);
}

#pragma mark - Interface methods

- (void)setStages:(NSArray *)stages {
    _cachedWidth = 0.0;

    [self initLabels:stages];
    [self layoutSubviews];
}

@end
