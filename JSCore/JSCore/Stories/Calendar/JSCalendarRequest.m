// Created for BearDev by drif
// drif@mail.ru

@import JSCoreData;
@import JSUtils;

#import "JSCalendarRequest.h"
#import "NSString+JSCore.h"
#import "JSSeasonEntity+CoreDataClass.h"
#import "JSGameEntity+CoreDataClass.h"
#import "JSGameTeamEntity+CoreDataClass.h"

@implementation JSCalendarRequest

#pragma mark - Private methods

+ (NSArray *)map:(NSDictionary *)json {
    return [json.allKeys js_map:^NSDictionary *(NSString *key) {
        NSMutableDictionary *game = [json[key] mutableCopy];
        game[@"id"] = key;
        return game;
    }];
}

+ (void)merge:(NSArray *)games to:(JSSeasonEntity *)season {

    NSMutableSet *ids = [[NSMutableSet alloc] init];
    for (NSDictionary *game in games) {
        NSString *gameId = game[@"id"];
        [ids addObject:gameId];

        JSGameEntity *entity = [JSGameEntity js_object:season.managedObjectContext where:@"gameId" equals:gameId];
        entity.date = [game[@"mdateCustom"] js_date24];
        entity.dateString = game[@"mdateCustom"];
        entity.mdayString = game[@"mdayname"];
        NSObject *status = game[@"mstatus"];
        if (![status isKindOfClass:[NSString class]]) {
            status = ((NSNumber *)status).stringValue;
        }
        entity.status = (NSString *)status;
        entity.home = [self team:game[@"home"] in:entity.managedObjectContext];
        entity.away = [self team:game[@"away"] in:entity.managedObjectContext];

        if (![entity.season.seasonId isEqualToString:(NSString * _Nonnull) season.seasonId]) {
            [entity.season removeGamesObject:entity];
        }

        if (!entity.season) {
            [season addGamesObject:entity];
        }
    }

    for (JSGameEntity *game in season.games.copy) {
        if (![ids containsObject:(NSString * _Nonnull) game.gameId]) {
            [season removeGamesObject:game];
        }
    }
}

+ (JSGameTeamEntity *)team:(NSDictionary *)json in:(NSManagedObjectContext *)context {
    JSGameTeamEntity *team = [JSGameTeamEntity js_new:context];
    team.name = json[@"teamname"];
    team.score = json[@"score"];
    team.logoURL = json[@"teamlogo"];
    team.teamId = json[@"teamid"];
    return team;
}

+ (void)cleanup:(NSManagedObjectContext *)context {

    NSArray *games = [JSGameEntity js_all:context];
    for (JSGameEntity *game in games) {
        if (!game.season) {
            [context deleteObject:game];
        }
    }

    NSArray *teams = [JSGameTeamEntity js_all:context];
    for (JSGameTeamEntity *team in teams) {
        if (!team.homeGame && !team.awayGame) {
            [context deleteObject:team];
        }
    }
}

#pragma mark - JSRequest methods

- (void)map:(NSDictionary *)json from:(NSData *)data in:(NSManagedObjectContext *)context {
    [super map:json from:data in:context];

    JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:self.seasonId];

    NSArray *games = [self.class map:json[@"matches"]];
    [self.class merge:games to:season];
    [self.class cleanup:context];
}

#pragma mark - Interface methods

- (instancetype)initWithSeasonId:(NSString *)seasonId coreDataManager:(JSCoreDataManager *)coreDataManager {
    JSParameterAssert(seasonId);
    return [self initWithPath:@"index.php" seasonId:seasonId coreDataManager:coreDataManager extraParams:@{@"option": @"com_joomsport", @"task": @"calendar",@"sid": seasonId}];
}

@end
