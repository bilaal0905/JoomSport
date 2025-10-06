// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit.UIViewController_JSUIKit;

#import "JSTeamStatisticViewController.h"
#import "UIColor+JS.h"
#import "JSSeasonCell.h"
#import "JSTeamStandingsCell.h"

@implementation JSTeamStatisticViewController {
    JSTeamViewModel *_teamModel;
    JSSeasonsViewModel *_seasonsModel;
    JSStandingsViewModel *_standingsModel;

    JSKeyPathObserver *_standingsObserver;
    JSKeyPathObserver *_teamObserver;
    JSKeyPathObserver *_seasonsObserver;

    JSStandingsRecord *_teamRecord;
}

#pragma mark - Private methods

- (void)onRefreshControl {
    [_standingsModel update];
}

- (void)updateTeamRecord {
    _teamRecord = nil;

    if (!_teamModel.team) {
        return;
    }

    for (JSStandingsGroup *group in _standingsModel.standings.groups) {
        for (JSStandingsRecord *record in group.records) {
            if ([record.teamId isEqualToString:_teamModel.team.teamId]) {
                _teamRecord = record;
                return;
            }
        }
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    {
        self.tableView.separatorColor = UIColor.js_Separator;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.tableFooterView = [[UIView alloc] init];

        [self.tableView registerClass:JSSeasonCell.class forCellReuseIdentifier:NSStringFromClass(JSSeasonCell.class)];
        [self.tableView registerClass:JSTeamStandingsCell.class forCellReuseIdentifier:NSStringFromClass(JSTeamStandingsCell.class)];

        self.refreshControl = ({
            UIRefreshControl *control = [[UIRefreshControl alloc] init];
            [control addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
            control;
        });
    }

    {
        JSWeakify(self);

        _standingsObserver = [JSKeyPathObserver observerFor:_standingsModel keyPath:@"isUpdating" handler:^{
            JSStrongify(self);

            if (self->_standingsModel.isUpdating) {
                [self.refreshControl beginRefreshing];

                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableView.contentOffset = CGPointMake(0.0, -self.tableView.contentInset.top);
                });
            }
            else {
                [self.refreshControl endRefreshing];
            }
        }];

        [_standingsObserver observe:@"standings" handler:^{
            JSStrongify(self);
            [self updateTeamRecord];
            [self.tableView reloadData];
        }];

        [_standingsObserver observe:@"error" handler:^{
            JSStrongify(self);
            if (self->_standingsModel.error) {
                [self js_showError:self->_standingsModel.error.js_error];
            }
        }];
    }

    {
        JSWeakify(self);
        _seasonsObserver = [JSKeyPathObserver observerFor:_seasonsModel keyPath:@"activeSeason" handler:^{
            JSStrongify(self);
            [self->_standingsModel update];
        }];
    }

    {
        JSWeakify(self);
        _teamObserver = [JSKeyPathObserver observerFor:_teamModel keyPath:@"team" handler:^{
            JSStrongify(self);
            [self updateTeamRecord];
            [self.tableView reloadData];
        }];
    }

    [self updateTeamRecord];

    if (_standingsModel.isUpdating) {
        [self.refreshControl beginRefreshing];
    }
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _teamRecord ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            JSSeasonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSSeasonCell.class)];
            cell.seasonName = _seasonsModel.activeSeason.fullName;
            return cell;
        }

        case 1: {
            JSTeamStandingsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSTeamStandingsCell.class)];
            [cell setup:_standingsModel.standings.fields with:_teamRecord.valuesStrings forWidth:tableView.bounds.size.width];
            return cell;
        }

        default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return JSSeasonCellHeight;

        case 1:
            return JSTeamStandingsCellHeight;

        default:
            return 0.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        JSBlock(self.onSeasonTap, nil);
    }
}

#pragma mark - Interface methods

- (instancetype)initWithTeamModel:(JSTeamViewModel *)teamModel seasonsModel:(JSSeasonsViewModel *)seasonsModel standingsModel:(JSStandingsViewModel *)standingsModel {
    JSParameterAssert(teamModel);
    JSParameterAssert(seasonsModel);
    JSParameterAssert(standingsModel);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Statistic", nil);

        _teamModel = teamModel;
        _seasonsModel = seasonsModel;
        _standingsModel = standingsModel;
    }
    return self;
}

@end
