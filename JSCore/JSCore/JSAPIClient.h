// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSHTTPClient;
@class JSCoreDataManager;

@interface JSAPIClient : NSObject

- (instancetype)initWithType:(NSString *)type;

- (JSHTTPClient *)httpClient;
- (JSCoreDataManager *)coreDataManager;

@end
