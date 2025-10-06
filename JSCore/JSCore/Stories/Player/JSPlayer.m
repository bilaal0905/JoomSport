// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSPlayer.h"
#import "JSCompetitorEntity+CoreDataClass.h"
#import "JSStandingsRecordEntity+CoreDataClass.h"
#import "JSGameTeamEntity+CoreDataClass.h"
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@implementation JSPlayer {
    NSString *_playerId;
    NSString *_name;
    NSURL *_photoURL;
    NSURL *_placeholder;
    NSString *_info;
    NSArray *_extras;
    NSArray *_statistic;
}

#pragma mark - Interface methods

- (instancetype)initWithCompetitorEntity:(JSCompetitorEntity *)entity placeholder:(NSURL *)placeholder {
    JSParameterAssert(entity);
    JSParameterAssert(placeholder);

    self = [super init];
    if (self) {
        _playerId = entity.competitorId.copy;
        _name = entity.name.copy;
        _photoURL = [NSURL URLWithString:(NSString * _Nonnull) entity.logoURL];
        _placeholder = placeholder;
        _info = entity.info.copy;
        _extras = entity.extrasInfo ? [NSKeyedUnarchiver unarchiveObjectWithData:(NSData * _Nonnull) entity.extrasInfo] : nil;
        _statistic = entity.statisticInfo ? [NSKeyedUnarchiver unarchiveObjectWithData:(NSData * _Nonnull) entity.statisticInfo] : nil;
    }
    return self;
}
- (instancetype)initWithStandingsRecordEntity:(JSStandingsRecordEntity *)entity placeholder:(NSURL *)placeholder {
    JSParameterAssert(entity);
    JSParameterAssert(placeholder);

    self = [super init];
    if (self) {
        _playerId = entity.teamId.copy;
        _name = entity.teamName.copy;
        _photoURL = [NSURL URLWithString:(NSString * _Nonnull) entity.teamLogoURL];
        _placeholder = placeholder;
    }
    return self;
}

- (instancetype)initWithGameTeamEntity:(JSGameTeamEntity *)entity placeholder:(NSURL *)placeholder {
    JSParameterAssert(entity);
    JSParameterAssert(placeholder);

    self = [super init];
    if (self) {
        _playerId = entity.teamId.copy;
        _name = entity.name.copy;
        _photoURL = [NSURL URLWithString:(NSString * _Nonnull) entity.logoURL];
        _placeholder = placeholder;
    }
    return self;
}

- (NSString *)playerId {
    return _playerId;
}

- (NSString *)name {
    return _name;
}

- (NSURL *)photoURL {
    return _photoURL;
}

- (NSURL *)placeholder {
    return _placeholder;
}

- (NSArray *)extras {
    return _extras;
}

- (NSArray *)statistic {
    return _statistic;
}

- (NSString *)info {
    return _info;
}

@end
