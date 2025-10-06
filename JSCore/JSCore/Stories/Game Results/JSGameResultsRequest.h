// Created for BearDev by drif
// drif@mail.ru

#import "JSRequest.h"

@class JSCoreDataManager;

@interface JSGameResultsRequest : JSRequest

- (instancetype)initWithGameId:(NSString *)gameId of:(NSString *)seasonId coreDataManager:(JSCoreDataManager *)coreDataManager;

@end
