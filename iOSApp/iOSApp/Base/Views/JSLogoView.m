// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit;
@import JSUtils;
@import JSHTTP;

#import "JSLogoView.h"
#import "UIView+JS.h"

@implementation JSLogoView {
    NSURL *_url;
    NSURL *_placeholder;
    CGFloat _multiplier;
    CGSize _cachedSize;
    BOOL _isInvalid;
}

#pragma mark - Private methods

- (CGSize)imageSize {
    return CGSizeMake(CGRectGetWidth(self.bounds) * _multiplier, CGRectGetHeight(self.bounds) * _multiplier);
}

- (void)update:(CGSize)size {
    if (!_isInvalid && CGSizeEqualToSize(_cachedSize, size)) {
        return;
    }

    _cachedSize = size;
    [self update];
}

- (void)update {
    self.layer.cornerRadius = 4.0;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;

    CGFloat radius = (CGRectGetWidth(self.bounds) - self.imageSize.width < self.layer.cornerRadius * 2.0) ? self.layer.cornerRadius : 0.0;

    JSWeakify(self);
    [self js_setImage:(_url ?: _placeholder) after:^UIImage *(UIImage *original) {
        JSStrongify(self);

        __block CGSize imageSize;
        dispatch_sync(dispatch_get_main_queue(), ^{
            imageSize = self.imageSize;
        });

        if (!original) {
            [self js_setImage:self->_placeholder after:^UIImage *(UIImage *placeholder) {
                return [placeholder js_of:imageSize by:radius];
            }];
        }

        return [original js_of:imageSize by:radius];
    }];

    _isInvalid = NO;
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _multiplier = 33.5 / 42.0;

        self.backgroundColor = UIColor.whiteColor;
        self.contentMode = UIViewContentModeCenter;

        [self js_setupShadow];
    }
    return self;
}

#pragma mark - UIView methods

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self update:self.bounds.size];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self update:self.bounds.size];
}

#pragma mark - UIImageView methods

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:UIColor.whiteColor];
}

#pragma mark - Interface methods

- (void)setURL:(NSURL *)url placeholder:(NSURL *)placeholder {
    if ([_url isEqual:url]) {
        return;
    }

    _url = url;
    _placeholder = placeholder;
    _isInvalid = YES;

    [self update];
}

- (void)setMultiplier:(CGFloat)multiplier {
    _multiplier = multiplier;
    _isInvalid = YES;

    [self update];
}

@end
