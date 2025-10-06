// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSUIKit;
@import JSCore;

#import "JSRouter.h"
#import "JSModelsStore.h"
#import "JSStandingsViewController.h"
#import "JSSeasonsViewController.h"
#import "JSStandingsSortViewController.h"
#import "JSCalendarViewController.h"
#import "JSCalendarParticipantsViewController.h"
#import "JSTeamViewController.h"
#import "JSSettingsViewController.h"
#import "UIColor+JS.h"
#import "JSGameResultsViewController.h"
#import "JSTeamsTableViewController.h"
#import "JSPlayerViewController.h"
#import "JSSettingsTeamsViewController.h"
#import "JSFirstLaunchViewController.h"
#import "JSNewsViewController.h"
#import "JSNewsDetailsViewController.h"

@implementation JSRouter {
    JSModelsStore *_modelsStore;
    JSTabBarController *_tabBarController;
    JSNavigationController *_competitorController;
    JSTeamViewController *_teamViewController;
}

#pragma mark - Private methods

- (JSStandingsViewController *)standingsViewController {
    JSStandingsViewController *standingsViewController = [[JSStandingsViewController alloc] initWithSeasonsModel:_modelsStore.seasonsViewModel standingsModel:_modelsStore.standingsViewModel];

    JSWeakify(standingsViewController);
    JSWeakify(self);

    standingsViewController.onSeasonTap = ^{
        JSStrongify(standingsViewController);
        JSStrongify(self);

        [standingsViewController presentViewController:self.seasonsViewController animated:YES completion:nil];
    };

    standingsViewController.onSortTap = ^{
        JSStrongify(standingsViewController);
        JSStrongify(self);

        [standingsViewController presentViewController:self.standingsSortViewController animated:YES completion:nil];
    };

    standingsViewController.onTeamTap = ^(NSString *teamId) {
        JSStrongify(self);

        if (self->_modelsStore.seasonsViewModel.activeSeason.isSinglePlayer) {
            self->_modelsStore.playerViewModel.playerId = teamId;
            self->_competitorController.viewControllers = @[self.playerViewController];
        }
        else {
            self->_competitorController.viewControllers = @[self->_teamViewController];
            self->_modelsStore.teamViewModel.teamId = teamId;
        }

        [self->_tabBarController setupItems];
        self->_tabBarController.tabBarController.selectedIndex = 2;
    };

    return standingsViewController;
}

- (JSNavigationController *)seasonsViewController {
    JSSeasonsViewController *seasonsViewController = [[JSSeasonsViewController alloc] initWithModel:_modelsStore.seasonsViewModel];

    JSWeakify(seasonsViewController);
    seasonsViewController.onDone = ^{
        JSStrongify(seasonsViewController);
        [seasonsViewController.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    };

    return [[JSNavigationController alloc] initWithRootViewController:seasonsViewController];
}

- (JSNavigationController *)standingsSortViewController {
    JSStandingsSortViewController *standingsSortViewController = [[JSStandingsSortViewController alloc] initWithModel:_modelsStore.standingsViewModel];

    JSWeakify(standingsSortViewController);
    standingsSortViewController.onDone = ^{
        JSStrongify(standingsSortViewController);
        [standingsSortViewController.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    };

    return [[JSNavigationController alloc] initWithRootViewController:standingsSortViewController];
}

- (JSNavigationController *)calendarViewController {
    JSCalendarViewController *calendarViewController = [[JSCalendarViewController alloc] initWithSeasonsModel:_modelsStore.seasonsViewModel standingsModel:_modelsStore.calendarViewModel];

    JSWeakify(calendarViewController);
    JSWeakify(self);

    calendarViewController.onSeasonTap = ^{
        JSStrongify(calendarViewController);
        JSStrongify(self);

        [calendarViewController presentViewController:self.seasonsViewController animated:YES completion:nil];
    };

    calendarViewController.onParticipantTap = ^{
        JSStrongify(calendarViewController);
        JSStrongify(self);

        [calendarViewController presentViewController:self.calendarParticipantsViewController animated:YES completion:nil];
    };

    calendarViewController.onGameTap = ^(NSString *gameId) {
        JSStrongify(calendarViewController);
        JSStrongify(self);
        [calendarViewController presentViewController:[self gameResultsViewController:gameId of:nil] animated:YES completion:nil];
        //[calendarViewController.navigationController pushViewController:[self gameResultsViewController:gameId of:nil] animated:YES];
    };

    JSNavigationController *navigationController = [[JSNavigationController alloc] initWithRootViewController:calendarViewController];
    navigationController.navigationBarHidden = YES;

    return navigationController;
}

- (JSNavigationController *)calendarParticipantsViewController {
    JSCalendarParticipantsViewController *calendarParticipantsViewController = [[JSCalendarParticipantsViewController alloc] initWithModel:_modelsStore.calendarViewModel];

    JSWeakify(calendarParticipantsViewController);
    calendarParticipantsViewController.onDone = ^{
        JSStrongify(calendarParticipantsViewController);
        [calendarParticipantsViewController.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    };

    return [[JSNavigationController alloc] initWithRootViewController:calendarParticipantsViewController];
}

- (JSGameResultsViewController *)gameResultsViewController:(NSString *)gameId of:(NSString *)seasonId {
    JSGameResultsViewController *gameResultsViewController = [[JSGameResultsViewController alloc] initWithModel:[_modelsStore gameResultsViewModel:gameId of:seasonId]];

    JSWeakify(gameResultsViewController);
    gameResultsViewController.onBackTap = ^{
        JSStrongify(gameResultsViewController);
        [gameResultsViewController dismissViewControllerAnimated:YES completion:nil];
        [gameResultsViewController.navigationController popViewControllerAnimated:YES];
    };

    JSWeakify(self);
    gameResultsViewController.onTeamTap = ^(NSString *teamId) {
        JSStrongify(self);

        if (self->_modelsStore.seasonsViewModel.activeSeason.isSinglePlayer) {
            self->_modelsStore.playerViewModel.playerId = teamId;
            self->_competitorController.viewControllers = @[self.playerViewController];
        }
        else {
            self->_competitorController.viewControllers = @[self->_teamViewController];
            self->_modelsStore.teamViewModel.teamId = teamId;
        }

        [self->_tabBarController setupItems];
        self->_tabBarController.tabBarController.selectedIndex = 2;
    };

    return gameResultsViewController;
}

- (JSTeamViewController *)teamViewController {
    JSTeamViewController *teamViewController = [[JSTeamViewController alloc] initWithSeasonsModel:_modelsStore.seasonsViewModel teamModel:_modelsStore.teamViewModel standingsModel:_modelsStore.standingsViewModel];

    JSWeakify(teamViewController);
    JSWeakify(self);

    teamViewController.onSeasonTap = ^{
        JSStrongify(teamViewController);
        JSStrongify(self);

        [teamViewController presentViewController:self.seasonsViewController animated:YES completion:nil];
    };

    teamViewController.onTeamChoose = ^{
        JSStrongify(teamViewController);
        JSStrongify(self);

        [teamViewController presentViewController:self.teamsTableViewController animated:YES completion:nil];
    };

    teamViewController.onPlayerTap = ^(NSString *playerId) {
        JSStrongify(teamViewController);
        JSStrongify(self);

        self->_modelsStore.playerViewModel.playerId = playerId;
        [teamViewController.navigationController pushViewController:self.playerViewController animated:YES];
    };

    return teamViewController;
}

- (JSNavigationController *)teamsTableViewController {
    JSTeamsTableViewController *teamsTableViewController = [[JSTeamsTableViewController alloc] initWithTeamModel:_modelsStore.teamViewModel standingsModel:_modelsStore.standingsViewModel];

    JSWeakify(teamsTableViewController);
    teamsTableViewController.onDone = ^{
        JSStrongify(teamsTableViewController);

        if (self->_modelsStore.seasonsViewModel.activeSeason.isSinglePlayer) {
            self->_modelsStore.playerViewModel.playerId = self->_modelsStore.teamViewModel.team.teamId;
            self->_competitorController.viewControllers = @[self.playerViewController];
            [self->_tabBarController setupItems];
        }

        [teamsTableViewController.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    };

    //JSWeakify(self);
    teamsTableViewController.onCancel = ^{
        JSStrongify(teamsTableViewController);
        NSString *teamId = self->_modelsStore.teamViewModel.team.teamId;
        if (teamId == nil || teamId.length == 0) {
            teamId = @"1";
        }

        if (self->_modelsStore.seasonsViewModel.activeSeason.isSinglePlayer) {
            self->_modelsStore.playerViewModel.playerId = teamId;
            self->_competitorController.viewControllers = @[self.playerViewController];
            [self->_tabBarController setupItems];
        }

        [teamsTableViewController.navigationController.presentingViewController
            dismissViewControllerAnimated:YES
                               completion:nil];
    };

    return [[JSNavigationController alloc] initWithRootViewController:teamsTableViewController];
}

- (JSPlayerViewController *)playerViewController {
    JSPlayerViewController *playerViewController = [[JSPlayerViewController alloc] initWithSeasonsModel:_modelsStore.seasonsViewModel playerModel:_modelsStore.playerViewModel];

    JSWeakify(playerViewController);
    JSWeakify(self);

    playerViewController.onDone = ^{
        JSStrongify(playerViewController);
        [playerViewController dismissViewControllerAnimated:YES completion:nil];
        [playerViewController.navigationController popViewControllerAnimated:YES];
    };

    playerViewController.onSeasonTap = ^{
        JSStrongify(playerViewController);
        JSStrongify(self);

        [playerViewController presentViewController:self.seasonsViewController animated:YES completion:nil];
    };

    playerViewController.onNoData = ^{
        JSStrongify(playerViewController);
        if (playerViewController.navigationController.viewControllers.count == 1) {
            playerViewController.navigationController.viewControllers = @[
                    self->_teamViewController,
                    playerViewController
            ];
        }
        [playerViewController dismissViewControllerAnimated:YES completion:nil];
        [playerViewController.navigationController popViewControllerAnimated:YES];
    };

    return playerViewController;
}

- (JSNavigationController *)settingsViewController {
    JSSettingsViewController *settingsViewController = [[JSSettingsViewController alloc] initWithModel:_modelsStore.settingsViewModel];

    JSWeakify(self);
    JSWeakify(settingsViewController);

    settingsViewController.onTeamsTap = ^{
        JSStrongify(self);
        JSStrongify(settingsViewController);

        [settingsViewController presentViewController:self.settingsTeamsViewController animated:YES completion:nil];
        //[settingsViewController.navigationController pushViewController:self.settingsTeamsViewController animated:YES];
    };

    JSNavigationController *navigationController = [[JSNavigationController alloc] initWithRootViewController:settingsViewController];
    navigationController.navigationBarHidden = YES;

    return navigationController;
}

- (JSSettingsTeamsViewController *)settingsTeamsViewController {
    JSSettingsTeamsViewController *settingsTeamsViewController = [[JSSettingsTeamsViewController alloc] initWithModel:_modelsStore.settingsViewModel];

    JSWeakify(settingsTeamsViewController);
    settingsTeamsViewController.onDone = ^{
        JSStrongify(settingsTeamsViewController);
        [settingsTeamsViewController dismissViewControllerAnimated:YES completion:nil];
        [settingsTeamsViewController.navigationController popViewControllerAnimated:YES];
    };

    return settingsTeamsViewController;
}

- (JSNavigationController *)newsViewController {
    JSNewsViewController *newsViewController = [[JSNewsViewController alloc] initWithModel:_modelsStore.newsViewModel];

    JSWeakify(self);
    JSWeakify(newsViewController);
    newsViewController.onNewsTap = ^(NSString *newsId) {
        JSStrongify(self);
        JSStrongify(newsViewController);
        
        self->_modelsStore.newsDetailsViewModel.newsId = newsId;
        [newsViewController presentViewController:self.newsDetailsViewController animated:YES completion:nil];
        //[newsViewController.navigationController pushViewController:self.newsDetailsViewController animated:YES];
    };

    JSNavigationController *navigationController = [[JSNavigationController alloc] initWithRootViewController:newsViewController];
    navigationController.navigationBarHidden = YES;

    return navigationController;
}

- (JSNewsDetailsViewController *)newsDetailsViewController {
    JSNewsDetailsViewController *controller = [[JSNewsDetailsViewController alloc] initWithModel:_modelsStore.newsDetailsViewModel];

    JSWeakify(controller);
    controller.onBackTap = ^{
        JSStrongify(controller);
        [controller dismissViewControllerAnimated:YES completion:nil];
        [controller.navigationController popViewControllerAnimated:YES];
    };

    return controller;
}

- (JSTabBarController *)tabBarController {
    JSTabBarController *tabBarController = [[JSTabBarController alloc] init];

    tabBarController.tabBarController.tabBar.barTintColor = [UIColor js_R:250 G:250 B:250];
    tabBarController.separatorColor = UIColor.js_Separator;
    _teamViewController = self.teamViewController;
    _competitorController = ({
        JSNavigationController *navigationController = [[JSNavigationController alloc] initWithRootViewController:_teamViewController];
        navigationController.navigationBarHidden = YES;
        navigationController;
    });

    tabBarController.tabBarController.viewControllers = @[
            self.newsViewController,
            self.standingsViewController,
            self.calendarViewController,
            _competitorController,
            self.settingsViewController
    ];

    return tabBarController;
}

- (JSFirstLaunchViewController *)firstLaunchViewController {
    JSFirstLaunchViewController *firstLaunchViewController = [[JSFirstLaunchViewController alloc] initWithModel:_modelsStore.seasonsViewModel];

    JSWeakify(firstLaunchViewController);
    JSWeakify(self);

    firstLaunchViewController.onDone = ^{
        JSStrongify(firstLaunchViewController);
        JSStrongify(self);

        if (self->_modelsStore.seasonsViewModel.activeSeason.isSinglePlayer) {
            self->_competitorController.viewControllers = @[self.playerViewController];
            [self->_tabBarController setupItems];
        }

        UIWindow *window = firstLaunchViewController.view.window;
        window.rootViewController = self->_tabBarController;

        [UIView transitionWithView:window duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    };

    return firstLaunchViewController;
}

#pragma mark - Interface methods

- (instancetype)initWithModelsStore:(JSModelsStore *)modelsStore {
    JSParameterAssert(modelsStore);
    
    self = [super init];
    if (self) {
        _modelsStore = modelsStore;
        _tabBarController = self.tabBarController;
    }
    return self;
}

- (UIViewController *)rootViewController {
    BOOL isFirstLaunch = (_modelsStore.seasonsViewModel.activeSeason == nil);
    return isFirstLaunch ? self.firstLaunchViewController : _tabBarController;
}

- (void)open:(NSString *)gameId of:(NSString *)seasonId {
    UINavigationController *navigationController = [_tabBarController.tabBarController.viewControllers objectAtIndex:1];
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController pushViewController:[self gameResultsViewController:gameId of:seasonId] animated:NO];
    _tabBarController.tabBarController.selectedIndex = 1;
}

@end


