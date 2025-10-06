// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSScope;
@import JSUtils.JSKeyPathObserver;

#import "JSDetailedTableViewController.h"
#import "JSDetailedTableView.h"

@implementation JSDetailedTableViewController {
    JSKeyPathObserver *_mainTableViewObserver;
    JSKeyPathObserver *_detailTableViewObserver;

    UITableViewController *_mainTableViewController;
    UITableViewController *_detailTableViewController;
}

#pragma mark - UIViewController methods

- (void)loadView {
    _mainTableViewController = [[UITableViewController alloc] init];
    [self addChildViewController:_mainTableViewController];

    _detailTableViewController = [[UITableViewController alloc] init];
    [self addChildViewController:_detailTableViewController];

    self.view = [[JSDetailedTableView alloc] initWithMainController:_mainTableViewController detailController:_detailTableViewController];

    [_mainTableViewController didMoveToParentViewController:self];
    [_detailTableViewController didMoveToParentViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    JSWeakify(self);

    _mainTableViewObserver = [JSKeyPathObserver observerFor:_mainTableViewController.tableView keyPath:@"contentOffset" handler:^{
        JSStrongify(self);
        if (!CGPointEqualToPoint(self->_detailTableViewController.tableView.contentOffset, self->_mainTableViewController.tableView.contentOffset)) {
           self-> _detailTableViewController.tableView.contentOffset = self->_mainTableViewController.tableView.contentOffset;
        }
    }];

    _detailTableViewObserver = [JSKeyPathObserver observerFor:self->_detailTableViewController.tableView keyPath:@"contentOffset" handler:^{
        JSStrongify(self);
        if (!CGPointEqualToPoint(self->_detailTableViewController.tableView.contentOffset, self->_mainTableViewController.tableView.contentOffset)) {
            self->_mainTableViewController.tableView.contentOffset = self->_detailTableViewController.tableView.contentOffset;
        }
    }];
}

#pragma mark - Interface methods

- (JSDetailedTableView *)detailedTableView {
    return (JSDetailedTableView *) self.view;
}

- (UITableViewController *)mainTableViewController {
    return _mainTableViewController;
}

- (UITableViewController *)detailTableViewController {
    return _detailTableViewController;
}

@end
