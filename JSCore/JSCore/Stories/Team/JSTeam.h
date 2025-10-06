// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSTeamEntity;
@class JSStandingsRecordEntity;
@class JSGameTeamEntity;

@interface JSTeam : NSObject

- (instancetype)initWithTeamEntity:(JSTeamEntity *)entity teamPlaceholder:(NSURL *)teamPlaceholder playerPlaceholder:(NSURL *)playerPlaceholder;
- (instancetype)initWithStandingsRecordEntity:(JSStandingsRecordEntity *)entity teamPlaceholder:(NSURL *)teamPlaceholder playerPlaceholder:(NSURL *)playerPlaceholder;
- (instancetype)initWithGameTeamEntity:(JSGameTeamEntity *)entity teamPlaceholder:(NSURL *)teamPlaceholder playerPlaceholder:(NSURL *)playerPlaceholder;

- (NSString *)teamId;
- (NSString *)name;
- (NSURL *)logoURL;
- (NSURL *)placeholder;
- (NSArray *)extras;
- (NSString *)info;
- (NSArray *)players;

@end
