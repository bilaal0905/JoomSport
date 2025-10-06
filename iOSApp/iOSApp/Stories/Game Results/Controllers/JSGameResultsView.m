// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit.JSRoundedView;
@import JSCore;
@import JSUtils;

#import "JSGameResultsView.h"
#import "JSBackButton.h"
#import "UIColor+JS.h"
#import "JSSubtitledLogoView.h"
#import "JSScoreView.h"
#import "JSGameStagesView.h"
#import "UIView+JS.h"
#import "JSLogoView.h"

@implementation JSGameResultsView {
    JSBackButton *_backButton;
    UIView *_segmentedControllerContainer;
    
    UILabel *_dateLabel;
    UILabel *_venueLabel;

    JSSubtitledLogoView *_homeLogo;
    JSSubtitledLogoView *_awayLogo;
    
    JSScoreView *_scoreView;
    JSGameStagesView *_stagesView;
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {

        static CGFloat const logoSize = 60.0;
        static CGFloat const titleFontSize = 13.0;
        static CGFloat const titlePadding = 10.0;

        _backButton = ({
            JSBackButton *backButton = [JSBackButton button:UIColor.js_Green];

            backButton.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:backButton];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[backButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backButton)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[backButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backButton)]];

            backButton;
        });

        UILabel *titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = NSLocalizedString(@"Match Results", nil);
            label.font = [UIFont fontWithName:@"SFUIText-Semibold" size:14.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColor.js_Black;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });

        _dateLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont fontWithName:@"SFUIText-Medium" size:12.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColor.js_Gray;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-24-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, label)]];

            label;
        });

        _venueLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont fontWithName:@"SFUIText-Medium" size:12.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColor.js_Gray;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_dateLabel]-3-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dateLabel, label)]];

            label;
        });

        _homeLogo = ({
            JSSubtitledLogoView *view = [[JSSubtitledLogoView alloc] initWithLogoSize:logoSize fontSize:titleFontSize padding:titlePadding];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[view(118)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_venueLabel]-20-[view(<=110)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_venueLabel, view)]];

            view;
        });

        _awayLogo = ({
            JSSubtitledLogoView *view = [[JSSubtitledLogoView alloc] initWithLogoSize:logoSize fontSize:titleFontSize padding:titlePadding];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(118)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_venueLabel]-20-[view(<=110)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_venueLabel, view)]];

            view;
        });

        _scoreView = ({
            JSScoreView *view = [[JSScoreView alloc] initWithSize:33.0];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_homeLogo][view][_awayLogo]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_homeLogo, view, _awayLogo)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_venueLabel]-32-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_venueLabel, view)]];

            view;
        });

        _stagesView = ({
            JSGameStagesView *view = [[JSGameStagesView alloc] init];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[view]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_homeLogo]-13-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_homeLogo, view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_awayLogo]-13-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_awayLogo, view)]];

            view;
        });

        _segmentedControllerContainer = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = UIColor.whiteColor;
            view;
        });

        __unused JSRoundedView *roundedContainer = ({
            JSRoundedView *view = [[JSRoundedView alloc] initWithView:_segmentedControllerContainer corners:(UIRectCorner) (UIRectCornerTopLeft | UIRectCornerTopRight) radius:6.0];
            [view js_setupShadow];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[view]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_stagesView]-21-[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stagesView, view)]];

            view;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSGame *)game {
    JSParameterAssert(game);
    
    _dateLabel.text = [NSString stringWithFormat: @"%@     %@", game.dateString, game.mdayString];
    _venueLabel.text = game.venue;

    _homeLogo.label.text = game.home.name;
    [_homeLogo.logoView setURL:game.home.logoURL placeholder:game.placeholder];

    _awayLogo.label.text = game.away.name;
    [_awayLogo.logoView setURL:game.away.logoURL placeholder:game.placeholder];
    
    _scoreView.home.text = game.home.score;
    _scoreView.away.text = game.away.score;

    _stagesView.stages = game.stages;
}

- (JSBackButton *)backButton {
    return _backButton;
}

- (JSSubtitledLogoView *)homeLogo {
    return _homeLogo;
}

- (JSSubtitledLogoView *)awayLogo {
    return _awayLogo;
}

- (UIView *)segmentedControllerContainer {
    return _segmentedControllerContainer;
}

@end
