// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSStandingsGroupEntity;

@interface JSStandingsGroup : NSObject

- (instancetype)initWithEntity:(JSStandingsGroupEntity *)entity sortIndex:(NSInteger)sortIndex placeholder:(NSURL *)placeholder skipName:(BOOL)skipName;

- (NSString *)name;
- (NSArray *)records;

@end
