// Created for BearDev by drif
// drif@mail.ru

@import JSHTTP.JSHTTPRequest;

@class JSCoreDataManager;
@class NSManagedObjectContext;

@interface JSRequest : JSHTTPRequest

- (instancetype)initWithPath:(NSString *)path coreDataManager:(JSCoreDataManager *)coreDataManager;
- (instancetype)initWithPath:(NSString *)path coreDataManager:(JSCoreDataManager *)coreDataManager extraParams:(NSDictionary *)params;

- (void)map:(NSDictionary *)json from:(NSData *)data in:(NSManagedObjectContext *)context;

@end
