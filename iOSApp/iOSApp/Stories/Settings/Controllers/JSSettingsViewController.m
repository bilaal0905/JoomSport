// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSUIKit;
@import JSCore;

#import "JSSettingsViewController.h"
#import "JSTitledView.h"
#import "JSSettingsSectionHeader.h"
#import "JSSettingsSectionFooter.h"
#import "JSSettingsCell.h"
#import "JSSettingsArrowedCell.h"
#import "JSSettingsSwitchCell.h"
#import "JSBackButton.h"

@interface JSSettingsViewController () <
    UITableViewDataSource,
    UITableViewDelegate
>

@end

@implementation JSSettingsViewController {
    UITableView *_tableView;
    JSSettingsViewModel *_model;
}

#pragma mark - Private methods

- (void)onJSSettingsViewModelStatusUpdatedNotification:(NSNotification *)notification {

    NSError *error = notification.userInfo[JSSettingsViewModelStatusUpdatedNotificationErrorKey];
    if (error) {
        [self js_showError:error.js_error];
    }

    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - NSObject methods

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titledView.backButton.hidden = YES;

    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.separatorColor = UIColor.clearColor;
        tableView.backgroundColor = UIColor.clearColor;;

        [tableView registerClass:JSSettingsArrowedCell.class forCellReuseIdentifier:NSStringFromClass(JSSettingsArrowedCell.class)];
        [tableView registerClass:JSSettingsSwitchCell.class forCellReuseIdentifier:NSStringFromClass(JSSettingsSwitchCell.class)];
        [tableView registerClass:JSSettingsSectionHeader.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(JSSettingsSectionHeader.class)];
        [tableView registerClass:JSSettingsSectionFooter.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(JSSettingsSectionFooter.class)];

        tableView.dataSource = self;
        tableView.delegate = self;

        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.titledView.contentContainer addSubview:tableView];

        [self.titledView.contentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
        [self.titledView.contentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];

        tableView;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView deselectRowAtIndexPath:(NSIndexPath * _Nonnull) _tableView.indexPathForSelectedRow animated:animated];
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            JSSettingsSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSSettingsSwitchCell.class)];
            cell.title = NSLocalizedString(@"Match Score", nil);

            switch (_model.notificationsStatus) {
                case JSSettingsViewModelStatusOn:
                    cell.status = JSSettingsSwitchCellStatusOn;
                    break;

                case JSSettingsViewModelStatusOff:
                    cell.status = JSSettingsSwitchCellStatusOff;
                    break;

                case JSSettingsViewModelStatusInProgress:
                    cell.status = JSSettingsSwitchCellStatusInProgress;
                    break;
            }

            JSWeakify(self);
            cell.onSwitch = ^{
                JSStrongify(self);
                [self->_model toggleNotifications];
            };

            return cell;
        }

        case 1: {
            JSSettingsArrowedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JSSettingsArrowedCell.class)];
            cell.title = NSLocalizedString(@"Teams", nil);
            return cell;
        }

        default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JSSettingsSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return JSSettingsSectionFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JSSettingsCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JSSettingsSectionHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(JSSettingsSectionHeader.class)];

    switch (section) {
        case 0:
            view.text = NSLocalizedString(@"NOTIFICATIONS", nil);
            break;

        case 1:
            view.text = NSLocalizedString(@"FOLLOW OPTIONS", nil);
            break;

        default:
            break;
    }

    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    JSSettingsSectionFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(JSSettingsSectionFooter.class)];

    switch (section) {
        case 0:
            view.text = NSLocalizedString(@"Choose events to be notified", nil);
            break;

        case 1:
            view.text = NSLocalizedString(@"Select teams and seasons that you would like to follow", nil);
            break;

        default:
            break;
    }

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]]) {
        JSBlock(self.onTeamsTap, nil);
    }
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSSettingsViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        _model = model;

        self.title = NSLocalizedString(@"Settings", nil);
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar_settings"].js_original selectedImage:[UIImage imageNamed:@"tabbar_settings_selected"].js_original];

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onJSSettingsViewModelStatusUpdatedNotification:) name:JSSettingsViewModelStatusUpdatedNotification object:nil];
    }
    return self;
}

@end
