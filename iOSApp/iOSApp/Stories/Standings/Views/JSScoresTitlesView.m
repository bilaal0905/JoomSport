// Created for BearDev by drif
// drif@mail.ru

@import JSCore.JSStandingsViewModel;
@import JSUtils;
@import JSUIKit.UIColor_JSUIKit;

#import "JSScoresTitlesView.h"
#import "JSStandingsCellLayout.h"
#import "UIColor+JS.h"

static CGFloat const JSScoresTitlesViewHeight = 24;

@implementation JSScoresTitlesView {
    NSArray *_labels;
    JSStandingsCellLayout *_layout;
}

#pragma mark - UIView methods

- (void)layoutSubviews {
    [super layoutSubviews];

    for (NSUInteger i = 0; i < _labels.count; i++) {
        CGRect frame = [_layout scoreLabelFrame:i];
        frame.size.height = JSScoresTitlesViewHeight;
        [_labels[i] setFrame:frame];
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_layout.scoreCellWidth, JSScoresTitlesViewHeight);
}

#pragma mark - Interface methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Heavy" size:11.0]);
}

- (instancetype)initWithLayout:(JSStandingsCellLayout *)layout titles:(NSArray *)titles {
    JSParameterAssert(layout);
    JSParameterAssert(titles);

    self = [super init];
    if (self) {
        _layout = layout;

        _labels = [titles js_map:^UILabel *(NSString *title) {
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.font;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = title;
            label.textColor = [UIColor js_R:140 G:140 B:140];

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            return label;
        }];
    }
    return self;
}

@end
