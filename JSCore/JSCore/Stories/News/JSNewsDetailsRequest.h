// Created for BearDev by drif
// drif@mail.ru

#import "JSRequest.h"

@interface JSNewsDetailsRequest : JSRequest

- (instancetype)initWithId:(NSString *)newsId coreDataManager:(JSCoreDataManager *)coreDataManager;
- (NSString *)newsId;

@end
