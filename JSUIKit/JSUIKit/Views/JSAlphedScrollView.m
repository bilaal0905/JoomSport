// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSKeyPathObserver;
@import JSUtils.JSScope;

#import "JSAlphedScrollView.h"
#import "JSAlphedView.h"

@implementation JSAlphedScrollView {
    JSAlphedView *_leftRightAlphaView;
    JSAlphedView *_rightLeftAlphaView;
    UIScrollView *_scrollView;

    JSKeyPathObserver *_scrollViewObserver;
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _leftRightAlphaView = [[JSAlphedView alloc] initWithView:_scrollView direction:JSAlphedViewDirectionLeft];

        _rightLeftAlphaView = ({
            JSAlphedView *view = [[JSAlphedView alloc] initWithView:_leftRightAlphaView direction:JSAlphedViewDirectionRight];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });

        JSWeakify(self);
        _scrollViewObserver = [JSKeyPathObserver observerFor:_scrollView keyPath:@"contentOffset" handler:^{
            JSStrongify(self);

            static CGFloat const alphaWidth = 50.0;

            self->_leftRightAlphaView.alphaWidth = MAX(0.0, MIN(alphaWidth, self->_scrollView.contentOffset.x));
            self->_rightLeftAlphaView.alphaWidth = MAX(0.0, MIN(alphaWidth, self->_scrollView.contentSize.width - CGRectGetWidth(self->_scrollView.frame) - self->_scrollView.contentOffset.x));
        }];
    }
    return self;
}

#pragma mark - Interface methods

- (UIScrollView *)scrollView {
    return _scrollView;
}

@end
