// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSOnce;
@import JSUIKit.UIColor_JSUIKit;

#import "JSGroupSectionHeaderView.h"
#import "UIColor+JS.h"

CGFloat const JSGroupSectionHeaderViewHeight = 20.0;
static CGFloat const JSGroupSectionHeaderViewLabelLeftPadding = 15.0;

@implementation JSGroupSectionHeaderView {
    UILabel *_label;
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 20.0, JSGroupSectionHeaderViewHeight)];
    if (self) {
        self.backgroundColor = [UIColor js_R:247 G:247 B:247];

        _label = ({
            CGRect rect = CGRectZero;
            rect.origin.x = JSGroupSectionHeaderViewLabelLeftPadding;
            rect.size.width = CGRectGetWidth(self.bounds) - rect.origin.x;
            rect.size.height = JSGroupSectionHeaderViewHeight;

            UILabel *label = [[UILabel alloc] initWithFrame:rect];
            label.font = [UIFont fontWithName:@"SFUIText-Heavy" size:11.0];
            label.textColor = [UIColor js_R:140 G:140 B:140];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

            [self addSubview:label];

            label;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (UILabel *)label {
    return _label;
}

- (void)setContentOffset:(CGFloat)offset {
    CGRect rect = _label.frame;
    rect.origin.x = JSGroupSectionHeaderViewLabelLeftPadding + offset;
    rect.size.width = CGRectGetWidth(self.bounds) - rect.origin.x;
    _label.frame = rect;
}

@end
