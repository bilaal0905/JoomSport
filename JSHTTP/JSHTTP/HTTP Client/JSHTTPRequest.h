// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

typedef void (^JSHTTPRequestHandler)();

@interface JSHTTPRequest : NSObject

@property (nonatomic, assign) BOOL expectsResponse;
@property (nonatomic, copy) JSHTTPRequestHandler onFinish;

- (instancetype)initWithPath:(NSString *)path params:(NSDictionary *)params;
- (NSURL *)url:(NSURL *)base;

- (void)process:(NSError *)error;
- (void)process:(NSDictionary *)json data:(NSData *)data;

- (NSError *)error;
- (NSDictionary *)json;

@end
