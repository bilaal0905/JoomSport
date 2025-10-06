// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore.JSGameEvent;
@import JSHTTP.UIImageView_JSHTTP;

#import "JSGameEventCell.h"
#import "UIColor+JS.h"

CGFloat const JSGameEventCellHeight = 39.0f;

@implementation JSGameEventCell {
    UIImageView *_icon;

    UILabel *_homePlayer;
    UILabel *_homeMinute;

    UILabel *_awayPlayer;
    UILabel *_awayMinute;
}

#pragma mark - Private methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Medium" size:12.0]);
}

+ (UILabel *)playerLabel:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor.js_Gray;
    label.font = self.class.font;
    label.numberOfLines = 0;

    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];

    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

    return label;
}

+ (UILabel *)minuteLabel:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor.js_Black;
    label.font = self.class.font;

    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];

    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

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

        _icon = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;

            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:imageView];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-11-[imageView]-11-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
            [self.contentView addConstraints:@[
                    [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],
                    [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]
            ]];

            imageView;
        });

        _homePlayer = ({
            UILabel *label = [self.class playerLabel:self.contentView];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            label;
        });

        _homeMinute = ({
            UILabel *label = [self.class minuteLabel:self.contentView];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_homePlayer]-13-[label]-(>=5)-[_icon]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_homePlayer, label, _icon)]];
            label;
        });

        _awayPlayer = ({
            UILabel *label = [self.class playerLabel:self.contentView];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_icon]-(>=5)-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_icon, label)]];
            label;
        });

        _awayMinute = ({
            UILabel *label = [self.class minuteLabel:self.contentView];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_awayPlayer]-16-[label]-14-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_awayPlayer, label)]];
            label;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSGameEvent *)event {
    JSParameterAssert(event);

    [_icon js_setImage:event.iconURL after:nil];

    _homePlayer.text = event.isHome ? event.playerName : nil;
    _homeMinute.text = event.isHome ? [event.minute.stringValue stringByAppendingString:@"´"] : nil;

    _awayPlayer.text = event.isHome ? nil : event.playerName;
    _awayMinute.text = event.isHome ? nil : [event.minute.stringValue stringByAppendingString:@"´"];
}

@end
