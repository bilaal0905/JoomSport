// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit;
@import JSCore;
@import JSUtils;

#import "JSTeamViewController.h"
#import "JSTeamInfoViewController.h"
#import "JSTeamStatisticViewController.h"
#import "JSSubtitledLogoView.h"
#import "JSLogoView.h"

@implementation JSTeamViewController {
    JSSeasonsViewModel *_seasonsModel;
    JSTeamViewModel *_teamModel;
    JSStandingsViewModel *_standingsModel;

    JSKeyPathObserver *_seasonsObserver;
    JSKeyPathObserver *_teamObserver;

    BOOL _shouldUpdate;
    BOOL _shouldInvalidate;
}

#pragma mark - Private methods

- (void)update {
    self.logo.label.text = _teamModel.team.name;
    [self.logo.logoView setURL:_teamModel.team.logoURL placeholder:_teamModel.team.placeholder];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerBackground.backgroundColor = [UIColor js_R:240 G:70 B:80];

    JSWeakify(self);

    _seasonsObserver = [JSKeyPathObserver observerFor:_seasonsModel keyPath:@"activeSeason" handler:^{
        JSStrongify(self);
        self->_standingsModel.seasonId = self->_seasonsModel.activeSeason.seasonId;
        self->_teamModel.seasonId = self->_seasonsModel.activeSeason.seasonId;
        if (!self->_teamModel.team) {
            self->_shouldInvalidate = YES;
        }
        self->_shouldUpdate = YES;
    }];

    _teamObserver = [JSKeyPathObserver observerFor:_teamModel keyPath:@"team" handler:^{
        JSStrongify(self);
        [self update];
    }];

    [_teamObserver observe:@"teamId" handler:^{
        JSStrongify(self);
        self->_shouldUpdate = YES;
    }];

    [self update];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!_teamModel.seasonId) {
        _teamModel.seasonId = _seasonsModel.activeSeason.seasonId;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!_seasonsModel.activeSeason) {
        JSBlock(self.onSeasonTap, nil);
        return;
    }

    if (_shouldInvalidate) {
        _shouldInvalidate = NO;
        [_teamModel invalidate];
    }

    if (!_teamModel.team) {
        JSBlock(self.onTeamChoose, nil);
        return;
    }

    if (_shouldUpdate) {
        _shouldUpdate = NO;
        [_teamModel update]; //JSTeamViewController -> JSTeamViewModel -> JSViewModel
    }
}

#pragma mark - Interface methods

- (instancetype)initWithSeasonsModel:(JSSeasonsViewModel *)seasonsModel teamModel:(JSTeamViewModel *)teamModel standingsModel:(JSStandingsViewModel *)standingsModel {
    JSParameterAssert(seasonsModel);
    JSParameterAssert(teamModel);
    JSParameterAssert(standingsModel);

    self = [super init];
    if (self) {
        _seasonsModel = seasonsModel;
        _teamModel = teamModel;
        _standingsModel = standingsModel;

        _shouldUpdate = YES;

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar_team"].js_original selectedImage:[UIImage imageNamed:@"tabbar_team_selected"].js_original];
        self.segmentedController.tabBarController.viewControllers = @[
            
            ({
                JSTeamInfoViewController *viewController = [[JSTeamInfoViewController alloc] initWithTeamModel:_teamModel];
                
                JSWeakify(self);
                viewController.onTeamChoose = ^(NSString *playerId) {
                    JSStrongify(self);
                    JSBlock(self.onTeamChoose, nil);
                };
                viewController;
            }),
            ({
                JSTeamPlayersViewController *viewController = [[JSTeamPlayersViewController alloc] initWithTeamModel:_teamModel seasonsModel:_seasonsModel];
                
                JSWeakify(self);
                
                viewController.onSeasonTap = ^{
                    JSStrongify(self);
                    JSBlock(self.onSeasonTap, nil);
                };
                
                viewController.onPlayerTap = ^(NSString *playerId) {
                    JSStrongify(self);
                    JSBlock(self.onPlayerTap, playerId);
                };
                
                viewController;
            }),
            ({
                JSTeamStatisticViewController *viewController = [[JSTeamStatisticViewController alloc] initWithTeamModel:_teamModel seasonsModel:_seasonsModel standingsModel:_standingsModel];
                
                JSWeakify(self);
                viewController.onSeasonTap = ^{
                    JSStrongify(self);
                    JSBlock(self.onSeasonTap, nil);
                };
                
                viewController;
            })
        ];
    }
    return self;
}

@end
