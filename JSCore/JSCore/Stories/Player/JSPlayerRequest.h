// Created for BearDev by drif
// drif@mail.ru

#import "JSSeasonedRequest.h"

@interface JSPlayerRequest : JSSeasonedRequest

- (instancetype)initWithPlayerId:(NSString *)playerId seasonId:(NSString *)seasonId coreDataManager:(JSCoreDataManager *)coreDataManager;
- (NSString *)playerId;

@end
