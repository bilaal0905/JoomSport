// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;

#import "JSStandingsRequest.h"
#import "JSSeasonEntity+CoreDataClass.h"
#import "JSStandingsEntity+CoreDataClass.h"
#import "JSStandingsGroupEntity+CoreDataClass.h"
#import "JSStandingsRecordEntity+CoreDataClass.h"
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@implementation JSStandingsRequest

#pragma mark - Private methods

+ (NSArray *)parse:(NSData *)keysData {

    NSString *json = [[NSString alloc] initWithData:keysData encoding:NSUTF8StringEncoding];
    json = [json js_substring:@"\"tfields\"[^{]*\\{[^}]+\\}"];
    json = [json js_substring:@"\\{[^}]*\\}"];
    json = [json substringWithRange:NSMakeRange(1, json.length - 2)];

    JSOnceSet(NSSet *, skip, ([[NSSet alloc] initWithObjects:@"rank", @"particname", @"emblem_chk", nil]));

    NSArray *keys = [[[json componentsSeparatedByString:@","] js_map:^NSString *(NSString *str) {
        NSString *s = [[str componentsSeparatedByString:@":"].firstObject stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        s = [s substringWithRange:NSMakeRange(1, s.length - 2)];
        return s;
    }] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *key, NSDictionary *bindings) {
        return ![skip containsObject:key];
    }]];

    return keys;
}

+ (void)parse:(NSDictionary *)fields with:(NSArray *)keys to:(JSStandingsEntity *)standings {

    standings.fieldsKeys = [NSKeyedArchiver archivedDataWithRootObject:keys];
    standings.fields = [NSKeyedArchiver archivedDataWithRootObject:[keys js_map:^NSString *(NSString *key) {
        return fields[key];
    }]];
}

+ (void)parseGroup:(NSDictionary *)groupJSON with:(NSArray *)keys to:(JSStandingsEntity *)standings {

    JSStandingsGroupEntity *group = [JSStandingsGroupEntity js_new:standings.managedObjectContext];
    group.name = [groupJSON[@"groupname"] js_string];

    NSArray *participants = groupJSON[@"participants"];
    for (NSDictionary *json in participants) {
        [self parseRecord:json with:keys to:group];
    }

    [standings addGroupsObject:group];
}

+ (void)parseRecord:(NSDictionary *)recordJSON with:(NSArray *)keys to:(JSStandingsGroupEntity *)group {
    NSString *teamId = recordJSON[@"particid"];
    recordJSON = recordJSON[@"partcolumns"];

    JSStandingsRecordEntity *record = [JSStandingsRecordEntity js_new:group.managedObjectContext];
    record.rank = [recordJSON[@"rank"] integerValue];
    record.teamId = teamId;
    record.teamName = recordJSON[@"particname"];
    record.teamLogoURL = recordJSON[@"emblem"];

    NSArray *valuesStrings = [keys js_map:^NSString *(NSString *key) {
        return [recordJSON[key] js_string];
    }];
    record.valuesStrings = [NSKeyedArchiver archivedDataWithRootObject:valuesStrings];

    NSArray *values = [valuesStrings js_map:^id(NSString *value) {
        NSNumber *number = value.js_number;
        if (!number) {
            NSArray *parts = [value componentsSeparatedByString:@" - "];
            if (parts.count == 2) {
                NSNumber *n1 = [parts.firstObject js_number];
                NSNumber *n2 = [parts.lastObject js_number];
                if (n1 && n2) {
                    number = @(n1.doubleValue - n2.doubleValue);
                }
            }
        }
        return number ?: [NSNull null];
    }];
    record.values = [NSKeyedArchiver archivedDataWithRootObject:values];

    [group addRecordsObject:record];
}

#pragma mark - JSRequest methods

- (void)map:(NSDictionary *)json from:(NSData *)data in:(NSManagedObjectContext *)context {
    [super map:json from:data in:context];

    JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:self.seasonId];

    JSStandingsEntity *standings = season.standings ?: ({
        JSStandingsEntity *entity = [JSStandingsEntity js_new:context];
        season.standings = entity;
        entity;
    });

    for (JSStandingsGroupEntity *group in standings.groups.copy) {
        [standings removeGroups:(NSSet * _Nonnull) standings.groups];
        [context deleteObject:group];
    }

    NSDictionary *fieldsJSON = json[@"tfields"];
    NSArray *groupsJSON = json[@"seasongroups"];

    if (fieldsJSON.count > 0 && groupsJSON.count > 0) {

        NSArray *keys = [self.class parse:data];
        [self.class parse:json[@"tfields"] with:keys to:standings];

        for (NSDictionary *group in groupsJSON) {
            [self.class parseGroup:group with:keys to:standings];
        }
    }
    else {
        standings.fields = nil;
        standings.fieldsKeys = nil;
    }
}

#pragma mark - Interface methods

- (instancetype)initWithSeasonId:(NSString *)seasonId coreDataManager:(JSCoreDataManager *)coreDataManager {
    JSParameterAssert(seasonId);
    
    return [self initWithPath:@"index.php" seasonId:seasonId coreDataManager:coreDataManager extraParams:@{@"option": @"com_joomsport", @"task": @"table",@"sid": seasonId}];

}

@end
