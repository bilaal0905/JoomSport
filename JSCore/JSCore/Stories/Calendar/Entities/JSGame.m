// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSGame.h"
#import "NSDate+JSCore.h"
#import "JSGameEntity+CoreDataClass.h"
#import "JSGameTeam.h"
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@implementation JSGame {
    NSString *_gameId;
    NSDate *_date;
    NSString *_dateString;
    NSString *_mdayString;
    NSString *_venue;
    JSGameStatus _status;
    JSGameTeam *_home;
    JSGameTeam *_away;
    NSURL *_placeholder;
    NSArray *_stages;
    NSString *_info;
    NSArray *_extras;
}

#pragma mark - Interface methods

- (instancetype)initWithEntity:(JSGameEntity *)entity placeholder:(NSURL *)placeholder {
    JSParameterAssert(entity);
    JSParameterAssert(placeholder);

    self = [super init];
    if (self) {
        _gameId = entity.gameId;
        _date = entity.date;
        _dateString = entity.dateString ?: entity.date.js_dateString;
        _mdayString = entity.mdayString;
        _venue = entity.venue;
        _status = [entity.status isEqualToString:@"1"] ? JSGameStatusPlayed : JSGameStatusNotPlayed;
        _home = [[JSGameTeam alloc] initWithEntity:entity.home skipScore:(_status == JSGameStatusNotPlayed)];
        _away = [[JSGameTeam alloc] initWithEntity:entity.away skipScore:(_status == JSGameStatusNotPlayed)];
        _placeholder = placeholder;
        _stages = entity.stages ? [NSKeyedUnarchiver unarchiveObjectWithData:(NSData * _Nonnull) entity.stages] : nil;
        _info = entity.info;
        _extras = entity.extrasInfo ? [NSKeyedUnarchiver unarchiveObjectWithData:(NSData * _Nonnull) entity.extrasInfo] : nil;
    }
    return self;
}

- (NSString *)gameId {
    return _gameId;
}

- (NSDate *)date {
    return _date;
}

- (NSString *)dateString {
    return _dateString;
}
    
- (NSString *)mdayString {
    return _mdayString;
}

- (NSString *)venue {
    return _venue;
}

- (JSGameStatus)status {
    return _status;
}

- (JSGameTeam *)home {
    return _home;
}

- (JSGameTeam *)away {
    return _away;
}

- (NSURL *)placeholder {
    return _placeholder;
}

- (NSArray *)stages {
    return _stages;
}

- (NSString *)info {
    return _info;
}

- (NSArray *)extras {
    return _extras;
}

@end
