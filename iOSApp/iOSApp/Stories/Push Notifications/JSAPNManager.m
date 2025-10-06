// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSHTTP;

#import "JSAPNManager.h"

static NSString *const JSAPNManagerTokenKey = @"JSAPNManagerTokenKey";
NSString *const JSAPNManagerResetBadgeNotification = @"JSAPNManagerResetBadgeNotification";

@implementation JSAPNManager {
    JSHTTPClient *_httpClient;
    NSString *_token;
}

#pragma mark - Private methods

- (void)onJSAPNManagerResetBadgeNotification {
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0;

    JSHTTPRequest *request = [[JSHTTPRequest alloc] initWithPath:@"index.php" params:@{
            @"option": @"com_joomsport",
            @"controller": @"aws",
            @"task": @"updBadge",
            @"badge": @"0",
            @"tmpl": @"component",
            @"token": _token
    }];
    request.expectsResponse = NO;

    [_httpClient perform:request];
}

#pragma mark - NSObject methods

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - Interface methods

- (instancetype)initWithHTTPClient:(JSHTTPClient *)httpClient {
    JSParameterAssert(httpClient);

    self = [super init];
    if (self) {
        _httpClient = httpClient;
        _token = [NSUserDefaults.standardUserDefaults stringForKey:JSAPNManagerTokenKey] ?: @"";

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onJSAPNManagerResetBadgeNotification) name:JSAPNManagerResetBadgeNotification object:nil];
    }
    return self;
}

- (void)setToken:(NSData *)tokenData {
    JSParameterAssert(tokenData);

//    NSString *token = [NSString stringWithFormat:@"%@", tokenData];
//    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    const unsigned *tokenBytes = [tokenData bytes];
    NSString *token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];

    if (![token isEqualToString:_token]) {
        _token = token;

        [NSUserDefaults.standardUserDefaults setObject:_token forKey:JSAPNManagerTokenKey];
        [NSUserDefaults.standardUserDefaults synchronize];

        JSBlock(self.tokenHandler, token);
    }
}

- (NSString *)token {
    return _token;
}

- (void)handle:(NSDictionary *)userInfo {
    if (!userInfo) {
        return;
    }

    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive) {
        return;
    }

    NSString *message = userInfo[@"joomsport_message"];
    NSString *gameId = [userInfo[@"joomsport_matchID"] js_string];
    NSString *seasonId = [userInfo[@"joomsport_seasonID"] js_string];

    if (message.length == 0 || gameId.length == 0 || seasonId.length == 0) {
        return;
    }

    NSString *homeId = [userInfo[@"joomsport_homeID"] js_string];
    NSString *awayId = [userInfo[@"joomsport_awayID"] js_string];
    
    if (homeId.length == 0 || awayId.length == 0) {
        return;
    }

    JSBlock(self.gameHandler, gameId, seasonId);
}

@end
