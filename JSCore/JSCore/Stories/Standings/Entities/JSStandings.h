// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSStandingsEntity;

@interface JSStandings : NSObject

- (instancetype)initWithEntity:(JSStandingsEntity *)entity sortIndex:(NSInteger)sortIndex placeholder:(NSURL *)placeholder;

- (NSArray *)fields;
- (NSArray *)groups;

@end
