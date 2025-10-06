// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSBlock;

#import "JSSegmentedBarItem.h"

@implementation JSSegmentedBarItem {
    UILabel *_label;
    UIView *_line;

    UIColor *_activeColor;
    UIColor *_inactiveColor;

    BOOL _isSelected;
}

#pragma mark - Private methods

- (void)update {
    _label.textColor = _isSelected ? _activeColor : _inactiveColor;
    _line.backgroundColor = _isSelected ? _activeColor : UIColor.clearColor;
}

- (void)onTapRecognizer {
    JSBlock(self.onTap, self);
}

#pragma mark - Interface methods

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {

        _label = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = title;
            label.font = [UIFont systemFontOfSize:12.0];

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:label];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

            label;
        });

        _line = ({
            UIView *view = [[UIView alloc] init];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(1.5)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:@[
                    [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_label attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
                    [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_label attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]
            ]];

            view;
        });

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapRecognizer)]];
    }
    return self;
}

- (void)setFontName:(NSString *)fontName {
    _label.font = [UIFont fontWithName:fontName size:_label.font.pointSize];
}

- (void)setActiveColor:(UIColor *)color {
    _activeColor = color;
    [self update];
}

- (void)setInactiveColor:(UIColor *)color {
    _inactiveColor = color;
    [self update];
}

- (void)setSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    [self update];
}

@end
