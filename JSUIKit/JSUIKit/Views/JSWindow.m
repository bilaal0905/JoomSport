// Created for BearDev by drif
// drif@mail.ru

#import "JSWindow.h"

@interface JSWindow ()

@property (nonatomic, weak) UIView *launchScreenView;

@end

@implementation JSWindow

#pragma mark - UIView methods

- (void)addSubview:(UIView *)view {
    if (self.launchScreenView != nil && self.launchScreenView != view) {
        [self insertSubview:view belowSubview:self.launchScreenView];
    }
    else {
        [super addSubview:view];
    }
}

#pragma mark - Interface methods

- (void)js_showLaunchScreen:(NSTimeInterval)duration {
    self.launchScreenView = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil].instantiateInitialViewController.view;
    //self.launchScreenView.backgroundColor = UIColor.yellowColor;

    [self addSubview:self.launchScreenView];
    [self bringSubviewToFront:self.launchScreenView];
    self.launchScreenView.frame = self.bounds;

    [UIView animateWithDuration:0.2 delay:duration options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.launchScreenView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.launchScreenView removeFromSuperview];
    }];
}

@end
