// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;
@import JSHTTP;

#import "JSSettingsViewModel.h"
#import "JSAPIClient.h"
#import "JSTeam.h"
#import "JSStandingsRecordEntity+CoreDataClass.h"

NSString *const JSSettingsViewModelStatusUpdatedNotification = @"JSSettingsViewModelStatusUpdatedNotification";
NSString *const JSSettingsViewModelStatusUpdatedNotificationTeamsKey = @"JSSettingsViewModelStatusUpdatedNotificationTeamsKey";
NSString *const JSSettingsViewModelStatusUpdatedNotificationErrorKey = @"JSSettingsViewModelStatusUpdatedNotificationErrorKey";

static NSString *const JSSettingsViewModelKeyNotifications = @"JSSettingsViewModelKeyNotifications";
static NSString *const JSSettingsViewModelKeyNotificationsTeams = @"JSSettingsViewModelKeyNotificationsTeams";

@implementation JSSettingsViewModel {
    JSAPIClient *_apiClient;
    NSArray *_teams;
    NSURL *_placeholder;

    NSMutableSet *_notificationsOnIds;
    NSMutableSet *_idsToToggle;
    BOOL _notificationsOn;
    BOOL _toggleStatus;
    BOOL _inProgress;
}

#pragma mark - Private methods

- (void)initNotificationsStatuses {
    NSArray *ids = [NSUserDefaults.standardUserDefaults arrayForKey:JSSettingsViewModelKeyNotificationsTeams];
    if (ids) {
        _notificationsOnIds = [[NSMutableSet alloc] initWithArray:ids];
    }
    else {
        _notificationsOnIds = [[NSMutableSet alloc] init];
    }

    _notificationsOn = [NSUserDefaults.standardUserDefaults boolForKey:JSSettingsViewModelKeyNotifications];
}

- (void)storeNotificationsStatuses {
    [NSUserDefaults.standardUserDefaults setObject:_notificationsOnIds.allObjects forKey:JSSettingsViewModelKeyNotificationsTeams];
    [NSUserDefaults.standardUserDefaults setBool:_notificationsOn forKey:JSSettingsViewModelKeyNotifications];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)processPendingIds {
    if (_inProgress) {
        NSError *error = [NSError errorWithDomain:@"JSSettingsDomain"
                                                 code:1001
                                             userInfo:@{ NSLocalizedDescriptionKey: @"In Progress" }];
        NSDictionary *info = @{
            JSSettingsViewModelStatusUpdatedNotificationErrorKey: error
        };
        [NSNotificationCenter.defaultCenter postNotificationName:JSSettingsViewModelStatusUpdatedNotification object:nil userInfo:info];
        return;
    }

    if (_token.length == 0) {
        NSError *error = [NSError errorWithDomain:@"JSSettingsDomain"
                                                 code:1001
                                             userInfo:@{ NSLocalizedDescriptionKey: @"Token is empty" }];
            
        NSDictionary *info = @{
            JSSettingsViewModelStatusUpdatedNotificationErrorKey: error
        };
        _toggleStatus = false;
        [NSNotificationCenter.defaultCenter postNotificationName:JSSettingsViewModelStatusUpdatedNotification object:nil userInfo:info];
        return;
    }

    if (_idsToToggle.count == 0 && !_toggleStatus) {
        return;
    }

    _inProgress = YES;

    NSSet *togglingIds = _toggleStatus ? nil : _idsToToggle.copy;

    NSSet *cid;
    if (_toggleStatus) {
        cid = _notificationsOn ? nil : _notificationsOnIds.copy;
    }
    else {
        NSMutableSet *idsToRemove = _notificationsOnIds.mutableCopy;
        [idsToRemove intersectSet:togglingIds];

        NSMutableSet *idsToSend = [_notificationsOnIds setByAddingObjectsFromSet:togglingIds].mutableCopy;
        [idsToSend minusSet:idsToRemove];

        cid = idsToSend;
    }

    if (!_toggleStatus && !_notificationsOn) {
        [self finishProcessing:togglingIds cid:cid error:nil];
        return;
    }

    JSHTTPRequest *request = [[JSHTTPRequest alloc] initWithPath:@"index.php" params:@{
            @"option": @"com_joomsport",
            @"controller": @"aws",
            @"task": @"addTeams",
            @"tmpl": @"component",
            @"token": self.token,
            @"cid": (cid.count > 0) ? [cid.allObjects componentsJoinedByString:@","] : @"0"
    }];
    request.expectsResponse = NO;

    JSWeakify(request);
    JSWeakify(self);
    request.onFinish = ^{
        JSStrongify(request);
        JSStrongify(self);

        [self finishProcessing:togglingIds cid:cid error:request.error];
    };

    [_apiClient.httpClient perform:request];
}

- (void)finishProcessing:(NSSet *)togglingIds cid:(NSSet *)cid error:(NSError *)error {

    NSDictionary *info;

    if (error) {
        info = @{
                JSSettingsViewModelStatusUpdatedNotificationErrorKey: error
        };
    }
    else {
        if (togglingIds.count > 0) {
            self->_notificationsOnIds = cid.mutableCopy;
            [self->_notificationsOnIds removeObject:@0];
            [self->_idsToToggle minusSet:togglingIds];

            info = @{
                    JSSettingsViewModelStatusUpdatedNotificationTeamsKey: [self teams:togglingIds]
            };
        }
        else {
            self->_notificationsOn = !self->_notificationsOn;
            self->_toggleStatus = NO;
        }

        [self storeNotificationsStatuses];
    }

    self->_inProgress = NO;
    [self processPendingIds];

    [NSNotificationCenter.defaultCenter postNotificationName:JSSettingsViewModelStatusUpdatedNotification object:nil userInfo:info];
}

- (NSArray *)teams:(NSSet *)ids {
    return [_teams filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSTeam *team, NSDictionary *bindings) {
        return [ids containsObject:team.teamId];
    }]];
}

#pragma mark - Interface methods

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient {
    JSParameterAssert(apiClient);

    self = [super init];
    if (self) {
        _apiClient = apiClient;
        _idsToToggle = [[NSMutableSet alloc] init];

        _placeholder =  ({
            NSString *placeholderPath = [_apiClient.httpClient.base stringByAppendingPathComponent:@"media/bearleague/teams_st.png"];
            [[NSURL alloc] initWithString:placeholderPath];
        });

        [self initNotificationsStatuses];
        [self update];
    }
    return self;
}

- (void)update {
    __block NSArray *teams;
    NSManagedObjectContext *context = _apiClient.coreDataManager.workingContext;

    [context performBlockAndWait:^{
        teams = [[JSStandingsRecordEntity js_all:context] js_map:^JSTeam *(JSStandingsRecordEntity *entity) {
            return [[JSTeam alloc] initWithStandingsRecordEntity:entity teamPlaceholder:self->_placeholder playerPlaceholder:self->_placeholder];
        }];
    }];

    NSMutableSet *ids = [[NSMutableSet alloc] init];
    _teams = [[teams filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSTeam *team, NSDictionary *bindings) {
        if ([ids containsObject:team.teamId]) {
            return NO;
        }
        else {
            [ids addObject:team.teamId];
            return YES;
        }
    }]] sortedArrayUsingComparator:^NSComparisonResult(JSTeam *team1, JSTeam *team2) {
        return [team1.name compare:team2.name];
    }];
}

- (NSArray *)teams {
    return _teams;
}

- (void)sendSettings {
    if (!_notificationsOn) {
        return;
    }

    _notificationsOn = NO;
    [self toggleNotifications];
}

- (JSSettingsViewModelStatus)notificationsStatus {
    if (_toggleStatus) {
        return JSSettingsViewModelStatusInProgress;
    }
    else if (_notificationsOn) {
        return JSSettingsViewModelStatusOn;
    }
    else {
        return JSSettingsViewModelStatusOff;
    }
}

- (void)toggleNotifications {
    _toggleStatus = YES;
    [self processPendingIds];

    [NSNotificationCenter.defaultCenter postNotificationName:JSSettingsViewModelStatusUpdatedNotification object:nil];
}

- (JSSettingsViewModelStatus)notificationsStatusFor:(JSTeam *)team {
    if ([_idsToToggle containsObject:team.teamId]) {
        return JSSettingsViewModelStatusInProgress;
    }
    else if ([_notificationsOnIds containsObject:team.teamId]) {
        return JSSettingsViewModelStatusOn;
    }
    else {
        return JSSettingsViewModelStatusOff;
    }
}

- (void)toggleNotificationsFor:(JSTeam *)team {
    [_idsToToggle addObject:team.teamId];
    [self processPendingIds];

    NSDictionary *info = @{
            JSSettingsViewModelStatusUpdatedNotificationTeamsKey: @[team]
    };
    [NSNotificationCenter.defaultCenter postNotificationName:JSSettingsViewModelStatusUpdatedNotification object:nil userInfo:info];
}

@end
