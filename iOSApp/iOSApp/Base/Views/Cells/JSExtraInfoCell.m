// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore.JSExtraInfo;
@import JSHTTP.UIImageView_JSHTTP;

#import "JSExtraInfoCell.h"
#import "UIColor+JS.h"

static CGFloat const JSExtraInfoCellVerticalOffset = 12.0;
static CGFloat const JSExtraInfoCellHorizontalOffset = 13.0;

CGFloat const JSExtraInfoCellHeight = 39.0;
UIEdgeInsets const JSExtraInfoCellSeparatorInset = {0.0, JSExtraInfoCellHorizontalOffset, 0.0, 0.0};

@implementation JSExtraInfoCell {
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
        self.separatorInset = JSExtraInfoCellSeparatorInset;

        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.font;
            label.textColor = UIColor.js_Black;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[label]" options:0 metrics:@{@"offset": @(JSExtraInfoCellHorizontalOffset - 1.0)} views:NSDictionaryOfVariableBindings(label)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[label]" options:0 metrics:@{@"offset": @(JSExtraInfoCellVerticalOffset)} views:NSDictionaryOfVariableBindings(label)]];

            label;
        });

        _valueLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.font;
            label.textColor = UIColor.js_Gray;
            label.textAlignment = NSTextAlignmentRight;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_titleLabel]-5-[label]-(offset)-|" options:0 metrics:@{@"offset": @(JSExtraInfoCellHorizontalOffset - 1)} views:NSDictionaryOfVariableBindings(_titleLabel, label)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[label]" options:0 metrics:@{@"offset": @(JSExtraInfoCellVerticalOffset)} views:NSDictionaryOfVariableBindings(label)]];

            label;
        });

        _imageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleAspectFit;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-(offset)-|" options:0 metrics:@{@"offset": @(JSExtraInfoCellHorizontalOffset - 1)} views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[view]-(offset)-|" options:0 metrics:@{@"offset": @(JSExtraInfoCellVerticalOffset)} views:NSDictionaryOfVariableBindings(view)]];

            view;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSExtraInfo *)info {
    JSParameterAssert(info);

    _titleLabel.text = info.name;
    _valueLabel.text = info.url.absoluteString ?: info.value;
    [_imageView js_setImage:info.imageURL after:nil];
}

@end
