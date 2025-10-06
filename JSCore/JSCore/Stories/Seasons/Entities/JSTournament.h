// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSTournamentEntity;

@interface JSTournament : NSObject

- (instancetype)initWithEntity:(JSTournamentEntity *)entity;

- (NSArray *)seasons;
- (NSString *)tournamentId;
- (NSString *)name;

@end
