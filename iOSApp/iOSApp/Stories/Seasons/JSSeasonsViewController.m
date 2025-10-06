// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore;
@import JSUIKit;

#import "JSSeasonsViewController.h"

@implementation JSSeasonsViewController {
    JSSeasonsViewModel *_viewModel;
    JSKeyPathObserver *_viewModelObserver;
}

#pragma mark - Private methods

- (void)onRefreshControl {
    [_viewModel update];
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
    _viewModelObserver = [JSKeyPathObserver observerFor:_viewModel keyPath:@"isUpdating" handler:^{
        JSStrongify(self);

        if (self->_viewModel.isUpdating) {
            [self.refreshControl beginRefreshing];

            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.contentOffset = CGPointMake(0.0, -self.tableView.contentInset.top);
            });
        }
        else {
            [self.refreshControl endRefreshing];
        }
    }];

    [_viewModelObserver observe:@"tournaments" handler:^{
        JSStrongify(self);
        [self.tableView reloadData];
    }];

    [_viewModelObserver observe:@"error" handler:^{
        JSStrongify(self);
        if (self->_viewModel.error) {
            [self js_showError:self->_viewModel.error.js_error];
        }
    }];

    if (_viewModel.isUpdating) {
        [self.refreshControl beginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_viewModel update];
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel.tournaments.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_viewModel.tournaments[section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_viewModel.tournaments[section] seasons].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = [[_viewModel.tournaments[indexPath.section] seasons][indexPath.row] name];
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _viewModel.activeSeason = [_viewModel.tournaments[indexPath.section] seasons][indexPath.row];
    JSBlock(self.onDone, nil);
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSSeasonsViewModel *)viewModel {
    JSParameterAssert(viewModel);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Choose a season", nil);

        _viewModel = viewModel;

        if (_viewModel.activeSeason) {
            self.navigationItem.leftBarButtonItem = ({
                JSBarButtonItem *button = [[JSBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel];

                JSWeakify(self);
                button.onTap = ^{
                    JSStrongify(self);
                    JSBlock(self.onDone, nil);
                };

                button;
            });
        }
    }
    return self;
}

@end
