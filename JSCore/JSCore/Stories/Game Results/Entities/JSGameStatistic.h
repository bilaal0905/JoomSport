// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSGameStatisticEntity;

@interface JSGameStatistic : NSObject

- (instancetype)initWithEntity:(JSGameStatisticEntity *)entity;

- (NSNumber *)statisticId;
- (NSString *)title;
- (NSString *)home;
- (NSString *)away;
- (CGFloat)homeValue;
- (CGFloat)awayValue;

@end
