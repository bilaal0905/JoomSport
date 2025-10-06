// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;

#import "JSStandingsViewModel.h"
#import "JSAPIClient.h"
#import "JSStandingsRequest.h"
#import "JSStandings.h"
#import "JSSeasonEntity+CoreDataClass.h"

@interface JSStandingsViewModel ()

@property (nonatomic, strong, readwrite) JSStandings *standings;
@property (nonatomic, strong, readwrite) NSString *sortName;

@end

@implementation JSStandingsViewModel {
    NSURL *_placeholder;
}

#pragma mark - JSViewModel methods

- (void)initData:(NSManagedObjectContext *)context {
    if (!self.seasonId) {
        return;
    }

    JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:self.seasonId];
    self.standings = season.standings ? [[JSStandings alloc] initWithEntity:season.standings sortIndex:self.sortIndex placeholder:_placeholder] : nil;
}

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient {
    self = [super initWithAPIClient:apiClient];
    if (self) {
        _sortIndex = -1;
        _sortName = NSLocalizedString(@"Rank", nil);
        _placeholder =  ({
            NSString *placeholderPath = [self.base stringByAppendingPathComponent:@"media/bearleague/teams_st.png"];
            [[NSURL alloc] initWithString:placeholderPath];
        });

        [self invalidate];
    }
    return self;
}

- (JSRequest *)request:(JSCoreDataManager *)coreDataManager {
    return [[JSStandingsRequest alloc] initWithSeasonId:self.seasonId coreDataManager:coreDataManager];
}

#pragma mark - JSSeasonedViewModel methods

- (void)reset {
    [super reset];

    _sortIndex = -1;
    self.sortName = NSLocalizedString(@"Rank", nil);
}

#pragma mark - Interface methods

- (void)setSortIndex:(NSInteger)sortIndex {
    JSParameterAssert(sortIndex < (NSInteger) self.standings.fields.count);
    JSParameterAssert(sortIndex >= -1);

    if (_sortIndex == sortIndex) {
        return;
    }

    _sortIndex = sortIndex;
    self.sortName = (sortIndex == -1) ? NSLocalizedString(@"Rank", nil) : self.standings.fields[_sortIndex];

    [self invalidate];
}

@end
