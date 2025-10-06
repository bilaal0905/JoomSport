// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit;

#import "JSTeamsTableViewController.h"

@implementation JSTeamsTableViewController {
    JSStandingsViewModel *_standingsModel;
    JSTeamViewModel *_teamModel;

    JSKeyPathObserver *_standingsObserver;
    JSKeyPathObserver *_teamObserver;
}

#pragma mark - Private methods

- (void)onRefreshControl {
    [_standingsModel update];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];

    self.refreshControl = ({
        UIRefreshControl *control = [[UIRefreshControl alloc] init];
        [control addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
        control;
    });

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
            [self->_teamModel invalidate];
        }
    }];

    [_standingsObserver observe:@"error" handler:^{
        JSStrongify(self);
        if (self->_standingsModel.error) {
            [self js_showError:self->_standingsModel.error.js_error];
        }
    }];

    if (_standingsModel.isUpdating) {
        [self.refreshControl beginRefreshing];
    }

    _teamObserver = [JSKeyPathObserver observerFor:_teamModel keyPath:@"teams" handler:^{
        JSStrongify(self);
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_standingsModel update];
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _teamModel.teams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = [_teamModel.teams[indexPath.row] name];
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _teamModel.teamId = [_teamModel.teams[indexPath.row] teamId];
    JSBlock(self.onDone, nil);
}

#pragma mark - Interface methods

- (instancetype)initWithTeamModel:(JSTeamViewModel *)teamModel standingsModel:(JSStandingsViewModel *)standingsModel {
    JSParameterAssert(teamModel);
    JSParameterAssert(standingsModel);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Choose a team", nil);

        _teamModel = teamModel;
        _standingsModel = standingsModel;

        self.navigationItem.leftBarButtonItem = ({
            JSBarButtonItem *button = [[JSBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel];

            JSWeakify(self);
            button.onTap = ^{
                JSStrongify(self);
                JSBlock(self.onCancel, nil);
            };

            button;
        });
    }
    return self;
}

@end
