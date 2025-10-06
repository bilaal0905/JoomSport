// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;

#import "JSSeasonsViewModel.h"
#import "JSSeasonsRequest.h"
#import "JSTournament.h"
#import "JSSeason.h"
#import "JSTournamentEntity+CoreDataClass.h"
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
static NSString *const JSSeasonsViewModelActiveSeasonKey = @"JSSeasonsViewModelActiveSeasonKey";

@interface JSSeasonsViewModel ()

@property (nonatomic, copy, readwrite) NSArray *tournaments;

@end

@implementation JSSeasonsViewModel

#pragma mark - Private methods

- (void)initActiveSeason {
    NSData *data = [NSUserDefaults.standardUserDefaults objectForKey:JSSeasonsViewModelActiveSeasonKey];
    _activeSeason = data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : nil;

    #if defined(DEBUG)
        if ([NSProcessInfo.processInfo.environment[@"DEBUG_EMPTY_DB"] boolValue]) {
            _activeSeason = nil;
        }
    #endif
}

#pragma mark - JSViewModel methods

- (void)initData:(NSManagedObjectContext *)context {
    [super initData:context];

    NSArray *entities = [JSTournamentEntity js_all:context];

    self.tournaments = [[entities js_map:^JSTournament *(JSTournamentEntity *entity) {
        return [[JSTournament alloc] initWithEntity:entity];
    }] sortedArrayUsingComparator:^NSComparisonResult(JSTournament *tournament1, JSTournament *tournament2) {
        return [tournament1.name compare:tournament2.name];
    }];

    if (!_activeSeason) {
        [self initActiveSeason];
    }

    if (!_activeSeason) {
        NSString *defaultSeasonId = [NSUserDefaults.standardUserDefaults stringForKey:JSSeasonsRequestDefaultSeasonIdKey];
        if (defaultSeasonId.length == 0) {
            return;
        }

        for (JSTournament *tournament in self.tournaments) {
            for (JSSeason *season in tournament.seasons) {
                if ([season.seasonId isEqualToString:defaultSeasonId]) {
                    self.activeSeason = season;
                    return;
                }
            }
        }
    }
}

- (JSRequest *)request:(JSCoreDataManager *)coreDataManager {
    return [[JSSeasonsRequest alloc] initWithCoreDataManager:coreDataManager];
}

#pragma mark - Interface methods

- (void)setActiveSeason:(JSSeason *)activeSeason {
    _activeSeason = activeSeason;

    [NSUserDefaults.standardUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:activeSeason] forKey:JSSeasonsViewModelActiveSeasonKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
