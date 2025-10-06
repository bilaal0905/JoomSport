// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSSeasonEntity;

@interface JSSeason : NSObject <
    NSCoding
>

- (instancetype)initWithEntity:(JSSeasonEntity *)entity;

- (NSString *)seasonId;
- (NSString *)name;
- (NSString *)fullName;
- (BOOL)isSinglePlayer;

@end