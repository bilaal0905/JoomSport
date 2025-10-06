// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSGameTeamEntity;

@interface JSGameTeam : NSObject

- (instancetype)initWithEntity:(JSGameTeamEntity *)entity skipScore:(BOOL)skipScore;

- (NSString *)teamId;
- (NSString *)name;
- (NSString *)score;
- (NSURL *)logoURL;

@end
