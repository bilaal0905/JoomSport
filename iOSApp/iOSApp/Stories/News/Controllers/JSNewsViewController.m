// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSUIKit.UIImage_JSUIKit;
@import JSCore.JSNewsViewModel;

#import "JSTitledView.h"
#import "JSNewsViewController.h"
#import "JSNewsTableViewController.h"
#import "JSBackButton.h"

@implementation JSNewsViewController {
    JSNewsViewModel *_model;
    JSNewsTableViewController *_tableViewController;
    BOOL _updated;
}

#pragma mark - UIViewController methods

- (void)loadView {
    [super loadView];

    {
        [self addChildViewController:_tableViewController];

        _tableViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.titledView.contentContainer addSubview:_tableViewController.view];

        [self.titledView.contentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _tableViewController.view}]];
        [self.titledView.contentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _tableViewController.view}]];

        [_tableViewController didMoveToParentViewController:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titledView.backButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!_updated) {
        [_model update];
        _updated = YES;
    }
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSNewsViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        self.title = @"News";

        _model = model;
        _tableViewController = [[JSNewsTableViewController alloc] initWithModel:_model];

        JSWeakify(self);
        _tableViewController.onNewsTap = ^(NSString *newsId) {
            JSStrongify(self);
            
//            UIViewController *emptyVC = [[UIViewController alloc] init];
//            emptyVC.view.backgroundColor = [UIColor whiteColor]; // optional, just to see something
//
//            emptyVC.modalPresentationStyle = UIModalPresentationFullScreen;
//            emptyVC.view.backgroundColor = [UIColor greenColor]; // so it's visible
//            [self presentViewController:emptyVC animated:YES completion:nil];
            JSBlock(self.onNewsTap, newsId);
        };

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar_news"].js_original selectedImage:[UIImage imageNamed:@"tabbar_news_selected"].js_original];
    }
    return self;
}

@end
