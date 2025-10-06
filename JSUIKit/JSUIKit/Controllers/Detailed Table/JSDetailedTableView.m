// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSDetailedTableView.h"
#import "JSPxView.h"
#import "JSAlphedScrollView.h"

@implementation JSDetailedTableView {
    UIView *_headerContainerView;
    JSPxView *_separatorView;
    JSAlphedScrollView *_detailScrollView;

    NSLayoutConstraint *_scrollViewLeftConstraint;
}

#pragma mark - Interface methods

- (instancetype)initWithMainController:(UITableViewController *)mainController detailController:(UITableViewController *)detailController {
    JSParameterAssert(mainController);
    JSParameterAssert(detailController);

    self = [super init];
    if (self) {
        self.clipsToBounds = YES;

        {
            UITableView *tableView = mainController.tableView;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.backgroundColor = UIColor.clearColor;

            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:tableView];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
        };

        _detailScrollView = ({
            JSAlphedScrollView *view = [[JSAlphedScrollView alloc] init];
            view.scrollView.alwaysBounceVertical = NO;
            view.scrollView.showsHorizontalScrollIndicator = NO;
            view.scrollView.showsVerticalScrollIndicator = NO;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });

        _scrollViewLeftConstraint = ({
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_detailScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
            [self addConstraint:constraint];
            constraint;
        });

        _headerContainerView = ({
            UIView *view = [[UIView alloc] init];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [_detailScrollView.scrollView addSubview:view];

            [_detailScrollView.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [_detailScrollView.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            [self addConstraint:[NSLayoutConstraint constraintWithItem:mainController.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];

            view;
        });

        _separatorView = ({
            JSPxView *separatorView = [[JSPxView alloc] initWithType:JSPxViewTypeHorizontal];

            separatorView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:separatorView];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separatorView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(separatorView)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerContainerView][separatorView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headerContainerView, separatorView)]];

            separatorView;
        });

        {
            UITableView *tableView = detailController.tableView;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.backgroundColor = UIColor.clearColor;

            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            [_detailScrollView.scrollView addSubview:tableView];

            [_detailScrollView.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
            [_detailScrollView.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerContainerView][tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headerContainerView, tableView)]];

            [self addConstraint:[NSLayoutConstraint constraintWithItem:mainController.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:tableView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
        };
    }
    return self;
}

- (JSPxView *)separatorView {
    return _separatorView;
}

- (UIScrollView *)detailScrollView {
    return _detailScrollView.scrollView;
}

- (void)setHeaderView:(UIView *)headerView {
    JSParameterAssert(headerView);

    for (UIView *subview in _headerContainerView.subviews) {
        [subview removeFromSuperview];
    }

    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_headerContainerView addSubview:headerView];

    [_headerContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerView)]];
    [_headerContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerView)]];
}

- (void)setMainTableViewWidth:(CGFloat)width {
    _scrollViewLeftConstraint.constant = width;
}

@end
