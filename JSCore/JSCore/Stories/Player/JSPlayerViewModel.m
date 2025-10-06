// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;
@import JSCoreData;

#import "JSPlayerViewModel.h"
#import "JSPlayerRequest.h"
#import "JSPlayer.h"
#import "JSSeasonsRequest.h"
#import "JSSeasonEntity+CoreDataClass.h"
#import "JSTeamEntity+CoreDataClass.h"
#import "JSTeamPlayerEntity+CoreDataClass.h"
#import "JSStandingsRecordEntity+CoreDataClass.h"
#import "JSGameTeamEntity+CoreDataClass.h"
#import "JSStandingsGroupEntity+CoreDataClass.h"
#import "JSStandingsEntity+CoreDataClass.h"
#import "JSGameEntity+CoreDataClass.h"

@interface JSPlayerViewModel ()

@property (nonatomic, strong, readwrite) JSPlayer *player;

@end

@implementation JSPlayerViewModel {
    NSString *_playerId;
    NSURL *_placeholder;
}

#pragma mark - Private methods

- (void)initPlayer:(NSManagedObjectContext *)context {
    JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:self.seasonId];

    for (JSTeamEntity *team in season.teams) {
        for (JSTeamPlayerEntity *player in team.players) {
            if ([player.competitorId isEqualToString:_playerId]) {
                self.player = [[JSPlayer alloc] initWithCompetitorEntity:player placeholder:_placeholder];
                return;
            }
        }
    }

    if (season.isSinglePlayer) {
        for (JSTeamEntity *team in season.teams) {
            if ([team.competitorId isEqualToString:_playerId]) {
                self.player = [[JSPlayer alloc] initWithCompetitorEntity:team placeholder:_placeholder];
                return;
            }
        }

        for (JSStandingsGroupEntity *groupEntity in season.standings.groups) {
            for (JSStandingsRecordEntity *standingsRecordEntity in groupEntity.records) {
                if ([standingsRecordEntity.teamId isEqualToString:_playerId]) {
                    self.player = [[JSPlayer alloc] initWithStandingsRecordEntity:standingsRecordEntity placeholder:_placeholder];
                    return;
                }
            }
        }

        for (JSGameEntity *gameEntity in season.games) {
            if ([gameEntity.home.teamId isEqualToString:_playerId]) {
                self.player = [[JSPlayer alloc] initWithGameTeamEntity:gameEntity.home placeholder:_placeholder];
                return;
            }
            if ([gameEntity.away.teamId isEqualToString:_playerId]) {
                self.player = [[JSPlayer alloc] initWithGameTeamEntity:gameEntity.away placeholder:_placeholder];
                return;
            }
        }
    }

    self.player = nil;
}

#pragma mark - JSViewModel methods

- (void)initData:(NSManagedObjectContext *)context {
    if (!self.seasonId) {
        return;
    }

    if (!_playerId) {
        _playerId = [NSUserDefaults.standardUserDefaults stringForKey:JSSeasonsRequestDefaultTeamIdKey];
    }

    if (_playerId.length == 0) {
        return;
    }

    [self initPlayer:context];
}

- (void)update {
    if (!_playerId) {
        return;
    }

    [super update];
}

- (BOOL)skip:(JSRequest *)request {
    BOOL skip = [super skip:request];
    if (skip) {
        return skip;
    }

    JSParameterAssert([request isKindOfClass:JSPlayerRequest.class]);

    JSPlayerRequest *playerRequest = (JSPlayerRequest *) request;
    return ![playerRequest.playerId isEqualToString:_playerId];
}

- (JSRequest *)request:(JSCoreDataManager *)coreDataManager {
    return [[JSPlayerRequest alloc] initWithPlayerId:_playerId seasonId:self.seasonId coreDataManager:coreDataManager];
}

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient {
    self = [super initWithAPIClient:apiClient];
    if (self) {
        _placeholder =  ({
            NSString *placeholderPath = [self.base stringByAppendingPathComponent:@"media/bearleague/player_st.png"];
            [[NSURL alloc] initWithString:placeholderPath];
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setPlayerId:(NSString *)playerId {
    JSParameterAssert(playerId);

    if ([_playerId isEqualToString:playerId]) {
        return;
    }
    _playerId = playerId.copy;

    [self cancel];
    [self invalidate];
}

@end
