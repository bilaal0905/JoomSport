// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit.UIViewController_JSUIKit;

#import "JSSettingsTeamsTableViewController.h"
#import "JSSettingsTeamCell.h"
#import "UIView+JS.h"
#import "UIColor+JS.h"

@implementation JSSettingsTeamsTableViewController {
    JSSettingsViewModel *_model;
}

#pragma mark - Private methods

- (void)updateShadowPath {
    CGRect rect = CGRectZero;
    rect.origin.x = 12.0;
    rect.origin.y = 12.0;
    rect.size.width = self.tableView.contentSize.width - 24.0;
    rect.size.height = self.tableView.contentSize.height - 24.0;
    self.tableView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:8.0].CGPath;
}

- (void)onJSSettingsViewModelStatusUpdatedNotification:(NSNotification *)notification {

    NSError *error = notification.userInfo[JSSettingsViewModelStatusUpdatedNotificationErrorKey];
    if (error) {
        [self js_showError:error.js_error];
    }

    if (_model.teams.count == 0) {
        return;
    }

    NSArray *indexes = [notification.userInfo[JSSettingsViewModelStatusUpdatedNotificationTeamsKey] js_map:^id(JSTeam *team) {
        NSInteger index = [self->_model.teams indexOfObject:team];
        index = (index == NSNotFound) ? 0 : index;
        return [NSIndexPath indexPathForRow:index inSection:0];
    }];

    [self.tableView reloadRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - NSObject methods

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorColor = UIColor.js_Separator;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 12.0)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 12.0)];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView js_setupShadow];

    [self.tableView registerClass:JSSettingsTeamCell.class forCellReuseIdentifier:NSStringFromClass(JSSettingsTeamCell.class)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateShadowPath];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateShadowPath];
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.teams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSSettingsTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSSettingsTeamCell.class)];
    JSTeam *team = _model.teams[indexPath.row];
    
    [cell setup:team];
    [cell roundTop:(indexPath.row == 0) bottom:(indexPath.row == [tableView numberOfRowsInSection:0] - 1)];

    switch ([_model notificationsStatusFor:team]) {
        case JSSettingsViewModelStatusOn:
            cell.status = JSSettingsTeamCellStatusOn;
            break;

        case JSSettingsViewModelStatusOff:
            cell.status = JSSettingsTeamCellStatusOff;
            break;

        case JSSettingsViewModelStatusInProgress:
            cell.status = JSSettingsTeamCellStatusInProgress;
            break;
    }

    JSWeakify(self);
    cell.onChange = ^{
        JSStrongify(self);
        [self->_model toggleNotificationsFor:team];
    };

    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JSSettingsTeamCellHeight;
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSSettingsViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        _model = model;

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onJSSettingsViewModelStatusUpdatedNotification:) name:JSSettingsViewModelStatusUpdatedNotification object:nil];
    }
    return self;
}

@end
