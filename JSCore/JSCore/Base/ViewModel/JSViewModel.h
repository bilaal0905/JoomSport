// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSAPIClient;
@class JSRequest;
@class JSCoreDataManager;
@class NSManagedObjectContext;

@interface JSViewModel : NSObject

@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, assign, readonly) BOOL isUpdating;

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient;
- (void)update;
- (void)cancel;

- (void)initData:(NSManagedObjectContext *)context;
- (JSRequest *)request:(JSCoreDataManager *)coreDataManager;
- (BOOL)skip:(JSRequest *)request;

- (void)invalidate;
- (NSString *)base;

@end
