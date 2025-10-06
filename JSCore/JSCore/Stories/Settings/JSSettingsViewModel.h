// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSAPIClient;
@class JSTeam;

typedef NS_ENUM(NSInteger, JSSettingsViewModelStatus) {
    JSSettingsViewModelStatusOn,
    JSSettingsViewModelStatusOff,
    JSSettingsViewModelStatusInProgress
};

typedef void (^JSSettingsViewModelCompletionBlock)();

extern NSString *const JSSettingsViewModelStatusUpdatedNotification;
extern NSString *const JSSettingsViewModelStatusUpdatedNotificationTeamsKey;
extern NSString *const JSSettingsViewModelStatusUpdatedNotificationErrorKey;

@interface JSSettingsViewModel : NSObject

@property (nonatomic, copy) NSString *token;

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient;
- (void)update;
- (NSArray *)teams;

- (void)sendSettings;

- (JSSettingsViewModelStatus)notificationsStatus;
- (void)toggleNotifications;

- (JSSettingsViewModelStatus)notificationsStatusFor:(JSTeam *)team;
- (void)toggleNotificationsFor:(JSTeam *)team;

@end
