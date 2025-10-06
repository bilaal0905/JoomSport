// Created for BearDev by drif
// drif@mail.ru

#import "JSSettingsSwitchCell.h"

@implementation JSSettingsSwitchCell {
    UISwitch *_switch;
    UIActivityIndicatorView *_spinner;
}

#pragma mark - Private methods

- (void)onSwitchTap {
    JSBlock(self.onSwitch, nil);
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _spinner = ({
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

            spinner.translatesAutoresizingMaskIntoConstraints = NO;
            [self.actionView addSubview:spinner];

            spinner;
        });

        _switch = ({
            UISwitch *view = [[UISwitch alloc] init];
            [view addTarget:self action:@selector(onSwitchTap) forControlEvents:UIControlEventValueChanged];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.actionView addSubview:view];

            [self.actionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.actionView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
            [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_spinner attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
            [self.actionView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_spinner attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

            view;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setStatus:(JSSettingsSwitchCellStatus)status {

    switch(status) {

        case JSSettingsSwitchCellStatusOn:
            [_spinner stopAnimating];
            _switch.hidden = NO;
            _switch.on = YES;
            break;

        case JSSettingsSwitchCellStatusOff:
            [_spinner stopAnimating];
            _switch.hidden = NO;
            _switch.on = NO;
            break;

        case JSSettingsSwitchCellStatusInProgress:
            [_spinner startAnimating];
            _switch.hidden = YES;
            break;
    }
}

@end
