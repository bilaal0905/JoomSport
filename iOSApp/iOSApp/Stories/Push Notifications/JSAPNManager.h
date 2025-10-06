// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSHTTPClient;
@class JSSettingsViewModel;

typedef void (^JSAPNManagerGameHandler)(NSString *gameId, NSString *seasonId);
typedef void (^JSAPNManagerTokenHandler)(NSString *token);

extern NSString *const JSAPNManagerResetBadgeNotification;

@interface JSAPNManager : NSObject

@property (nonatomic, copy) JSAPNManagerGameHandler gameHandler;
@property (nonatomic, copy) JSAPNManagerTokenHandler tokenHandler;

- (instancetype)initWithHTTPClient:(JSHTTPClient *)httpClient;

- (void)setToken:(NSData *)token;
- (NSString *)token;
- (void)handle:(NSDictionary *)userInfo;

@end
