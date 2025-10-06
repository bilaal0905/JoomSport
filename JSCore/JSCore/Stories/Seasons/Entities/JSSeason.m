// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSSeason.h"
#import "JSSeasonEntity+CoreDataClass.h"
#import "JSTournamentEntity+CoreDataClass.h"

static NSString *const JSSeasonKeyId = @"JSSeasonKeyId";
static NSString *const JSSeasonKeyName = @"JSSeasonKeyName";
static NSString *const JSSeasonKeyFullName = @"JSSeasonKeyFullName";
static NSString *const JSSeasonKeySinglePlayer = @"JSSeasonKeySinglePlayer";

@implementation JSSeason {
    NSString *_seasonId;
    NSString *_name;
    NSString *_fullName;
    BOOL _isSinglePlayer;
}

#pragma mark - NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_seasonId forKey:JSSeasonKeyId];
    [coder encodeObject:_name forKey:JSSeasonKeyName];
    [coder encodeObject:_fullName forKey:JSSeasonKeyFullName];
    [coder encodeBool:_isSinglePlayer forKey:JSSeasonKeySinglePlayer];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _seasonId = [coder decodeObjectForKey:JSSeasonKeyId];
        _name = [coder decodeObjectForKey:JSSeasonKeyName];
        _fullName = [coder decodeObjectForKey:JSSeasonKeyFullName];
        _isSinglePlayer = [coder decodeBoolForKey:JSSeasonKeySinglePlayer];
    }
    return self;
}

#pragma mark - Interface methods

- (instancetype)initWithEntity:(JSSeasonEntity *)entity {
    JSParameterAssert(entity);

    self = [super init];
    if (self) {
        _seasonId = entity.seasonId.copy;
        _name = entity.name.copy;
        _fullName = [entity.tournament.name stringByAppendingFormat:@" %@", entity.name];
        _isSinglePlayer = entity.isSinglePlayer;
    }
    return self;
}

- (NSString *)seasonId {
    return _seasonId;
}

- (NSString *)name {
    return _name;
}

- (NSString *)fullName {
    return _fullName;
}

- (BOOL)isSinglePlayer {
    return _isSinglePlayer;
}

@end
