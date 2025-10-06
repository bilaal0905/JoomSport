// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSStandingsRecordEntity;

@interface JSStandingsRecord : NSObject

- (instancetype)initWithEntity:(JSStandingsRecordEntity *)entity placeholder:(NSURL *)placeholder;

- (NSNumber *)rank;
- (NSString *)rankString;
- (NSString *)teamId;
- (NSString *)teamName;
- (NSURL *)teamLogoURL;
- (NSURL *)placeholder;
- (NSArray *)values;
- (NSArray *)valuesStrings;

@end
