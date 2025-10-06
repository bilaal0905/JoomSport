// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSGameEventEntity;

@interface JSGameEvent : NSObject

- (instancetype)initWithEntity:(JSGameEventEntity *)entity;

- (BOOL)isHome;
- (NSString *)playerName;
- (NSNumber *)minute;
- (NSURL *)iconURL;

@end
