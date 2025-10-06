// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;

#import "JSTeamRequest.h"
#import "JSExtraInfo.h"
#import "JSSeasonEntity+CoreDataClass.h"
#import "JSTeamEntity+CoreDataClass.h"
#import "JSTeamPlayerEntity+CoreDataClass.h"
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@implementation JSTeamRequest {
    NSString *_teamId;
}

#pragma mark - Private methods

- (JSTeamEntity *)team:(NSManagedObjectContext *)context {

    JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:self.seasonId];

    for (JSTeamEntity *entity in season.teams) {
        if ([entity.competitorId isEqualToString:_teamId]) {
            return entity;
        }
    }

    JSTeamEntity *team = [JSTeamEntity js_new:season.managedObjectContext];
    [season addTeamsObject:team];

    return team;
}

- (void)map:(NSDictionary *)playersJSON to:(JSTeamEntity *)team {

    if (playersJSON && ![playersJSON isKindOfClass:NSDictionary.class]) {
        playersJSON = @{};
    }

    NSMutableSet *processedIds = [[NSMutableSet alloc] init];

    for (JSTeamPlayerEntity *player in team.players.copy) {
        NSDictionary *playerJSON = playersJSON[(NSString * _Nonnull) player.competitorId][@"partcolumn"];

        if (playerJSON) {
            [processedIds addObject:(NSString * _Nonnull) player.competitorId];

            player.name = playerJSON[@"playername"];
            player.logoURL = playerJSON[@"emblem"];
        }
        else {
            [team removePlayersObject:player];
            [team.managedObjectContext deleteObject:player];
        }
    }

    for (NSString *playerId in playersJSON.allKeys) {
        if ([processedIds containsObject:playerId]) {
            continue;
        }

        NSDictionary *playerJSON = playersJSON[playerId][@"partcolumn"];

        [team addPlayersObject:({
            JSTeamPlayerEntity *player = [JSTeamPlayerEntity js_new:team.managedObjectContext];
            player.competitorId = playerId;
            player.name = playerJSON[@"playername"];
            player.logoURL = playerJSON[@"emblem"];
            player;
        })];
    }
}

#pragma mark - JSRequest methods

- (void)map:(NSDictionary *)json from:(NSData *)data in:(NSManagedObjectContext *)context {
    [super map:json from:data in:context];

    JSTeamEntity *team = [self team:context];

    team.competitorId = json[@"teamid"];
    team.name = json[@"tname"];
    team.logoURL = json[@"emblem"];
    team.info = [json[@"tdescription"] js_string];

    NSArray *extras = [[json[@"teamextras"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary *extra, NSDictionary *bindings) {
        return [extra[@"extravalue"] js_string].length > 0;
    }]] js_map:^JSExtraInfo *(NSDictionary *extra) {
        NSString *extraValue = [extra[@"extravalue"] js_string];
        if ([extraValue hasPrefix:@"<"]) {
            @try {
                extraValue = [extraValue js_substring:@">.*</a>"];
                extraValue = [extraValue substringWithRange:NSMakeRange(1, extraValue.length - 5)];
            }
            @catch(NSException *e) {
                JSLogError(@"Exception while parsing a tag\n\texception: %@\n\ta: %@", e, extraValue);
            }
        }
        return [[JSExtraInfo alloc] initWithName:extra[@"extraname"] value:extraValue type:nil];
    }];

    team.extrasInfo = extras.count ? [NSKeyedArchiver archivedDataWithRootObject:extras] : nil;

    [self map:json[@"players"] to:team];
}

#pragma mark - Interface methods

- (instancetype)initWithTeamId:(NSString *)teamId seasonId:(NSString *)seasonId coreDataManager:(JSCoreDataManager *)coreDataManager {
    JSParameterAssert(teamId);

    self = [super initWithPath:@"index.php" seasonId:seasonId coreDataManager:coreDataManager extraParams:@{@"option": @"com_joomsport", @"task": @"team",@"sid": seasonId,@"tid":teamId}];
    if (self) {
        _teamId = teamId;
    }
    return self;
}

- (NSString *)teamId {
    return _teamId;
}

@end
