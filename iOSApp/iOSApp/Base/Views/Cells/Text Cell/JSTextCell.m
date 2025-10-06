// Created for BearDev by drif
// drif@mail.ru

//@import JSUtils.JSLog;
#import "/Users/user/Downloads/BaernerCup/BaernerCup 2023/JSUtils/JSUtils/JSUtils.h"

#import "JSTextCell.h"
#import "JSTextCellLayout.h"
#import "UIColor+JS.h"

@implementation JSTextCell {
    UILabel *_label;
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsMake(0.0, HUGE_VALF, 0.0, 0.0);

        _label = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColor.js_Black;
            label.numberOfLines = 0;

            [self.contentView addSubview:label];

            label;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSTextCellLayout *)layout {
    JSParameterAssert(layout);

    _label.frame = layout.labelFrame;
    _label.attributedText = layout.text;
}

@end
