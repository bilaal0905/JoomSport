// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit;
@import JSUtils.JSOnce;
@import JSCore.JSGameStatistic;

#import "JSGameStatisticCell.h"
#import "UIColor+JS.h"

CGFloat const JSGameStatisticCellHeight = 63.0;

@implementation JSGameStatisticCell {
    JSProgressBar *_homeBar;
    JSProgressBar *_awayBar;
    
    UILabel *_homeLabel;
    UILabel *_awayLabel;
    UILabel *_titleLabel;
}

#pragma mark - Private methods

+ (UIColor *)barColor {
    JSOnceSetReturn(UIColor *, color, [UIColor js_R:230 G:230 B:230]);
}

+ (UIFont *)barFont {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Medium" size:10.0]);
}

+ (UIFont *)titleFont {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Medium" size:12.0]);
}

+ (JSProgressBar *)progressBar:(UIView *)view {
    JSProgressBar *bar = [[JSProgressBar alloc] init];
    bar.backgroundColor = self.barColor;
    bar.barColor = UIColor.js_Green;

    bar.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:bar];

    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bar(3)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bar)]];
    [view addConstraints:@[
            [NSLayoutConstraint constraintWithItem:bar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:0.23 constant:0.0],
            [NSLayoutConstraint constraintWithItem:bar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:5.0]
    ]];

    return bar;
}

+ (UILabel *)progressTitle:(JSProgressBar *)bar {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = self.barFont;
    label.textColor = UIColor.js_Black;

    label.translatesAutoresizingMaskIntoConstraints = NO;
    [bar.superview addSubview:label];

    [bar.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-5-[bar]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label, bar)]];
    [bar.superview addConstraints:@[
            [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bar attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
            [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bar attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]
    ]];

    return label;
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;

        _homeBar = ({
            JSProgressBar *bar = [self.class progressBar:self.contentView];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[bar]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bar)]];
            bar;
        });

        _awayBar = ({
            JSProgressBar *bar = [self.class progressBar:self.contentView];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[bar]-22-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bar)]];
            bar;
        });

        _homeLabel = [self.class progressTitle:_homeBar];
        _awayLabel = [self.class progressTitle:_awayBar];

        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.titleFont;
            label.textColor = UIColor.js_Gray;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_homeBar]-5-[label]-5-[_awayBar]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_homeBar, label, _awayBar)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=5)-[label]-(>=5)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSGameStatistic *)statistic {
    _homeBar.progress = statistic.homeValue;
    _awayBar.progress = statistic.awayValue;
    
    _homeLabel.text = statistic.home;
    _awayLabel.text = statistic.away;

    _titleLabel.text = statistic.title;
}

@end
