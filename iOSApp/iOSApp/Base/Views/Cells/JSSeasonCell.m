// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSOnce;

#import "JSSeasonCell.h"
#import "UIColor+JS.h"

CGFloat const JSSeasonCellHeight = 40.0;

@implementation JSSeasonCell {
    UILabel *_seasonLabel;
}

#pragma mark - Private methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Medium" size:12.0]);
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        static CGFloat const offset = 13.0;

        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;

        UILabel *titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.font;
            label.textColor = UIColor.js_Black;
            label.text = NSLocalizedString(@"Season", nil);

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[label]" options:0 metrics:@{@"offset": @(offset - 1.0)} views:NSDictionaryOfVariableBindings(label)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(12)-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });

        _seasonLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.font;
            label.textColor = UIColor.js_Gray;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleLabel]-5-[label]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, label)]];

            label;
        });

        {
            UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_seasonLabel]-12-[view]-12-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_seasonLabel, view)]];
        }
    }
    return self;
}

#pragma mark - Interface methods

- (void)setSeasonName:(NSString *)name {
    _seasonLabel.text = name;
}

@end
