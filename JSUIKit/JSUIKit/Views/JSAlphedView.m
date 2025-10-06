// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSAlphedView.h"

@implementation JSAlphedView {
    CGFloat _alphaWidth;
    JSAlphedViewDirection _direction;
}

#pragma mark - Private methods

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *) self.layer.mask;
}

- (void)invalidate {
    self.gradientLayer.frame = self.bounds;

    switch (_direction) {

        case JSAlphedViewDirectionLeft:
            self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
            self.gradientLayer.endPoint = CGPointMake(_alphaWidth / CGRectGetWidth(self.bounds), 0.0);
            break;

        case JSAlphedViewDirectionRight:
            self.gradientLayer.startPoint = CGPointMake(1.0, 0.0);
            self.gradientLayer.endPoint = CGPointMake(1.0 - (_alphaWidth / CGRectGetWidth(self.bounds)), 0.0);
            break;
    }
}

#pragma mark - UIView methods

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self invalidate];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self invalidate];
}

#pragma mark - Interface methods

- (instancetype)initWithView:(UIView *)view direction:(JSAlphedViewDirection)direction {
    JSParameterAssert(view);

    self = [super init];
    if (self) {
        _direction = direction;

        self.layer.mask = ({
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.colors = @[
                    (id) UIColor.clearColor.CGColor,
                    (id) UIColor.whiteColor.CGColor
            ];
            gradientLayer;
        });

        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

        [self setAlphaWidth:0.0];
    }
    return self;
}

- (void)setAlphaWidth:(CGFloat)alphaWidth {
    JSParameterAssert(alphaWidth >= 0.0);

    CGFloat width = MAX(3.0, alphaWidth);

    if (ABS(_alphaWidth - width) < DBL_EPSILON) {
        return;
    }

    _alphaWidth = width;
    [self invalidate];
}

@end
