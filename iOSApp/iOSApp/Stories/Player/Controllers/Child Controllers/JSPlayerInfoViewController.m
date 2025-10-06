// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit.UIViewController_JSUIKit;

#import "JSPlayerInfoViewController.h"
#import "JSExtraInfoCell.h"
#import "JSTextCell.h"
#import "UIColor+JS.h"
#import "JSTextCellLayout.h"

@implementation JSPlayerInfoViewController {
    JSPlayerViewModel *_model;
    JSKeyPathObserver *_observer;

    JSTextCellLayout *_cellLayout;
    NSString *_cachedText;
}

#pragma mark - Private methods

- (void)updateLayout {
    if ([_cachedText isEqualToString:_model.player.info]) {
        return;
    }

    if (!_model.player.info.length) {
        return;
    }

    _cachedText = _model.player.info.copy;
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

        [_observer observe:@"player" handler:^{
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

    [self updateLayout];
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    _cellLayout.width = CGRectGetWidth(tableView.frame);
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _model.player.extras.count;

        case 1:
            return _cellLayout ? 1 : 0;

        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            JSExtraInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSExtraInfoCell.class)];
            [cell setup:_model.player.extras[indexPath.row]];
            cell.separatorInset = (indexPath.row == [tableView numberOfRowsInSection:0] - 1) ? UIEdgeInsetsZero : JSExtraInfoCellSeparatorInset;
            return cell;
        }

        case 1: {
            JSTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSTextCell.class)];
            [cell setup:_cellLayout];
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
            return JSExtraInfoCellHeight;

        case 1:
            return _cellLayout.height;

        default:
            return 0.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [UIApplication.sharedApplication openURL:(NSURL * _Nonnull) [_model.player.extras[indexPath.row] url]];
            break;

        default:
            break;
    }
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSPlayerViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Additional", nil);
        _model = model;
    }
    return self;
}

@end
