// Created for BearDev by drif
// drif@mail.ru

#import "JSRequest.h"

@class JSCoreDataManager;

@interface JSSeasonedRequest : JSRequest

- (instancetype)initWithPath:(NSString *)path seasonId:(NSString *)seasonId coreDataManager:(JSCoreDataManager *)coreDataManager;
- (NSString *)seasonId;

@end
