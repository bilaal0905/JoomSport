// Created for BearDev by drif
// drif@mail.ru

#import "JSSeasonedRequest.h"

@interface JSTeamRequest : JSSeasonedRequest

- (instancetype)initWithTeamId:(NSString *)teamId seasonId:(NSString *)seasonId coreDataManager:(JSCoreDataManager *)coreDataManager;
- (NSString *)teamId;

@end
