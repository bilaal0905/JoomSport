// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSRoundedView.h"

@implementation JSRoundedView {
    UIView *_wrapper;
    CAShapeLayer *_shapeLayer;
    UIRectCorner _corners;
    CGSize _radii;
}

#pragma mark - Private methods

- (void)update {
    _shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:_corners cornerRadii:_radii].CGPath;

    if (_corners != 0 && !_wrapper.layer.mask) {
        _wrapper.layer.mask = _shapeLayer;
    }
    if (_corners == 0) {
        _wrapper.layer.mask = nil;
    }

    self.layer.shadowPath = _shapeLayer.path;
}

#pragma mark - UIView methods

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self update];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self update];
}

#pragma mark - Interface methods

- (instancetype)initWithView:(UIView *)view corners:(UIRectCorner)corners radius:(CGFloat)radius {
    JSParameterAssert(view);

    self = [super init];
    if (self) {
        _corners = corners;
        _radii = CGSizeMake(radius, radius);
        _shapeLayer = [[CAShapeLayer alloc] init];

        _wrapper = ({
            UIView *wrapperView = [[UIView alloc] init];

            wrapperView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:wrapperView];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[wrapperView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(wrapperView)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wrapperView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(wrapperView)]];

            wrapperView;
        });

        {
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [_wrapper addSubview:view];

            [_wrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [_wrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        }
    }
    return self;
}

- (void)setCorners:(UIRectCorner)corners {
    if (_corners == corners) {
        return;
    }
    _corners = corners;

    [self update];
}

@end
