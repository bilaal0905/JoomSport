// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore.JSExtraInfo;
@import JSHTTP.UIImageView_JSHTTP;

#import "JSPlayerStatisticCell.h"
#import "UIColor+JS.h"

static CGFloat const JSPlayerStatisticCellVerticalOffset = 12.0;
static CGFloat const JSPlayerStatisticCellHorizontalOffset = 13.0;

CGFloat const JSPlayerStatisticCellHeight = 39.0;
UIEdgeInsets const JSPlayerStatisticCellSeparatorInset = {0.0, JSPlayerStatisticCellHorizontalOffset, 0.0, 0.0};

@implementation JSPlayerStatisticCell {
    UILabel *_titleLabel;
    UILabel *_valueLabel;
    UIImageView *_imageView;
}

#pragma mark - Private methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Medium" size:12.0]);
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = JSPlayerStatisticCellSeparatorInset;

        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.font;
            label.textColor = UIColor.js_Black;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[label]" options:0 metrics:@{@"offset": @(JSPlayerStatisticCellHorizontalOffset - 1.0)} views:NSDictionaryOfVariableBindings(label)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[label]" options:0 metrics:@{@"offset": @(JSPlayerStatisticCellVerticalOffset)} views:NSDictionaryOfVariableBindings(label)]];

            label;
        });

        _imageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleAspectFit;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(15)]-(offset)-|" options:0 metrics:@{@"offset": @(JSPlayerStatisticCellHorizontalOffset)} views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[view]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });

        _valueLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.font;
            label.textColor = UIColor.js_Black;
            label.textAlignment = NSTextAlignmentRight;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label]-3-[_imageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label, _imageView)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[label]" options:0 metrics:@{@"offset": @(JSPlayerStatisticCellVerticalOffset)} views:NSDictionaryOfVariableBindings(label)]];

            label;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSExtraInfo *)info {
    JSParameterAssert(info);

    _titleLabel.text = info.name;
    _valueLabel.text = info.value;
    [_imageView js_setImage:info.imageURL after:nil];
}

@end
