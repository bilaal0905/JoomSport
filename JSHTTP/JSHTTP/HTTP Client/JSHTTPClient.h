// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSHTTPRequest;

extern NSErrorDomain const JSHTTPClientError;

typedef NS_ENUM(NSInteger, JSHTTPClientErrorCode) {
    JSHTTPClientErrorCodeInternalServerError,
    JSHTTPClientErrorCodeInvalidResponse
};

@interface JSHTTPClient : NSObject

- (instancetype)initWithBase:(NSString *)base;
- (void)perform:(JSHTTPRequest *)request;
- (NSString *)base;

@end
