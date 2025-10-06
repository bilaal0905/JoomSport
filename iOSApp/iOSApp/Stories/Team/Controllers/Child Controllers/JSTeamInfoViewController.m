// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore;
@import JSUIKit.UIViewController_JSUIKit;

#import "JSTeamInfoViewController.h"
#import "JSExtraInfoCell.h"
#import "UIColor+JS.h"
#import "JSTextCell.h"
#import "JSTextCellLayout.h"

@implementation JSTeamInfoViewController {
    JSTeamViewModel *_model;
    JSKeyPathObserver *_observer;

    JSTextCellLayout *_cellLayout;
    NSString *_cachedText;
}

#pragma mark - Private methods

- (void)updateLayout {
    if ([_cachedText isEqualToString:_model.team.info]) {
        return;
    }

    if (!_model.team.info.length) {
        return;
    }

    _cachedText = _model.team.info.copy;

    _cellLayout = [[JSTextCellLayout alloc] initWithText:[_cachedText js_html:@"SFUIText" weights:@{
            @"TimesNewRomanPSMT": @"Regular",
            @"BoldMT": @"Bold"
    } size:13.0]];
}

- (void)onRefreshControl {
    [_model update];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    {
        self.tableView.separatorColor = UIColor.js_Separator;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.tableFooterView = [[UIView alloc] init];

        [self.tableView registerClass:JSExtraInfoCell.class forCellReuseIdentifier:NSStringFromClass(JSExtraInfoCell.class)];
        [self.tableView registerClass:JSTextCell.class forCellReuseIdentifier:NSStringFromClass(JSTextCell.class)];

        self.refreshControl = ({
            UIRefreshControl *control = [[UIRefreshControl alloc] init];
            [control addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
            control;
        });
    }

    {
        JSWeakify(self);

        _observer = [JSKeyPathObserver observerFor:_model keyPath:@"isUpdating" handler:^{
            JSStrongify(self);

            if (self->_model.isUpdating) {
                [self.refreshControl beginRefreshing];

                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableView.contentOffset = CGPointMake(0.0, -self.tableView.contentInset.top);
                });
            }
            else {
                [self.refreshControl endRefreshing];
            }
        }];

        [_observer observe:@"team.extras" handler:^{
            JSStrongify(self);
            [self updateLayout];
            [self.tableView reloadData];
        }];

        [_observer observe:@"info" handler:^{
            JSStrongify(self);
            [self updateLayout];
            [self.tableView reloadData];
        }];

        [_observer observe:@"error" handler:^{
            JSStrongify(self);
            if (self->_model.error) {
                [self js_showError:self->_model.error.js_error];
            }
        }];
    }

    if (_model.isUpdating) {
        [self.refreshControl beginRefreshing];
    }
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _cellLayout.width = CGRectGetWidth(tableView.frame);
    return _model.team.extras.count + (_model.team.info.length > 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < (NSInteger) _model.team.extras.count) {
        JSExtraInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSExtraInfoCell.class)];
        [cell setup:_model.team.extras[indexPath.row]];
        return cell;
    }
    else {
        JSTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSTextCell.class)];
        [cell setup:_cellLayout];
        return cell;
    }
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < (NSInteger) _model.team.extras.count) {
        return JSExtraInfoCellHeight;
    }
    else {
        return _cellLayout.height;
    }
}

#pragma mark - Interface methods

- (instancetype)initWithTeamModel:(JSTeamViewModel *)teamModel {
    JSParameterAssert(teamModel);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Team", nil);

        _model = teamModel;

        [self updateLayout];
    }
    return self;
}

@end
