// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore;
@import JSUIKit.UIViewController_JSUIKit;

#import "JSNewsTableViewController.h"
#import "JSNewsCell.h"
#import "UIColor+JS.h"

@implementation JSNewsTableViewController {
    JSNewsViewModel *_model;
    JSKeyPathObserver *_observer;
}

#pragma mark - Private methods

- (void)onRefreshControl {
    [_model update];
}

#pragma mark - UIViewController methods

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat bottomInset = self.tabBarController.tabBar.frame.size.height;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, bottomInset, 0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorColor = UIColor.js_Separator;
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView registerClass:JSNewsCell.class forCellReuseIdentifier:NSStringFromClass(JSNewsCell.class)];

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

    [_observer observe:@"news" handler:^{
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
    return _model.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSNewsCell.class)];
    [cell setup:_model.news[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JSNewsCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSBlock(self.onNewsTap, [_model.news[indexPath.row] newsId]);
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSNewsViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

@end
