// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSDetailedTableView;

@interface JSDetailedTableViewController : UIViewController

- (JSDetailedTableView *)detailedTableView;

- (UITableViewController *)mainTableViewController;
- (UITableViewController *)detailTableViewController;

@end
