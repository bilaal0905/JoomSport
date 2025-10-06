// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore.JSSettingsViewModel;

#import "JSSettingsTeamsViewController.h"
#import "JSTitledView.h"
#import "JSBackButton.h"
#import "JSSettingsTeamsTableViewController.h"

@implementation JSSettingsTeamsViewController {
    JSSettingsViewModel *_model;
    JSSettingsTeamsTableViewController *_tableViewController;
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

    JSWeakify(self);
    self.titledView.backButton.onTap = ^{
        JSStrongify(self);
        JSBlock(self.onDone, nil);
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_model update];
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSSettingsViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Teams", nil);

        _model = model;
        _tableViewController = [[JSSettingsTeamsTableViewController alloc] initWithModel:_model];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

@end
