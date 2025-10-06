// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSUIKit;
@import JSCore;

#import "JSStandingsTableViewController.h"
#import "UIColor+JS.h"
#import "JSStandingsTeamCell.h"
#import "JSStandingsScoreCell.h"
#import "JSStandingsCellLayout.h"
#import "JSScoresTitlesView.h"
#import "JSGroupSectionHeaderView.h"

@interface JSStandingsTableViewController () <
    UITableViewDataSource,
    UITableViewDelegate
>

@end

@implementation JSStandingsTableViewController {
    JSStandingsViewModel *_standingsModel;
    JSStandingsCellLayout *_layout;

    JSKeyPathObserver *_standingsObserver;
    JSKeyPathObserver *_scrollObserver;

    NSHashTable *_headers;
    BOOL _shouldUpdate;
}

#pragma mark - Private methods

- (void)onRefreshControl {
    [_standingsModel update];
}

- (void)reloadData {

    if (_standingsModel.standings.fields) {
        _layout = [[JSStandingsCellLayout alloc] initWithStandings:_standingsModel.standings];
        _layout.teamCellMaxWidth = CGRectGetWidth(self.view.bounds) * 0.6;

        [self.detailedTableView setHeaderView:[[JSScoresTitlesView alloc] initWithLayout:_layout titles:_standingsModel.standings.fields]];
        [self.detailedTableView setMainTableViewWidth:MAX(_layout.teamCellWidth, CGRectGetWidth(self.view.bounds) - _layout.scoreCellWidth)];
    }
    else {
        _layout = nil;

        [self.detailedTableView setHeaderView:({
            UIView *view = [[UIView alloc] init];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            view;
        })];
        [self.detailedTableView setMainTableViewWidth:CGRectGetWidth(self.view.bounds) - 1.0];
    }

    [self.mainTableViewController.tableView reloadData];
    [self.detailTableViewController.tableView reloadData];
}

- (void)setupTableViews {
    self.detailedTableView.separatorView.backgroundColor = UIColor.js_Separator;
    self.mainTableViewController.tableView.separatorColor =  UIColor.js_Separator;
    self.detailTableViewController.tableView.separatorColor = UIColor.js_Separator;

    [self.mainTableViewController.tableView registerClass:JSStandingsTeamCell.class forCellReuseIdentifier:NSStringFromClass(JSStandingsTeamCell.class)];
    [self.detailTableViewController.tableView registerClass:JSStandingsScoreCell.class forCellReuseIdentifier:NSStringFromClass(JSStandingsScoreCell.class)];

    self.mainTableViewController.tableView.dataSource = self;
    self.detailTableViewController.tableView.dataSource = self;

    self.mainTableViewController.tableView.delegate = self;
    self.detailTableViewController.tableView.delegate = self;

    self.mainTableViewController.refreshControl = ({
        UIRefreshControl *control = [[UIRefreshControl alloc] init];
        [control addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
        control;
    });

    self.detailTableViewController.refreshControl = ({
        UIRefreshControl *control = [[UIRefreshControl alloc] init];
        control.alpha = 0.0;
        [control addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
        control;
    });
}

- (void)setupScrollObserver {
    JSWeakify(self);

    _scrollObserver = [JSKeyPathObserver observerFor:self.detailedTableView.detailScrollView keyPath:@"contentOffset" handler:^{
        JSStrongify(self);

        for (JSGroupSectionHeaderView *view in self->_headers) {
            view.contentOffset = self.detailedTableView.detailScrollView.contentOffset.x - self->_layout.teamCellWidth;
        }
    }];
}

- (void)setupStandingsModelObserver {
    JSWeakify(self);

    _standingsObserver = [JSKeyPathObserver observerFor:_standingsModel keyPath:@"isUpdating" handler:^{
        JSStrongify(self);

        if (self->_standingsModel.isUpdating) {
            [self.mainTableViewController.refreshControl beginRefreshing];
            [self.detailTableViewController.refreshControl beginRefreshing];

            dispatch_async(dispatch_get_main_queue(), ^{
                self.mainTableViewController.tableView.contentOffset = CGPointMake(0.0, -self.mainTableViewController.tableView.contentInset.top);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableViewController.refreshControl endRefreshing];
                [self.detailTableViewController.refreshControl endRefreshing];
            });
        }
    }];

    [_standingsObserver observe:@"standings" handler:^{
        JSStrongify(self);
        [self reloadData];
    }];

    [_standingsObserver observe:@"seasonId" handler:^{
        JSStrongify(self);
        self.detailedTableView.detailScrollView.contentOffset = CGPointZero;
        self->_shouldUpdate = YES;
    }];

    [_standingsObserver observe:@"error" handler:^{
        JSStrongify(self);
        if (self->_standingsModel.error) {
            [self js_showError:self->_standingsModel.error.js_error];
        }
    }];

    if (_standingsModel.isUpdating) {
        [self.mainTableViewController.refreshControl beginRefreshing];
        [self.detailTableViewController.refreshControl beginRefreshing];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableViews];
    [self setupScrollObserver];
    [self setupStandingsModelObserver];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (_shouldUpdate) {
        _shouldUpdate = NO;
        [_standingsModel update];
    }
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _standingsModel.standings.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_standingsModel.standings.groups[section] records].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class cellClass = (tableView == self.mainTableViewController.tableView) ? JSStandingsTeamCell.class : JSStandingsScoreCell.class;

    UITableViewCell <JSStandingsCell> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    [cell setup:_layout record:[_standingsModel.standings.groups[indexPath.section] records][indexPath.row] sortIndex:_standingsModel.sortIndex];

    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JSGroupSectionHeaderView *view = [[JSGroupSectionHeaderView alloc] init];
    view.label.text = [_standingsModel.standings.groups[section] name];

    if (tableView == self.detailTableViewController.tableView) {
        view.contentOffset = self.detailedTableView.detailScrollView.contentOffset.x - _layout.teamCellWidth;
        [_headers addObject:view];
    }

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [_standingsModel.standings.groups[section] name] ? JSGroupSectionHeaderViewHeight : 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JSStandingsCellLayoutHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableViewController.tableView) {
        JSBlock(self.onTeamTap, [[_standingsModel.standings.groups[indexPath.section] records][indexPath.row] teamId]);
    }
}

#pragma mark - Interface methods

- (instancetype)initWithStandingsModel:(JSStandingsViewModel *)standingsModel {
    JSParameterAssert(standingsModel);

    self = [super init];
    if (self) {
        _standingsModel = standingsModel;
        _headers = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
    }
    return self;
}

@end
