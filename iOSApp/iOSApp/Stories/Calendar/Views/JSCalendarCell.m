// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit;
@import JSCore;
@import JSUtils;

#import "JSCalendarCell.h"
#import "JSSubtitledLogoView.h"
#import "JSScoreView.h"
#import "JSLogoView.h"
#import "UIColor+JS.h"

CGFloat const JSCalendarCellHeight = 108.0;

@implementation JSCalendarCell {
    UILabel *_dateLabel;
    JSSubtitledLogoView *_homeLogoView;
    JSSubtitledLogoView *_awayLogoView;
    JSScoreView *_scoreView;
}

#pragma mark - Private methods

+ (UIFont *)dateLabelFont {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Medium" size:10.0]);
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        static CGFloat const logoSize = 42.0;
        static CGFloat const titleFontSize = 11.0;
        static CGFloat const titlePadding = 7.0;

        self.backgroundColor = UIColor.clearColor;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;

        _dateLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColor.js_Gray;
            label.font = self.class.dateLabelFont;
            label.textAlignment = NSTextAlignmentCenter;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];

            [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-11-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });

        _homeLogoView = ({
            JSSubtitledLogoView *view = [[JSSubtitledLogoView alloc] initWithLogoSize:logoSize fontSize:titleFontSize padding:titlePadding];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[view(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_dateLabel]-8-[view]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dateLabel, view)]];

            view;
        });

        _awayLogoView = ({
            JSSubtitledLogoView *view = [[JSSubtitledLogoView alloc] initWithLogoSize:logoSize fontSize:titleFontSize padding:titlePadding];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(100)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_dateLabel]-8-[view]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dateLabel, view)]];

            view;
        });

        _scoreView = ({
            JSScoreView *view = [[JSScoreView alloc] initWithSize:22.0];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_homeLogoView][view][_awayLogoView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_homeLogoView, view, _awayLogoView)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_dateLabel]-16-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dateLabel, view)]];

            view;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSGame *)game {
    JSParameterAssert(game);

    _dateLabel.text = [NSString stringWithFormat: @"%@     %@", game.dateString, game.mdayString];

    _scoreView.home.text = game.home.score;
    _scoreView.away.text = game.away.score;
    
    _homeLogoView.label.text = game.home.name;
    [_homeLogoView.logoView setURL:game.home.logoURL placeholder:game.placeholder];

    _awayLogoView.label.text = game.away.name;
    [_awayLogoView.logoView setURL:game.away.logoURL placeholder:game.placeholder];
}

@end
