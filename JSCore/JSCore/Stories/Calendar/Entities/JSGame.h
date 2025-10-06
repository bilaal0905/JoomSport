// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSGameEntity;
@class JSGameTeam;

typedef NS_ENUM(NSUInteger, JSGameStatus) {
    JSGameStatusNotPlayed,
    JSGameStatusPlayed
};

@interface JSGame : NSObject

- (instancetype)initWithEntity:(JSGameEntity *)entity placeholder:(NSURL *)placeholder;

- (NSString *)gameId;
- (NSDate *)date;
- (NSString *)dateString;
- (NSString *)mdayString;
- (NSString *)venue;
- (JSGameStatus)status;
- (JSGameTeam *)home;
- (JSGameTeam *)away;
- (NSURL *)placeholder;
- (NSArray *)stages;
- (NSString *)info;
- (NSArray *)extras;

@end
