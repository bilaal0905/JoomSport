// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSPxView;

@interface JSDetailedTableView : UIView

- (instancetype)initWithMainController:(UITableViewController *)mainController detailController:(UITableViewController *)detailController;

- (JSPxView *)separatorView;
- (UIScrollView *)detailScrollView;

- (void)setHeaderView:(UIView *)headerView;
- (void)setMainTableViewWidth:(CGFloat)width;

@end
