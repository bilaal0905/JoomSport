// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit;

#import "JSCalendarTableViewController.h"
#import "JSCalendarCell.h"
#import "UIColor+JS.h"

@implementation JSCalendarTableViewController {
    JSCalendarViewModel *_calendarModel;
    JSKeyPathObserver *_calendarObserver;
    BOOL _shouldUpdate;
    BOOL _shouldScroll;
    BOOL _layouted;
}

#pragma mark - Private methods

- (void)onRefreshControl {
    [_calendarModel update];
}

- (void)updateIfNeeded {
    if (!_shouldUpdate) {
        return;
    }

    _shouldUpdate = NO;
    [_calendarModel update];
}

- (void)scroll:(BOOL)force animated:(BOOL)animated {
    if (!_shouldScroll && !force) {
        return;
    }
    _shouldScroll = NO;

    if (!_calendarModel.games.count) {
        return;
    }

    NSInteger visibleGame = _calendarModel.visibleGame;
    CGFloat tableHeight = CGRectGetHeight(self.tableView.frame);
    CGFloat gamesHeight = (_calendarModel.games.count - visibleGame) * JSCalendarCellHeight;

    while (visibleGame > 0 && tableHeight > gamesHeight) {
        visibleGame--;
        gamesHeight += JSCalendarCellHeight;
    }

    if (visibleGame < [self.tableView numberOfRowsInSection:0]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:visibleGame inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
    else {
        [self.tableView setContentOffset:CGPointMake(0.0, visibleGame * JSCalendarCellHeight) animated:animated];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.refreshControl = ({
        UIRefreshControl *control = [[UIRefreshControl alloc] init];
        [control addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
        control;
    });

    {
        self.tableView.backgroundColor = UIColor.clearColor;
        self.tableView.separatorColor = UIColor.js_Separator;
        self.tableView.showsVerticalScrollIndicator = NO;

        [self.tableView registerClass:JSCalendarCell.class forCellReuseIdentifier:NSStringFromClass(JSCalendarCell.class)];
    }

    {
        JSWeakify(self);
        _calendarObserver = [JSKeyPathObserver observerFor:_calendarModel keyPath:@"isUpdating" handler:^{
            JSStrongify(self);

            if (self->_calendarModel.isUpdating) {
                [self.refreshControl beginRefreshing];

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self->_calendarModel.games.count) {
                        self.tableView.contentOffset = CGPointMake(0.0, -self.tableView.contentInset.top);
                    }
                });
            }
            else {
                [self.refreshControl endRefreshing];
            }
        }];

        [_calendarObserver observe:@"participant" handler:^{
            JSStrongify(self);
            self.tableView.contentOffset = CGPointMake(0.0, -self.tableView.contentInset.top);
            self->_shouldScroll = YES;
        }];

        [_calendarObserver observe:@"games" handler:^{
            JSStrongify(self);

            BOOL noGames = ([self.tableView numberOfRowsInSection:0] == 0);
            [self.tableView reloadData];

            if (noGames) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self scroll:YES animated:YES];
                });
            }
        }];

        [_calendarObserver observe:@"seasonId" handler:^{
            JSStrongify(self);
            self->_shouldUpdate = YES;
            self->_shouldScroll = YES;
        }];

        [_calendarObserver observe:@"error" handler:^{
            JSStrongify(self);
            if (self->_calendarModel.error) {
                [self js_showError:self->_calendarModel.error.js_error];
            }
        }];

        if (_calendarModel.isUpdating) {
            [self.refreshControl beginRefreshing];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scroll:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateIfNeeded];

    if (!_layouted) {
        _layouted = YES;
        [self scroll:YES animated:NO];
    }
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _calendarModel.games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSCalendarCell.class)];
    [cell setup:_calendarModel.games[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JSCalendarCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSBlock(self.onGameTap, [_calendarModel.games[indexPath.row] gameId]);
}

#pragma mark - Interface methods

- (instancetype)initWithCalendarModel:(JSCalendarViewModel *)calendarModel {
    JSParameterAssert(calendarModel);

    self = [super init];
    if (self) {
        _calendarModel = calendarModel;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

@end
