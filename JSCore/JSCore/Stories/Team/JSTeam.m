// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;

#import "JSTeam.h"
#import "JSPlayer.h"
#import "JSTeamEntity+CoreDataClass.h"
#import "JSTeamPlayerEntity+CoreDataClass.h"
#import "JSStandingsRecordEntity+CoreDataClass.h"
#import "JSGameTeamEntity+CoreDataClass.h"
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@implementation JSTeam {
    NSString *_teamId;
    NSString *_name;
    NSURL *_logoURL;
    NSURL *_teamPlaceholder;
    NSArray *_extras;
    NSString *_info;
    NSArray *_players;
}

#pragma mark - NSObject methods

- (NSUInteger)hash {
    return _teamId.hash;
}

- (BOOL)isEqual:(id)other {
    if (self == other) {
        return YES;
    }

    if (![[other class] isEqual:self.class]) {
        return NO;
    }

    return [_teamId isEqualToString:((JSTeam *)other).teamId];
}

#pragma mark - Interface methods

- (instancetype)initWithTeamEntity:(JSTeamEntity *)entity teamPlaceholder:(NSURL *)teamPlaceholder playerPlaceholder:(NSURL *)playerPlaceholder {
    JSParameterAssert(entity);
    JSParameterAssert(teamPlaceholder);
    JSParameterAssert(playerPlaceholder);

    self = [super init];
    if (self) {
        _teamId = entity.competitorId.copy;
        _name = entity.name.copy;
        _logoURL = [NSURL URLWithString:(NSString * _Nonnull) entity.logoURL];
        _info = entity.info.copy;
        _extras = entity.extrasInfo ? [NSKeyedUnarchiver unarchiveObjectWithData:(NSData * _Nonnull) entity.extrasInfo] : nil;
        _teamPlaceholder = teamPlaceholder;

        _players = [[entity.players.allObjects js_map:^JSPlayer *(JSTeamPlayerEntity *player) {
            return [[JSPlayer alloc] initWithCompetitorEntity:player placeholder:playerPlaceholder];
        }] sortedArrayUsingComparator:^NSComparisonResult(JSPlayer *player1, JSPlayer *player2) {
            return [player1.name compare:player2.name];
        }];
    }
    return self;
}

- (instancetype)initWithStandingsRecordEntity:(JSStandingsRecordEntity *)entity teamPlaceholder:(NSURL *)teamPlaceholder playerPlaceholder:(NSURL *)playerPlaceholder {
    JSParameterAssert(entity);
    JSParameterAssert(teamPlaceholder);
    JSParameterAssert(playerPlaceholder);

    self = [super init];
    if (self) {
        _teamId = entity.teamId.copy;
        _name = entity.teamName.copy;
        _logoURL = [NSURL URLWithString:(NSString * _Nonnull) entity.teamLogoURL];
        _teamPlaceholder = teamPlaceholder;
    }
    return self;
}

- (instancetype)initWithGameTeamEntity:(JSGameTeamEntity *)entity teamPlaceholder:(NSURL *)teamPlaceholder playerPlaceholder:(NSURL *)playerPlaceholder {
    JSParameterAssert(entity);
    JSParameterAssert(teamPlaceholder);
    JSParameterAssert(playerPlaceholder);

    self = [super init];
    if (self) {
        _teamId = entity.teamId.copy;
        _name = entity.name.copy;
        _logoURL = [NSURL URLWithString:(NSString * _Nonnull) entity.logoURL];
        _teamPlaceholder = teamPlaceholder;
    }
    return self;
}

- (NSString *)teamId {
    return _teamId;
}

- (NSString *)name {
    return _name;
}

- (NSURL *)logoURL {
    return _logoURL;
}

- (NSURL *)placeholder {
    return _teamPlaceholder;
}

- (NSArray *)extras {
    return _extras;
}

- (NSString *)info {
    return _info;
}

- (NSArray *)players {
    return _players;
}

@end
