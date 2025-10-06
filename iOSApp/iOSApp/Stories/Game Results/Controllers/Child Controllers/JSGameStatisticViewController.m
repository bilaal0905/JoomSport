// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit.UIViewController_JSUIKit;

#import "JSGameStatisticViewController.h"
#import "JSGameStatisticCell.h"
#import "UIColor+JS.h"

@implementation JSGameStatisticViewController {
    JSGameResultsViewModel *_model;
    JSKeyPathObserver *_observer;
}

#pragma mark - Private methods

- (void)onRefreshControl {
    [_model update];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorColor = UIColor.js_Separator;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.tableView registerClass:JSGameStatisticCell.class forCellReuseIdentifier:NSStringFromClass(JSGameStatisticCell.class)];

    self.refreshControl = ({
        UIRefreshControl *control = [[UIRefreshControl alloc] init];
        [control addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
        control;
    });

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

    [_observer observe:@"statistics" handler:^{
        JSStrongify(self);
        [self.tableView reloadData];
    }];

    [_observer observe:@"error" handler:^{
        JSStrongify(self);
        if (self->_model.error) {
            [self js_showError:self->_model.error.js_error];
        }
    }];

    if (_model.isUpdating) {
        [self.refreshControl beginRefreshing];
    }
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.statistics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSGameStatisticCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSGameStatisticCell.class)];
    [cell setup:_model.statistics[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JSGameStatisticCellHeight;
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSGameResultsViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Statistic", nil);
        _model = model;
    }
    return self;
}

@end
