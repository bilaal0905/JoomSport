// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;

#import "JSPlayerRequest.h"
#import "JSExtraInfo.h"
#import "JSSeasonEntity+CoreDataClass.h"
#import "JSTeamEntity+CoreDataClass.h"
#import "JSTeamPlayerEntity+CoreDataClass.h"
#import "JSCompetitorEntity+CoreDataClass.h"
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@implementation JSPlayerRequest {
    NSString *_playerId;
}

#pragma mark - Private methods

- (JSCompetitorEntity *)player:(NSManagedObjectContext *)context {
    JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:self.seasonId];

    for (JSTeamEntity *team in season.teams) {
        for (JSTeamPlayerEntity *player in team.players) {
            if ([player.competitorId isEqualToString:_playerId]) {
                return player;
            }
        }
    }

    if (season.isSinglePlayer) {
        for (JSTeamEntity *team in season.teams) {
            if ([team.competitorId isEqualToString:_playerId]) {
                return team;
            }
        }

        JSTeamEntity *team = [JSTeamEntity js_new:context];
        team.competitorId = _playerId;
        [season addTeamsObject:team];
        return team;
    }

    JSParameterAssert(nil);
    return nil;
}

#pragma mark - JSRequest methods

- (void)map:(NSDictionary *)json from:(NSData *)data in:(NSManagedObjectContext *)context {
    [super map:json from:data in:context];

    JSCompetitorEntity *player = [self player:context];
    player.name = json[@"pname"];
    player.logoURL = json[@"defimg"];
    player.info = json[@"pdescription"];

    NSArray *extras = [[json[@"playerextras"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary *extra, NSDictionary *bindings) {
        return [extra[@"extravalue"] js_string].length > 0;
    }]] js_map:^JSExtraInfo *(NSDictionary *extra) {
        return [[JSExtraInfo alloc] initWithName:extra[@"extraname"] value:[extra[@"extravalue"] js_string] type:extra[@"extratype"]];
    }];

    player.extrasInfo = extras.count ? [NSKeyedArchiver archivedDataWithRootObject:extras] : nil;

    NSArray *statistic = [[json[@"playerstats"] allValues] js_map:^JSExtraInfo *(NSDictionary *value) {
        return [[JSExtraInfo alloc] initWithName:value[@"name"] value:[value[@"value"] js_string] image:[value[@"img"] js_string]];
    }];

    player.statisticInfo = statistic.count ? [NSKeyedArchiver archivedDataWithRootObject:statistic] : nil;
}

#pragma mark - Interface methods

- (instancetype)initWithPlayerId:(NSString *)playerId seasonId:(NSString *)seasonId coreDataManager:(JSCoreDataManager *)coreDataManager {
    JSParameterAssert(playerId);

    self = [super initWithPath:[NSString stringWithFormat:@"component/joomsport/player/%@/%@", seasonId, playerId] seasonId:seasonId coreDataManager:coreDataManager];
    if (self) {
        _playerId = playerId;
    }
    return self;
}

- (NSString *)playerId {
    return _playerId;
}

@end
