// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit.UIViewController_JSUIKit;

#import "JSPlayerStatisticViewController.h"
#import "UIColor+JS.h"
#import "JSPlayerStatisticCell.h"
#import "JSSeasonCell.h"

@implementation JSPlayerStatisticViewController {
    JSPlayerViewModel *_playerModel;
    JSSeasonsViewModel *_seasonsModel;
    JSKeyPathObserver *_playerObserver;
}

#pragma mark - Private methods

- (void)onRefreshControl {
    [_playerModel update];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    {
        self.tableView.separatorColor = UIColor.js_Separator;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.tableFooterView = [[UIView alloc] init];

        [self.tableView registerClass:JSSeasonCell.class forCellReuseIdentifier:NSStringFromClass(JSSeasonCell.class)];
        [self.tableView registerClass:JSPlayerStatisticCell.class forCellReuseIdentifier:NSStringFromClass(JSPlayerStatisticCell.class)];

        self.refreshControl = ({
            UIRefreshControl *control = [[UIRefreshControl alloc] init];
            [control addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
            control;
        });
    }

    {
        JSWeakify(self);

        _playerObserver = [JSKeyPathObserver observerFor:_playerModel keyPath:@"isUpdating" handler:^{
            JSStrongify(self);

            if (self->_playerModel.isUpdating) {
                [self.refreshControl beginRefreshing];

                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableView.contentOffset = CGPointMake(0.0, -self.tableView.contentInset.top);
                });
            }
            else {
                [self.refreshControl endRefreshing];
            }
        }];

        [_playerObserver observe:@"player" handler:^{
            JSStrongify(self);
            [self.tableView reloadData];
        }];

        [_playerObserver observe:@"error" handler:^{
            JSStrongify(self);
            if (self->_playerModel.error) {
                [self js_showError:self->_playerModel.error.js_error];
            }
        }];
    }

    if (_playerModel.isUpdating) {
        [self.refreshControl beginRefreshing];
    }
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;

        case 1:
            return _playerModel.player.statistic.count;

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
            JSPlayerStatisticCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSPlayerStatisticCell.class)];
            [cell setup:_playerModel.player.statistic[indexPath.row]];
            cell.separatorInset = (indexPath.row == [tableView numberOfRowsInSection:1] - 1) ? UIEdgeInsetsZero : JSPlayerStatisticCellSeparatorInset;
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
            return JSPlayerStatisticCellHeight;

        default:
            return 0.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            JSBlock(self.onSeasonTap, nil);
            break;

        default:break;
    }
}

#pragma mark - Interface methods

- (instancetype)initWithPlayerModel:(JSPlayerViewModel *)playerModel seasonsModel:(JSSeasonsViewModel *)seasonsModel {
    JSParameterAssert(playerModel);
    JSParameterAssert(seasonsModel);


    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Statistic", nil);

        _playerModel = playerModel;
        _seasonsModel = seasonsModel;
    }
    return self;
}

@end
