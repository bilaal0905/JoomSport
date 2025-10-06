// Created for BearDev by drif
// drif@mail.ru

@import JSCore;

#import "JSFirstLaunchViewController.h"
#import "JSFirstLaunchView.h"

@implementation JSFirstLaunchViewController {
    JSSeasonsViewModel *_viewModel;
    JSKeyPathObserver *_viewModelObserver;
}

#pragma mark - UIViewController methods

- (void)loadView {
    self.view = [[JSFirstLaunchView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    JSWeakify(self);
    _viewModelObserver = [JSKeyPathObserver observerFor:_viewModel keyPath:@"isUpdating" handler:^{
        JSStrongify(self);

        if (!self->_viewModel.isUpdating) {
            JSBlock(self.onDone, nil);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_viewModel update];
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSSeasonsViewModel *)viewModel {
    JSParameterAssert(viewModel);

    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

@end
