// Created for BearDev by drif
// drif@mail.ru

@import JSCoreData;
@import JSUtils.JSLog;

#import "JSTeamViewModel.h"
#import "JSTeam.h"
#import "JSTeamRequest.h"
#import "JSSeasonsRequest.h"
#import "JSSeasonEntity+CoreDataClass.h"
#import "JSGameTeamEntity+CoreDataClass.h"
#import "JSGameEntity+CoreDataClass.h"
#import "JSTeamEntity+CoreDataClass.h"
#import "JSStandingsRecordEntity+CoreDataClass.h"
#import "JSStandingsGroupEntity+CoreDataClass.h"
#import "JSStandingsEntity+CoreDataClass.h"

@interface JSTeamViewModel ()

@property (nonatomic, strong, readwrite) JSTeam *team;
@property (nonatomic, strong, readwrite) NSArray *teams;

@end

@implementation JSTeamViewModel {
    NSString *_teamId;
    NSURL *_teamPlaceholder;
    NSURL *_playerPlaceholder;
    BOOL _isSinglePlayer;
}

#pragma mark - Private methods

- (void)initTeams:(NSManagedObjectContext *)context {
    JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:self.seasonId];

    _isSinglePlayer = season.isSinglePlayer;

    NSMutableSet *teams = [[NSMutableSet alloc] init];

    for (JSStandingsGroupEntity *groupEntity in season.standings.groups) {
        for (JSStandingsRecordEntity *standingsRecordEntity in groupEntity.records) {
            [teams addObject:[[JSTeam alloc] initWithStandingsRecordEntity:standingsRecordEntity teamPlaceholder:_teamPlaceholder playerPlaceholder:_playerPlaceholder]];
        }
    }

    for (JSGameEntity *gameEntity in season.games) {
        [teams addObject:[[JSTeam alloc] initWithGameTeamEntity:gameEntity.home teamPlaceholder:_teamPlaceholder playerPlaceholder:_playerPlaceholder]];
        [teams addObject:[[JSTeam alloc] initWithGameTeamEntity:gameEntity.away teamPlaceholder:_teamPlaceholder playerPlaceholder:_playerPlaceholder]];
    }
    
    self.teams = [teams.allObjects sortedArrayUsingComparator:^NSComparisonResult(JSTeam *team1, JSTeam *team2) {
        return [team1.name compare:team2.name];
    }];
    
}

- (void)initTeam:(NSManagedObjectContext *)context {
    JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:self.seasonId];

    for (JSTeamEntity *teamEntity in season.teams) {
        if ([teamEntity.competitorId isEqualToString:_teamId]) {
            self.team = [[JSTeam alloc] initWithTeamEntity:teamEntity teamPlaceholder:_teamPlaceholder playerPlaceholder:_playerPlaceholder];
            return;
        }
    }

    for (JSTeam *team in self.teams) {
        if ([team.teamId isEqualToString:_teamId]) {
            self.team = team;
            return;
        }
    }
//    if (self.team == nil && _teams.count > 0) {
//        self.team = self.teams[0];
//    }
    self.team = nil;
}

#pragma mark - JSViewModel methods

- (void)initData:(NSManagedObjectContext *)context {
    if (!self.seasonId) {
        return;
    }
    
    [self initTeams:context];

    if (!_teamId) {
        _teamId = [NSUserDefaults.standardUserDefaults stringForKey:JSSeasonsRequestDefaultTeamIdKey];
    }
    if ([_teamId  isEqual: @"0"] && _teams.count > 0) {
        _teamId = [self.teams[0] teamId];
        [NSUserDefaults.standardUserDefaults setObject:_teamId forKey:JSSeasonsRequestDefaultTeamIdKey];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
    if (_teamId.length == 0) {
        return;
    }
    
    [self initTeam:context];
}

- (void) update {
//    if (!_teamId) {
//        return;
//    }

    [super update];
}

- (BOOL)skip:(JSRequest *)request {
    BOOL skip = [super skip:request];
    if (skip) {
        return skip;
    }

    JSParameterAssert([request isKindOfClass:JSTeamRequest.class]);

    JSTeamRequest *teamRequest = (JSTeamRequest *) request;
    return ![teamRequest.teamId isEqualToString:_teamId];
}

- (JSRequest *)request:(JSCoreDataManager *)coreDataManager {
    return [[JSTeamRequest alloc] initWithTeamId:_teamId seasonId:self.seasonId coreDataManager:coreDataManager];
}

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient {
    self = [super initWithAPIClient:apiClient];
    if (self) {
        _teamPlaceholder =  ({
            NSString *placeholderPath = [self.base stringByAppendingPathComponent:@"media/bearleague/teams_st.png"];
            [[NSURL alloc] initWithString:placeholderPath];
        });
        _playerPlaceholder =  ({
            NSString *placeholderPath = [self.base stringByAppendingPathComponent:@"media/bearleague/player_st.png"];
            [[NSURL alloc] initWithString:placeholderPath];
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setTeamId:(NSString *)teamId {
    JSParameterAssert(teamId);

    if ([_teamId isEqualToString:teamId]) {
        return;
    }
    _teamId = teamId.copy;
    //Save selected teamId in NSUserDefaults added by bilal
    [NSUserDefaults.standardUserDefaults setObject:_teamId forKey:JSSeasonsRequestDefaultTeamIdKey];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self cancel];
    [self invalidate];
}

@end
