// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import CoreData;
@import JSUtils.JSScope;
@import JSUIKit.JSWindow;

#import "JSAppDelegate.h"
#import "JSRouter.h"
#import "JSModelsStore.h"
#import "JSAPNManager.h"

@implementation JSAppDelegate {
    JSRouter *_router;
    JSAPNManager *_apnManager;
}

#pragma mark - UIApplicationDelegate protocol

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    #if defined(DEBUG)
        NSString *type = [NSProcessInfo.processInfo.environment[@"DEBUG_EMPTY_DB"] boolValue] ? NSInMemoryStoreType : NSSQLiteStoreType;
    #else
        NSString *type = NSSQLiteStoreType;
    #endif

    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:settings];

    JSAPIClient *client = [[JSAPIClient alloc] initWithType:type];
    JSModelsStore *store = [[JSModelsStore alloc] initWithAPIClient:client];
    _router = [[JSRouter alloc] initWithModelsStore:store];
    _apnManager = [[JSAPNManager alloc] initWithHTTPClient:client.httpClient];

    store.settingsViewModel.token = _apnManager.token;

    JSWeakify(self);
    _apnManager.gameHandler = ^(NSString *gameId, NSString *seasonId) {
        JSStrongify(self);
        [self->_router open:gameId of:seasonId];
    };

    JSWeakify(store);
    _apnManager.tokenHandler = ^(NSString *token) {
        JSStrongify(store);
        store.settingsViewModel.token = token;
        [store.settingsViewModel sendSettings];
    };

    self.window = ({
        JSWindow *window = [[JSWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        window.rootViewController = _router.rootViewController;
        [window makeKeyAndVisible];
        [window js_showLaunchScreen:2];
        window;
    });

    [_apnManager handle:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    _apnManager.token = deviceToken;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [_apnManager handle:userInfo];
}
- (void)application:(UIApplication *)application
        didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Remote notification support is unavailable due to error: %@", error);
    
}
@end
