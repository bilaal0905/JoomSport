// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore.JSPlayer;

#import "JSTeamPlayerCell.h"
#import "JSLogoView.h"
#import "UIColor+JS.h"

CGFloat const JSTeamPlayerCellHeight = 60.0;

@implementation JSTeamPlayerCell {
    JSLogoView *_logo;
    UILabel *_label;
}

#pragma mark - Private methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Medium" size:12.0]);
}

#pragma mark - UIView methods

- (void)layoutSubviews {
    [super layoutSubviews];
    self.separatorInset = UIEdgeInsetsMake(0.0, CGRectGetMinX(_label.frame), 0.0, 0.0);
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.preservesSuperviewLayoutMargins = NO;

        _logo = ({
            JSLogoView *view = [[JSLogoView alloc] init];
            view.multiplier = 1.0;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[view]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];

            view;
        });

        _label = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.font = self.class.font;
            label.textColor = UIColor.js_Black;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_logo]-7-[label]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_logo, label)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSPlayer *)player {
    JSParameterAssert(player);

    _label.text = player.name;
    [_logo setURL:player.photoURL placeholder:player.placeholder];
}

@end
