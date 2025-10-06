// Created for BearDev by drif
// drif@mail.ru

#import "JSTableViewController.h"

#if defined(DEBUG)

    #import "JSViewController.h"

    @interface JSViewController (Private)

    + (BOOL)debugDesign_IsDebugDesign;
    + (UIImageView *)debugDesign_ImageView;

    @end

#endif

@implementation JSTableViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>) self;
}

#if defined(DEBUG)

    - (void)viewDidAppear:(BOOL)animated {
        [super viewDidAppear:animated];

        if (JSViewController.debugDesign_IsDebugDesign) {
            JSViewController.debugDesign_ImageView.image = [UIImage imageNamed:NSStringFromClass(self.class)];
        }
    }

    - (void)viewWillDisappear:(BOOL)animated {
        [super viewWillDisappear:animated];

        if (JSViewController.debugDesign_IsDebugDesign) {
            JSViewController.debugDesign_ImageView.image = nil;
        }
    }

#endif

@end
