// Created for BearDev by drif
// drif@mail.ru

#import "JSNavigationController.h"

@implementation JSNavigationController

#pragma mark - UIViewController methods

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.viewControllers.lastObject;
}

@end
