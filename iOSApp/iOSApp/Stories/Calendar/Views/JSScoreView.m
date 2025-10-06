// Created for BearDev by drif
// drif@mail.ru

#import "JSScoreView.h"
#import "UIColor+JS.h"

@implementation JSScoreView {
    UILabel *_home;
    UILabel *_away;
}

#pragma mark - Interface methods

- (instancetype)initWithSize:(CGFloat)size {
    self = [super init];
    if (self) {

        UILabel *middle = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont fontWithName:@"SFUIDisplay-Black" size:size];
            label.textColor = UIColor.js_Black;
            label.text = @" - ";

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[label]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            [self addConstraints:@[
                    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],
                    [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]
            ]];

            label;
        });

        _home = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = middle.font;
            label.textColor = middle.textColor;
            label.textAlignment = NSTextAlignmentRight;
            label.adjustsFontSizeToFitWidth = YES;
            label.minimumScaleFactor = 0.3;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label][middle]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label, middle)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });

        _away = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = middle.font;
            label.textColor = middle.textColor;
            label.textAlignment = NSTextAlignmentLeft;
            label.adjustsFontSizeToFitWidth = YES;
            label.minimumScaleFactor = 0.3;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[middle][label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label, middle)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

            label;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (UILabel *)home {
    return _home;
}

- (UILabel *)away {
    return _away;
}

@end
