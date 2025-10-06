// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSOnce;

#import "JSSettingsSectionHeader.h"
#import "UIColor+JS.h"

CGFloat const JSSettingsSectionHeaderHeight = 32.0;

@implementation JSSettingsSectionHeader {
    UILabel *_label;
}

#pragma mark - Private methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Medium" size:11.0]);
}

#pragma mark - UITableViewHeaderFooterView methods

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {

        _label = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColor.js_Gray;
            label.font = self.class.font;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[label]-6-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setText:(NSString *)text {
    _label.text = text;
}

@end
