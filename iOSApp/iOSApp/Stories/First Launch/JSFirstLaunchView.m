// Created for BearDev by drif
// drif@mail.ru

#import "JSFirstLaunchView.h"
#import "UIColor+JS.h"

@implementation JSFirstLaunchView

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {

        self.backgroundColor = UIColor.whiteColor;

        UIActivityIndicatorView *activityIndicatorView = ({
            UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            view.color = UIColor.js_Black;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:@[
                    [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],
                    [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]
            ]];

            [view startAnimating];

            view;
        });

        UILabel *title = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColor.js_Black;
            label.font = [UIFont fontWithName:@"SFUIText-Semibold" size:14.0];
            label.text = NSLocalizedString(@"First launch", nil);

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[activityIndicatorView]-20-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label, activityIndicatorView)]];

            label;
        });

        {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColor.js_Black;
            label.font = [UIFont fontWithName:@"SFUIText-Regular" size:12.0];
            label.text = NSLocalizedString(@"Initializing data", nil);

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label, title)]];
        }
    }
    return self;
}

@end
