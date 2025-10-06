// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSGameStatistic.h"
#import "JSGameStatisticEntity+CoreDataClass.h"

@implementation JSGameStatistic {
    NSNumber *_statisticId;
    NSString *_title;
    NSString *_home;
    NSString *_away;
    CGFloat _homeValue;
    CGFloat _awayValue;
}

#pragma mark - Interface methods

- (instancetype)initWithEntity:(JSGameStatisticEntity *)entity {
    JSParameterAssert(entity);

    self = [super init];
    if (self) {
        _statisticId = @(entity.statisticId);
        _title = entity.title;
        _home = [@(entity.home) stringValue];
        _away = [@(entity.away) stringValue];

        CGFloat total = entity.home + entity.away;
        if (total > 0) {
            _homeValue = entity.home / total;
            _awayValue = (CGFloat) 1.0 - _homeValue;
        }
        else {
            _homeValue = 0.0;
            _awayValue = 0.0;
        }
    }
    return self;
}

- (NSNumber *)statisticId {
    return _statisticId;
}

- (NSString *)title {
    return _title;
}

- (NSString *)home {
    return _home;
}

- (NSString *)away {
    return _away;
}

- (CGFloat)homeValue {
    return _homeValue;
}

- (CGFloat)awayValue {
    return _awayValue;
}

@end
