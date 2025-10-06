// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSCompetitorEntity;
@class JSStandingsRecordEntity;
@class JSGameTeamEntity;

@interface JSPlayer : NSObject

- (instancetype)initWithCompetitorEntity:(JSCompetitorEntity *)entity placeholder:(NSURL *)placeholder;
- (instancetype)initWithStandingsRecordEntity:(JSStandingsRecordEntity *)entity placeholder:(NSURL *)placeholder;
- (instancetype)initWithGameTeamEntity:(JSGameTeamEntity *)entity placeholder:(NSURL *)placeholder;

- (NSString *)playerId;
- (NSString *)name;
- (NSURL *)photoURL;
- (NSURL *)placeholder;
- (NSString *)info;
- (NSArray *)extras;
- (NSArray *)statistic;

@end
