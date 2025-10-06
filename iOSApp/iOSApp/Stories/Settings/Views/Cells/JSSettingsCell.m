// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSOnce;

#import "JSSettingsCell.h"
#import "UIColor+JS.h"

CGFloat const JSSettingsCellHeight = 40.0;

@implementation JSSettingsCell {
    UILabel *_label;
    UIView *_actionView;
}

#pragma mark - Private methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Medium" size:14.0]);
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _label = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColor.js_Black;
            label.font = self.class.font;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });

        _actionView = ({
            UIView *view = [[UIView alloc] init];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_label]-5-[view]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label, view)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setTitle:(NSString *)title {
    _label.text = title;
}

- (UIView *)actionView {
    return _actionView;
}

@end
