// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;

#import "JSSegmentedController.h"
#import "JSSegmentedBar.h"
#import "JSPxView.h"

@implementation JSSegmentedController {
    UITabBarController *_tabBarController;
    JSSegmentedBar *_segmentedBar;
    JSPxView *_separator;
    
    JSKeyPathObserver *_observer;
}

#pragma mark - Private methods

- (void)updateItems {
    _segmentedBar.titles = [_tabBarController.viewControllers js_map:^NSString *(UIViewController *viewController) {
        return viewController.title ?: @"";
    }];
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.tabBar.hidden = YES;

        _segmentedBar = [[JSSegmentedBar alloc] init];
        _separator = [[JSPxView alloc] initWithType:JSPxViewTypeHorizontal];
    }
    return self;
}

#pragma mark - UIViewController methods

- (void)loadView {
    [super loadView];

    {
        _segmentedBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_segmentedBar];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_segmentedBar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_segmentedBar)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_segmentedBar]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_segmentedBar)]];
    }
    
    {
        _separator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_separator];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_separator]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_separator)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_segmentedBar][_separator]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_segmentedBar, _separator)]];
    }

    {
        [self addChildViewController:_tabBarController];

        _tabBarController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_tabBarController.view];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _tabBarController.view}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_separator][view]|" options:0 metrics:nil views:@{@"_separator": _separator, @"view": _tabBarController.view}]];

        [_tabBarController didMoveToParentViewController:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    JSWeakify(self);

    _observer = [JSKeyPathObserver observerFor:_tabBarController keyPath:@"viewController" handler:^{
        JSStrongify(self);
        [self updateItems];
    }];
    [self updateItems];

    _observer = [JSKeyPathObserver observerFor:_tabBarController keyPath:@"selectedIndex" handler:^{
        JSStrongify(self);
        self->_segmentedBar.selected = self->_tabBarController.selectedIndex;
    }];
    _segmentedBar.selected = _tabBarController.selectedIndex;

    _segmentedBar.onChange = ^{
        JSStrongify(self);
        self->_tabBarController.selectedIndex = self->_segmentedBar.selected;
    };
}

#pragma mark - Interface methods

- (UITabBarController *)tabBarController {
    return _tabBarController;
}

- (JSSegmentedBar *)segmentedBar {
    return _segmentedBar;
}

- (JSPxView *)separator {
    return _separator;
}

@end
