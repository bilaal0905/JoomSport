// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit.UIViewController_JSUIKit;

#import "JSGameInfoViewController.h"
#import "JSTextCellLayout.h"
#import "JSExtraInfoCell.h"
#import "JSTextCell.h"
#import "UIColor+JS.h"

@implementation JSGameInfoViewController {
    JSGameResultsViewModel *_model;
    JSKeyPathObserver *_observer;

    JSTextCellLayout *_cellLayout;
    NSString *_cachedText;
}

#pragma mark - Private methods

- (void)updateLayout {
    if ([_cachedText isEqualToString:_model.game.info]) {
        return;
    }

    if (!_model.game.info.length) {
        return;
    }

    _cachedText = _model.game.info.copy;

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

        [_observer observe:@"game" handler:^{
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
    return _model.game.extras.count + (_model.game.info.length > 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < (NSInteger) _model.game.extras.count) {
        JSExtraInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSExtraInfoCell.class)];
        [cell setup:_model.game.extras[indexPath.row]];
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
    if (indexPath.row < (NSInteger) _model.game.extras.count) {
        return JSExtraInfoCellHeight;
    }
    else {
        return _cellLayout.height;
    }
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSGameResultsViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Additional", nil);
        _model = model;

        [self updateLayout];
    }
    return self;
}

@end
