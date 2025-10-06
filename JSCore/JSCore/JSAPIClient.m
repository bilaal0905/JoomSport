// Created for BearDev by drif
// drif@mail.ru

@import JSHTTP.JSHTTPClient;
@import JSCoreData.JSCoreDataManager;
@import JSUtils;

#import "JSAPIClient.h"

@implementation JSAPIClient {
    JSHTTPClient *_httpClient;
    JSCoreDataManager *_coreDataManager;
}

#pragma mark - Private methods

+ (NSURL *)modelURL {
    return [[NSBundle bundleForClass:self.class] URLForResource:@"JSCore" withExtension:@"momd"];
}

+ (NSURL *)storageURL {
    return [NSURL.js_cachesURL URLByAppendingPathComponent:@"JSCore.sqlite"];
}

#pragma mark - Interface methods

- (instancetype)initWithType:(NSString *)type {
    JSParameterAssert(type);

    self = [super init];
    if (self) {
        _httpClient = [[JSHTTPClient alloc] initWithBase:@"https://www.baerner-cup.ch"];
        _coreDataManager = [[JSCoreDataManager alloc] initWithModelURL:self.class.modelURL type:type url:self.class.storageURL];
    }
    return self;
}

- (JSHTTPClient *)httpClient {
    return _httpClient;
}

- (JSCoreDataManager *)coreDataManager {
    return _coreDataManager;
}

@end
