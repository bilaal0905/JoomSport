// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore.JSTeam;
@import JSUIKit.JSRoundedView;

#import "JSSettingsTeamCell.h"
#import "JSLogoView.h"
#import "UIColor+JS.h"

CGFloat const JSSettingsTeamCellHeight = 68.0;

@implementation JSSettingsTeamCell {
    JSRoundedView *_content;
    JSLogoView *_logoView;
    UILabel *_title;
    UIImageView *_checkmark;
    UIActivityIndicatorView *_spinner;
}

#pragma mark - Private methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Semibold" size:14.0]);
}

- (void)onTap {
    _checkmark.highlighted = !_checkmark.highlighted;
    JSBlock(self.onChange, nil);
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsMake(0.0, 25.0, 0.0, 12.0);

        UIView *contentView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = UIColor.whiteColor;
            view;
        });

        _content = ({
            JSRoundedView *view = [[JSRoundedView alloc] initWithView:contentView corners:UIRectCornerAllCorners radius:8.0];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[view]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]-(-1)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });

        _logoView = ({
            JSLogoView *view = [[JSLogoView alloc] init];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [contentView addSubview:view];

            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[view(42)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(42)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

            view;
        });

        _title = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.font;
            label.textColor = UIColor.js_Black;
            label.numberOfLines = 0;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [contentView addSubview:label];

            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_logoView]-10-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_logoView, label)]];
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[label]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });

        _checkmark = ({
            UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_checkmark_unchecked"] highlightedImage:[UIImage imageNamed:@"cell_checkmark_checked"]];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [contentView addSubview:view];

            [view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_title]-5-[view]-13-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_title, view)]];
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

            view;
        });

        _spinner = ({
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

            spinner.translatesAutoresizingMaskIntoConstraints = NO;
            [contentView addSubview:spinner];

            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_checkmark attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_checkmark attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

            spinner;
        });

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSTeam *)team {
    JSParameterAssert(team);

    _title.text = team.name;
    [_logoView setURL:team.logoURL placeholder:team.placeholder];
}

- (void)roundTop:(BOOL)top bottom:(BOOL)bottom {
    UIRectCorner corners = (UIRectCorner) 0;
    if (top) {
        corners = (UIRectCorner) (corners | UIRectCornerTopLeft | UIRectCornerTopRight);
    }
    if (bottom) {
        corners = (UIRectCorner) (corners | UIRectCornerBottomLeft | UIRectCornerBottomRight);
    }
    _content.corners = corners;
}

- (void)setStatus:(JSSettingsTeamCellStatus)status {

    switch (status) {

        case JSSettingsTeamCellStatusOn:
            [_spinner stopAnimating];
            _checkmark.hidden = NO;
            _checkmark.highlighted = YES;
            break;

        case JSSettingsTeamCellStatusOff:
            [_spinner stopAnimating];
            _checkmark.hidden = NO;
            _checkmark.highlighted = NO;
            break;

        case JSSettingsTeamCellStatusInProgress:
            [_spinner startAnimating];
            _checkmark.hidden = YES;
            break;
    }
}

@end
