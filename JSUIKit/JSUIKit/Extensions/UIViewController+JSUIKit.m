// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;

#import "UIViewController+JSUIKit.h"
#import "JSToastErrorView.h"

@implementation UIViewController (JSUIKit)

#pragma mark - Private methods

- (JSToastErrorView *)js_toast:(NSString *)error {
    JSToastErrorView *view = [[JSToastErrorView alloc] initWithError:error];

    JSWeakify(view);
    JSWeakify(self);

    view.onTap = ^{
        JSStrongify(view);
        JSStrongify(self);

        [self js_dismiss:view after:0.0];
    };

    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view(width)]" options:0 metrics:@{@"width": @(CGRectGetWidth(self.view.bounds))} views:NSDictionaryOfVariableBindings(view)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0@999-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

    return view;
}

- (void)js_show:(JSToastErrorView *)view with:(NSLayoutConstraint *)tempConstraint {
    JSWeakify(self);

    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        JSStrongify(self);

        [self.view removeConstraint:tempConstraint];
        [self.view layoutIfNeeded];

    } completion:nil];
}

- (void)js_dismiss:(JSToastErrorView *)view after:(NSTimeInterval)delay {
    JSWeakify(view);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delay), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{

            JSStrongify(view);
            view.alpha = 0.0;

        } completion:^(BOOL finished) {

            JSStrongify(view);
            [view removeFromSuperview];
        }];
    });
}

#pragma mark - Interface methods

- (void)js_showError:(NSString *)error {

    JSToastErrorView *toastErrorView = [self js_toast:error];

    NSLayoutConstraint *tempConstraint = [NSLayoutConstraint constraintWithItem:toastErrorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [self.view addConstraint:tempConstraint];

    [self js_show:toastErrorView with:tempConstraint];
    [self js_dismiss:toastErrorView after:4.0];
}

@end
