// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;

#import "JSTournament.h"
#import "JSSeason.h"
#import "JSTournamentEntity+CoreDataClass.h"
#import "JSSeasonEntity+CoreDataClass.h"

@implementation JSTournament {
    NSString *_tournamentId;
    NSString *_name;
    NSArray *_seasons;
}

#pragma mark - Interface methods

- (instancetype)initWithEntity:(JSTournamentEntity *)entity {
    JSParameterAssert(entity);

    self = [super init];
    if (self) {
        _tournamentId = entity.tournamentId.copy;
        _name = entity.name.copy;
        _seasons = [[entity.seasons.allObjects js_map:^JSSeason *(JSSeasonEntity *seasonEntity) {
            return [[JSSeason alloc] initWithEntity:seasonEntity];
        }] sortedArrayUsingComparator:^NSComparisonResult(JSSeason *season1, JSSeason *season2) {
            return [season2.name compare:season1.name];
        }];
    }
    return self;
}

- (NSArray *)seasons {
    return _seasons;
}

- (NSString *)tournamentId {
    return _tournamentId;
}

- (NSString *)name {
    return _name;
}

@end
