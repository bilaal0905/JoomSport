// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit;
@import JSUtils;
@import JSCore;

#import "JSGameResultsViewController.h"
#import "JSGameResultsView.h"
#import "JSBackgroundView.h"
#import "JSGameEventsViewController.h"
#import "JSBackButton.h"
#import "JSSubtitledLogoView.h"

@implementation JSGameResultsViewController {
    JSGameResultsViewModel *_model;
    JSKeyPathObserver *_observer;
}

#pragma mark - Private methods

- (JSGameResultsView *)gameResultsView {
    return (JSGameResultsView *) self.contentView;
}

#pragma mark - UIViewController methods

- (void)loadView {
    [super loadView];

    {
        JSGameEventsViewController *viewController = [[JSGameEventsViewController alloc] initWithModel:_model];
        [self addChildViewController:viewController];

        viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.gameResultsView.segmentedControllerContainer addSubview:viewController.view];

        [self.gameResultsView.segmentedControllerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": viewController.view}]];
        [self.gameResultsView.segmentedControllerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": viewController.view}]];

        [viewController didMoveToParentViewController:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    JSWeakify(self);

    self.gameResultsView.backButton.onTap = ^{
        JSStrongify(self);
        JSBlock(self.onBackTap, nil);
    };

    _observer = [JSKeyPathObserver observerFor:_model keyPath:@"game" handler:^{
        JSStrongify(self);
        [self.gameResultsView setup:self->_model.game];
    }];
    [self.gameResultsView setup:_model.game];

    self.gameResultsView.homeLogo.onTap = ^{
        JSStrongify(self);
        JSBlock(self.onTeamTap, self->_model.game.home.teamId);
    };

    self.gameResultsView.awayLogo.onTap = ^{
        JSStrongify(self);
        JSBlock(self.onTeamTap, self->_model.game.away.teamId);
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [_model update];
}

#pragma mark - JSViewController methods

- (void)loadBackgroundView {
    self.backgroundView = [[JSBackgroundView alloc] init];
}

- (void)loadContentView {
    self.contentView = [[JSGameResultsView alloc] init];
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSGameResultsViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        _model = model;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

@end
