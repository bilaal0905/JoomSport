// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;

#import "JSGameResultsViewModel.h"
#import "JSGame.h"
#import "JSAPIClient.h"
#import "JSGameResultsRequest.h"
#import "JSGameEvent.h"
#import "JSGameStatistic.h"
#import "JSGameEntity+CoreDataClass.h"
#import "JSGameEventEntity+CoreDataClass.h"
#import "JSGameStatisticEntity+CoreDataClass.h"

@interface JSGameResultsViewModel ()

@property (nonatomic, strong, readwrite) JSGame *game;
@property (nonatomic, strong, readwrite) NSArray *events;
@property (nonatomic, strong, readwrite) NSArray *statistics;

@end

@implementation JSGameResultsViewModel {
    NSString *_gameId;
    NSString *_seasonId;
    NSURL *_placeholder;
}

#pragma mark - JSViewModel methods

- (void)initData:(NSManagedObjectContext *)context {
    if (!_gameId) {
        return;
    }

    JSGameEntity *game = [JSGameEntity js_object:context where:@"gameId" equals:_gameId];
    self.game = [[JSGame alloc] initWithEntity:game placeholder:_placeholder];

    self.events = [[game.events.allObjects js_map:^JSGameEvent *(JSGameEventEntity *event) {
        return [[JSGameEvent alloc] initWithEntity:event];
    }] sortedArrayUsingComparator:^NSComparisonResult(JSGameEvent *event1, JSGameEvent *event2) {
        return [event1.minute compare:event2.minute];
    }];

    self.statistics = [[game.statistics.allObjects js_map:^JSGameStatistic *(JSGameStatisticEntity *entity) {
        return [[JSGameStatistic alloc] initWithEntity:entity];
    }] sortedArrayUsingComparator:^NSComparisonResult(JSGameStatistic *obj1, JSGameStatistic *obj2) {
        return [obj1.statisticId compare:obj2.statisticId];
    }];
}

- (JSRequest *)request:(JSCoreDataManager *)coreDataManager {
    return [[JSGameResultsRequest alloc] initWithGameId:_gameId of:_seasonId coreDataManager:coreDataManager];
}

#pragma mark - Interface methods

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient gameId:(NSString *)gameId seasonId:(NSString *)seasonId {
    JSParameterAssert(gameId);

    self = [super initWithAPIClient:apiClient];
    if (self) {
        _gameId = gameId.copy;
        _seasonId = seasonId.copy;
        _placeholder =  ({
            NSString *placeholderPath = [self.base stringByAppendingPathComponent:@"media/bearleague/teams_st.png"];
            [[NSURL alloc] initWithString:placeholderPath];
        });

        [self invalidate];
    }
    return self;
}

@end
