// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit.UIViewController_JSUIKit;

#import "JSTeamPlayersViewController.h"
#import "UIColor+JS.h"
#import "JSSeasonCell.h"
#import "JSTeamPlayerCell.h"

@implementation JSTeamPlayersViewController {
    JSTeamViewModel *_teamModel;
    JSSeasonsViewModel *_seasonsModel;
    JSKeyPathObserver *_teamObserver;
}

#pragma mark - Private methods

- (void)onRefreshControl {
    [_teamModel update];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    {
        self.tableView.separatorColor = UIColor.js_Separator;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.tableFooterView = [[UIView alloc] init];

        [self.tableView registerClass:JSSeasonCell .class forCellReuseIdentifier:NSStringFromClass(JSSeasonCell.class)];
        [self.tableView registerClass:JSTeamPlayerCell.class forCellReuseIdentifier:NSStringFromClass(JSTeamPlayerCell.class)];

        self.refreshControl = ({
            UIRefreshControl *control = [[UIRefreshControl alloc] init];
            [control addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
            control;
        });
    }

    {
        JSWeakify(self);

        _teamObserver = [JSKeyPathObserver observerFor:_teamModel keyPath:@"isUpdating" handler:^{
            JSStrongify(self);

            if (self->_teamModel.isUpdating) {
                [self.refreshControl beginRefreshing];

                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableView.contentOffset = CGPointMake(0.0, -self.tableView.contentInset.top);
                });
            }
            else {
                [self.refreshControl endRefreshing];
            }
        }];

        [_teamObserver observe:@"team" handler:^{
            JSStrongify(self);
            [self.tableView reloadData];
        }];

        [_teamObserver observe:@"error" handler:^{
            JSStrongify(self);
            if (self->_teamModel.error) {
                [self js_showError:self->_teamModel.error.js_error];
            }
        }];
    }

    if (_teamModel.isUpdating) {
        [self.refreshControl beginRefreshing];
    }
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;

        case 1:
            return _teamModel.team.players.count;

        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            JSSeasonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSSeasonCell.class)];
            cell.seasonName = _seasonsModel.activeSeason.fullName;
            return cell;
        }

        case 1: {
            JSTeamPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSTeamPlayerCell.class)];
            [cell setup:_teamModel.team.players[indexPath.row]];
            return cell;
        }

        default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return JSSeasonCellHeight;

        case 1:
            return JSTeamPlayerCellHeight;

        default:
            return 0.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JSBlock(self.onSeasonTap, nil);
    }
    else {
        JSBlock(self.onPlayerTap, [_teamModel.team.players[indexPath.row] playerId]);
    }
}

#pragma mark - Interface methods

- (instancetype)initWithTeamModel:(JSTeamViewModel *)teamModel seasonsModel:(JSSeasonsViewModel *)seasonsModel {
    JSParameterAssert(teamModel);
    JSParameterAssert(seasonsModel);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Players", nil);

        _teamModel = teamModel;
        _seasonsModel = seasonsModel;
    }
    return self;
}

@end
