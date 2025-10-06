// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit.JSBarButtonItem;

#import "JSCalendarParticipantsViewController.h"

@implementation JSCalendarParticipantsViewController {
    JSCalendarViewModel *_model;
    JSKeyPathObserver *_observer;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];

    JSWeakify(self);
    _observer = [JSKeyPathObserver observerFor:_model keyPath:@"participants" handler:^{
        JSStrongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.participants.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = (indexPath.row == 0) ? NSLocalizedString(@"All teams", nil) : [_model.participants[indexPath.row - 1] name];
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _model.participant = (indexPath.row == 0) ? nil : _model.participants[indexPath.row - 1];
    JSBlock(self.onDone, nil);
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSCalendarViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Matches with", nil);

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
