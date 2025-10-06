// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit.JSBarButtonItem;

#import "JSStandingsSortViewController.h"

@implementation JSStandingsSortViewController {
    JSStandingsViewModel *_model;
    JSKeyPathObserver *_observer;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];

    JSWeakify(self);
    _observer = [JSKeyPathObserver observerFor:_model keyPath:@"standings" handler:^{
        JSStrongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.standings.fields.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = (indexPath.row == 0) ? NSLocalizedString(@"Rank", nil) : _model.standings.fields[indexPath.row - 1];
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _model.sortIndex = indexPath.row - 1;
    JSBlock(self.onDone, nil);
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSStandingsViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Sort by", nil);

        _model = model;

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
    return self;
}

@end
