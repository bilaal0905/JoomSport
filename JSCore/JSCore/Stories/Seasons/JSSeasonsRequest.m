// Created for BearDev by drif
// drif@mail.ru

@import JSCoreData;
@import JSUtils;

#import "JSSeasonsRequest.h"
#import "JSSeasonEntity+CoreDataClass.h"
#import "JSTournamentEntity+CoreDataClass.h"

NSString *const JSSeasonsRequestDefaultSeasonIdKey = @"JSSeasonsRequestDefaultSeasonIdKey";
NSString *const JSSeasonsRequestDefaultTeamIdKey = @"JSSeasonsRequestDefaultTeamIdKey";

@implementation JSSeasonsRequest

#pragma mark - Private methods

+ (NSDictionary *)map:(NSDictionary *)json {
    NSDictionary *seasonsJSON = json[@"season"];
    NSMutableDictionary *tournamentsJSON = [[NSMutableDictionary alloc] init];

    for (NSString *seasonId in seasonsJSON.allKeys) {
        NSDictionary *seasonJSON = seasonsJSON[seasonId];
        NSString *tournamentId = seasonJSON[@"tourn_id"];

        NSDictionary *tournamentJSON = tournamentsJSON[tournamentId];
        if (!tournamentJSON) {
            tournamentJSON = @{
                    @"name": seasonJSON[@"tourn_name"] ?: @"",
                    @"seasons": [[NSMutableArray alloc] init]
            };
            tournamentsJSON[tournamentId] = tournamentJSON;
        }

        [tournamentsJSON[tournamentId][@"seasons"] addObject:@{
                @"id": seasonId,
                @"name": seasonJSON[@"season_name"] ?: @"",
                @"single": seasonJSON[@"tsingle"] ?: @"0"
        }];
    }

    return tournamentsJSON.copy;
}

+ (void)merge:(NSDictionary *)json with:(NSString *)tournamentId in:(NSManagedObjectContext *)context {
    JSTournamentEntity *tournament = [JSTournamentEntity js_object:context where:@"tournamentId" equals:tournamentId];
    tournament.name = json[@"name"];

    NSMutableSet *ids = [[NSMutableSet alloc] init];
    for (NSDictionary *seasonJSON in json[@"seasons"]) {
        NSString *seasonId = seasonJSON[@"id"];
        [ids addObject:seasonId];

        JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:seasonId];
        season.name = seasonJSON[@"name"];
        season.isSinglePlayer = [[seasonJSON[@"single"] js_string] isEqualToString:@"1"];

        if (![season.tournament.tournamentId isEqualToString:tournamentId]) {
            [season.tournament removeSeasonsObject:season];
        }

        if (!season.tournament) {
            [tournament addSeasonsObject:season];
        }
    }

    for (JSSeasonEntity *season in tournament.seasons.copy) {
        if (![ids containsObject:(NSString * _Nonnull) season.seasonId]) {
            [tournament removeSeasonsObject:season];
        }
    }
}

+ (void)merge:(NSSet *)ids in:(NSManagedObjectContext *)context {
    NSArray *tournaments = [JSTournamentEntity js_all:context];
    for (JSTournamentEntity *tournament in tournaments) {
        if (![ids containsObject:(NSString * _Nonnull) tournament.tournamentId]) {
            [context deleteObject:tournament];
        }
    }
}

+ (void)cleanup:(NSManagedObjectContext *)context {
    NSArray *seasons = [JSSeasonEntity js_all:context];
    for (JSSeasonEntity *season in seasons) {
        if (!season.tournament) {
            [context deleteObject:season];
        }
    }
}

#pragma mark - JSRequest methods

- (void)map:(NSDictionary *)json from:(NSData *)data in:(NSManagedObjectContext *)context {
    [super map:json from:data in:context];

    {
        [NSUserDefaults.standardUserDefaults setObject:[json[@"defoptions"][@"season"] js_string] forKey:JSSeasonsRequestDefaultSeasonIdKey];
        [NSUserDefaults.standardUserDefaults setObject:[json[@"defoptions"][@"team"] js_string] forKey:JSSeasonsRequestDefaultTeamIdKey];

        [NSUserDefaults.standardUserDefaults synchronize];
    }

    NSDictionary *tournaments = [self.class map:json];
    NSMutableSet *ids = [[NSMutableSet alloc] init];

    for (NSString *tournamentId in tournaments.allKeys) {
        [self.class merge:tournaments[tournamentId] with:tournamentId in:context];
        [ids addObject:tournamentId];
    }
    [self.class merge:ids in:context];
    [self.class cleanup:context];
}

#pragma mark - Interface methods

- (instancetype)initWithCoreDataManager:(JSCoreDataManager *)coreDataManager {
    return [self initWithPath:@"index.php" coreDataManager:coreDataManager extraParams:@{@"option": @"com_joomsport", @"task": @"seasonlist"}];
}

@end
