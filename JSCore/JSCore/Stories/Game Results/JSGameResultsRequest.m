// Created for BearDev by drif
// drif@mail.ru

@import JSCoreData;
@import JSUtils;

#import "JSGameResultsRequest.h"
#import "JSExtraInfo.h"
#import "NSString+JSCore.h"
#import "JSGameEntity+CoreDataClass.h"
#import "JSSeasonEntity+CoreDataClass.h"
#import "JSGameTeamEntity+CoreDataClass.h"
#import "JSGameEventEntity+CoreDataClass.h"
#import "JSGameStatisticEntity+CoreDataClass.h"
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@implementation JSGameResultsRequest {
    NSString *_gameId;
    NSString *_seasonId;
}

#pragma mark - Private methods

+ (void)reset:(JSGameEntity *)game {
    NSSet *events = game.events.copy;
    [game removeEvents:events];

    for (JSGameEventEntity *event in events) {
        [game.managedObjectContext deleteObject:event];
    }

    NSSet *statistics = game.statistics.copy;
    [game removeStatistics:statistics];

    for (JSGameStatisticEntity *statistic in statistics) {
        [game.managedObjectContext deleteObject:statistic];
    }
}

+ (void)map:(NSArray *)stages to:(JSGameEntity *)game {
    if (!stages.count) {
        game.stages = nil;
        return;
    }

    NSArray *array = [[stages js_map:^NSString *(NSDictionary *stage) {
        NSString *home = [stage[@"homescore"] js_string];
        NSString *away = [stage[@"awayscore"] js_string];
        if (home.length && away.length) {
            return [NSString stringWithFormat:@"%@ - %@", stage[@"homescore"], stage[@"awayscore"]];
        }
        else {
            return @"";
        }
    }] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.length > 0;
    }]];
    game.stages = [NSKeyedArchiver archivedDataWithRootObject:array];
}

+ (void)map:(NSArray *)events to:(JSGameEntity *)game home:(BOOL)home {
    for (NSDictionary *json in events) {
        [game addEventsObject:({
            JSGameEventEntity *event = [JSGameEventEntity js_new:game.managedObjectContext];

            event.playerName = json[@"playername"];
            event.minute = [json[@"eventminute"] integerValue];
            event.isHome = home;
            event.iconURL = json[@"eventimg"];

            event;
        })];
    }
}

+ (void)mapStatistics:(NSDictionary *)json to:(JSGameEntity *)game {
    if (!json.count) {
        return;
    }

    NSArray *statistics = [[json.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] js_map:^NSDictionary *(NSString *key) {
        NSMutableDictionary *dict = [json[key] mutableCopy];
        dict[@"id"] = key;
        return dict.copy;
    }];
    
    for (NSDictionary *statistic in statistics) {
        [game addStatisticsObject:({
            JSGameStatisticEntity *entity = [JSGameStatisticEntity js_new:game.managedObjectContext];

            entity.statisticId = [statistic[@"id"] integerValue];
            entity.title = statistic[@"eventname"];
            entity.home = [statistic[@"home"] integerValue];
            entity.away = [statistic[@"away"] integerValue];

            entity;
        })];
    }
}

+ (JSGameTeamEntity *)team:(NSDictionary *)json in:(NSManagedObjectContext *)context {
    JSGameTeamEntity *team = [JSGameTeamEntity js_new:context];
    team.name = json[@"particname"];
    team.score = json[@"score"];
    team.logoURL = json[@"emblem"];
    team.teamId = json[@"particid"];
    return team;
}

#pragma mark - JSRequest methods

- (void)map:(NSDictionary *)json from:(NSData *)data in:(NSManagedObjectContext *)context {
    [super map:json from:data in:context];

    JSGameEntity *game = [JSGameEntity js_object:context where:@"gameId" equals:_gameId];

    if (!game.season) {
        JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:_seasonId];
        [season addGamesObject:game];
    }

    game.venue = [json[@"venue"] js_string];
    game.info = [json[@"matchdescription"] js_string];
    game.date = game.date ?: [json[@"mdate"] js_date];
    NSObject *status = json[@"mstatus"];
    if (![status isKindOfClass:[NSString class]]) {
        status = ((NSNumber *)status).stringValue;
    }
    game.status = (NSString *)status;
    game.home = game.home ?: [self.class team:json[@"home"] in:context];
    game.away = game.away ?: [self.class team:json[@"away"] in:context];

    NSArray *extras = [[json[@"matchextras"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary *extra, NSDictionary *bindings) {
        return [extra[@"extravalue"] js_string].length > 0;
    }]] js_map:^JSExtraInfo *(NSDictionary *extra) {
        return [[JSExtraInfo alloc] initWithName:extra[@"extraname"] value:[extra[@"extravalue"] js_string] type:nil];
    }];

    game.extrasInfo = extras.count ? [NSKeyedArchiver archivedDataWithRootObject:extras] : nil;

    [self.class reset:game];
    [self.class map:json[@"stages_array"] to:game];
    [self.class map:json[@"home"][@"playerevents"] to:game home:YES];
    [self.class map:json[@"away"][@"playerevents"] to:game home:NO];
    [self.class mapStatistics:json[@"teamevents"] to:game];
}

#pragma mark - Interface methods

- (instancetype)initWithGameId:(NSString *)gameId of:(NSString *)seasonId coreDataManager:(JSCoreDataManager *)coreDataManager {
    JSParameterAssert(gameId);

    self = [super initWithPath:@"index.php" coreDataManager:coreDataManager extraParams:@{@"option": @"com_joomsport",@"task": @"match", @"id": gameId}];
    if (self) {
        _gameId = gameId.copy;
        _seasonId = seasonId.copy;
    }
    return self;
}

@end
