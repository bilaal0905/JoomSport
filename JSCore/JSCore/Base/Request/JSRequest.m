// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;

#import "JSRequest.h"

@implementation JSRequest {
    JSCoreDataManager *_coreDataManager;
}

#pragma mark - JSHTTPRequest methods

- (void)process:(NSDictionary *)json data:(NSData *)data {
    [super process:json data:data];

    JSParameterAssert(json);
    JSParameterAssert(data);

    NSManagedObjectContext *context = _coreDataManager.workingContext;
    [context performBlockAndWait:^{
        @try {
            [self map:json from:data in:context];
            [context js_saveToStore];
        }
        @catch (NSException *e) {
            JSLogError(@"Exception while parsing json\n\texception: %@\n\tjson: %@", e, json);
        }
    }];
}

#pragma mark - Interface methods

- (instancetype)initWithPath:(NSString *)path coreDataManager:(JSCoreDataManager *)coreDataManager {
    return [self initWithPath:path coreDataManager:coreDataManager extraParams:@{}];
}

- (instancetype)initWithPath:(NSString *)path coreDataManager:(JSCoreDataManager *)coreDataManager extraParams:(NSDictionary *)params {
    JSParameterAssert(coreDataManager);
    JSParameterAssert(params);

    params = ({
        NSMutableDictionary *dict = params.mutableCopy;
        dict[@"jsformat"] = @"json";
        dict.copy;
    });

    self = [super initWithPath:path params:params];
    if (self) {
        _coreDataManager = coreDataManager;
    }
    return self;
}

- (void)map:(NSDictionary *)json from:(NSData *)data in:(NSManagedObjectContext *)context {}

@end
