// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSGameEvent.h"
#import "JSGameEventEntity+CoreDataClass.h"

@implementation JSGameEvent {
    BOOL _isHome;
    NSString *_playerName;
    NSNumber *_minute;
    NSURL *_iconURL;
}

#pragma mark - Interface methods

- (instancetype)initWithEntity:(JSGameEventEntity *)entity {
    JSParameterAssert(entity);

    self = [super init];
    if (self) {
        _isHome = entity.isHome;
        _playerName = entity.playerName;
        _minute = @(entity.minute);
        _iconURL = [NSURL URLWithString:(NSString * _Nonnull) entity.iconURL];
    }
    return self;
}

- (BOOL)isHome {
    return _isHome;
}

- (NSString *)playerName {
    return _playerName;
}

- (NSNumber *)minute {
    return _minute;
}

- (NSURL *)iconURL {
    return _iconURL;
}

@end
