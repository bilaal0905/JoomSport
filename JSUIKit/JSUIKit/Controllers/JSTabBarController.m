// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;

#import "JSTabBarController.h"
#import "JSPxView.h"

//#define JSTabBarControllerBarHeight (JSIsIphoneX ? 64.0 : 41.0)
#define JSTabBarControllerBarHeight \
(74.0 + UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom)

@interface JSTabBarController () <UITabBarDelegate>
@end
@implementation JSTabBarController {
    UITabBarController *_tabBarController;

    UITabBar *_tabBar;
    JSPxView *_separator;

    JSKeyPathObserver *_observer;
    UIColor *_color;
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.tabBar.hidden = YES;
    }
    return self;
}

#pragma mark - UIViewController methods

- (void)loadView {
    [super loadView];

    _tabBar = ({
        UITabBar *tabBar = [[UITabBar alloc] init];
        tabBar.delegate = self; // 👈 Add this bilal
        tabBar.translucent = NO;

        tabBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:tabBar];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tabBar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tabBar)]];
        if (@available(iOS 11.0, *)) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tabBar(height)]|" options:0 metrics:@{@"height": @(JSTabBarControllerBarHeight)} views:NSDictionaryOfVariableBindings(tabBar)]];
        } else {
            // Fallback on earlier versions
        }

        tabBar;
    });

    _separator = ({
        JSPxView *view = [[JSPxView alloc] initWithType:JSPxViewTypeHorizontal];
        view.backgroundColor = _color;

        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:view];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

        view;
    });

    {
        [self addChildViewController:_tabBarController];

        _tabBarController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_tabBarController.view];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _tabBarController.view}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view][separator][tabBar]" options:0 metrics:nil views:@{@"view": _tabBarController.view, @"tabBar": _tabBar, @"separator": _separator}]];

        [_tabBarController didMoveToParentViewController:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    JSWeakify(self);

    _observer = [JSKeyPathObserver observerFor:_tabBarController keyPath:@"tabBar.items" handler:^{
        JSStrongify(self);
        [self setupItems];
    }];
    [self setupItems];

    _observer = [JSKeyPathObserver observerFor:_tabBarController keyPath:@"tabBar.barTintColor" handler:^{
        JSStrongify(self);
        self->_tabBar.barTintColor = self->_tabBarController.tabBar.barTintColor;
    }];
    _tabBar.barTintColor = _tabBarController.tabBar.barTintColor;

    _observer = [JSKeyPathObserver observerFor:_tabBarController keyPath:@"tabBar.selectedItem" handler:^{
        JSStrongify(self);
        self->_tabBar.selectedItem = self->_tabBarController.tabBar.selectedItem;
    }];
    _tabBar.selectedItem = _tabBarController.tabBar.selectedItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupItems];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return _tabBarController.selectedViewController;
}

#pragma mark - Interface methods

- (void)setupItems {//Changes in function By Bilal
    for (UITabBarItem *item in _tabBarController.tabBar.items) {
        UIEdgeInsets insets = item.imageInsets;
        if (@available(iOS 11.0, *)) {
            insets.top = 10;
        } else {
            // Fallback on earlier versions
        }
        insets.bottom = -insets.top;
        item.imageInsets = insets;
    }
    _tabBar.items = _tabBarController.tabBar.items;
    _tabBar.selectedItem = _tabBarController.tabBar.selectedItem;
}
//- (void)setupItems {
//    for (UITabBarItem *item in _tabBarController.tabBar.items) {
//        UIEdgeInsets insets = item.imageInsets;
//        insets.top = round((JSTabBarControllerBarHeight - item.image.size.height) / 4.0) + 1.0;
//        insets.bottom = -insets.top;
//        item.imageInsets = insets;
//    }
//    _tabBar.items = _tabBarController.tabBar.items;
//    _tabBar.selectedItem = _tabBarController.tabBar.selectedItem;
//}

- (UITabBarController *)tabBarController {
    return _tabBarController;
}

- (void)setSeparatorColor:(UIColor *)color {
    _color = color;
    _separator.backgroundColor = color;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger index = [tabBar.items indexOfObject:item];
    if (index != NSNotFound) {
        _tabBarController.selectedIndex = index;   // 👈 Update the real controller
    }
}
@end
