// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore.JSNews;
@import JSHTTP.UIImageView_JSHTTP;

#import "JSNewsCell.h"
#import "UIColor+JS.h"

CGFloat const JSNewsCellHeight = 80.0f;

@implementation JSNewsCell {
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_dateLabel;
}

#pragma mark - Private methods

+ (UIFont *)titleLabelFont {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Heavy" size:12.0]);
}

+ (UIFont *)dateLabelFont {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Medium" size:10.0]);
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;

        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;

            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:imageView];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[imageView]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2-[imageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1.75 constant:0.0]];

            imageView;
        });

        _dateLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColor.js_Gray;
            label.font = self.class.dateLabelFont;
            label.textAlignment = NSTextAlignmentLeft;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView]-8-[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView, label)]];

            label;
        });

        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColor.js_Black;
            label.font = self.class.titleLabelFont;
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[label]-(>=0)-[_dateLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label, _dateLabel)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView]-8-[label]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView, label)]];

            label;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSNews *)news {
    JSParameterAssert(news);

    [_imageView js_setImage:news.previewImageURL after:nil];
    _titleLabel.text = news.title;
    _dateLabel.text = news.date;
}

@end
