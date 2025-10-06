// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit;
@import JSCore;
@import JSUtils;

#import "JSStandingsViewController.h"
#import "JSSeasonedView.h"
#import "JSRoundedButton.h"

@implementation JSStandingsViewController {
    JSStandingsViewModel *_standingsModel;
    JSSeasonsViewModel *_seasonsModel;

    JSKeyPathObserver *_standingsObserver;
    JSKeyPathObserver *_seasonsObserver;

    JSStandingsTableViewController *_tableViewController;
}

#pragma mark - UIViewController methods

- (void)loadView {
    [super loadView];

    {
        [self addChildViewController:_tableViewController];

        _tableViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.seasonedView.tableViewContainer addSubview:_tableViewController.view];

        [self.seasonedView.tableViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _tableViewController.view}]];
        [self.seasonedView.tableViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _tableViewController.view}]];

        [_tableViewController didMoveToParentViewController:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.seasonedView.titleLabel.text = NSLocalizedString(@"Standings", nil);

    JSWeakify(self);

    self.seasonedView.sortButton.onTap = ^{
        JSStrongify(self);
        JSBlock(self.onSortTap, nil);
    };

    _standingsObserver = [JSKeyPathObserver observerFor:_standingsModel keyPath:@"sortName" handler:^{
        JSStrongify(self);
        [self.seasonedView.sortButton setTitle:self->_standingsModel.sortName forState:UIControlStateNormal];
    }];
    [self.seasonedView.sortButton setTitle:_standingsModel.sortName forState:UIControlStateNormal];

    _seasonsObserver = [JSKeyPathObserver observerFor:_seasonsModel keyPath:@"activeSeason" handler:^{
        JSStrongify(self);
        self->_standingsModel.seasonId = self->_seasonsModel.activeSeason.seasonId;
    }];

    if (_seasonsModel.activeSeason) {
        _standingsModel.seasonId = _seasonsModel.activeSeason.seasonId;
    }
}

#pragma mark - Interface methods

- (instancetype)initWithSeasonsModel:(JSSeasonsViewModel *)seasonsModel standingsModel:(JSStandingsViewModel *)standingsModel {
    JSParameterAssert(seasonsModel);
    JSParameterAssert(standingsModel);

    self = [super initWithSeasonsModel:seasonsModel];
    if (self) {
        _seasonsModel = seasonsModel;
        _standingsModel = standingsModel;
        
        _tableViewController = [[JSStandingsTableViewController alloc] initWithStandingsModel:_standingsModel];

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar_standings"].js_original selectedImage:[UIImage imageNamed:@"tabbar_standings_selected"].js_original];
    }
    return self;
}

- (JSStandingsTableViewControllerTeamBlock)onTeamTap {
    return _tableViewController.onTeamTap;
}

- (void)setOnTeamTap:(JSStandingsTableViewControllerTeamBlock)onTeamTap {
    _tableViewController.onTeamTap = onTeamTap;
}

@end
