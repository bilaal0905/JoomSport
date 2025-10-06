// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils.JSLog;
@import JSHTTP.JSHTTPClient;

#import "JSModelsStore.h"

@implementation JSModelsStore {
    JSAPIClient *_apiClient;

    JSSeasonsViewModel *_seasonsViewModel;
    JSStandingsViewModel *_standingsViewModel;
    JSCalendarViewModel *_calendarViewModel;
    JSTeamViewModel *_teamViewModel;
    JSPlayerViewModel *_playerViewModel;
    JSSettingsViewModel *_settingsViewModel;
    JSNewsViewModel *_newsViewModel;
    JSNewsDetailsViewModel *_newsDetailsViewModel;
}

#pragma mark - Interface methods

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient {
    JSParameterAssert(apiClient);

    self = [super init];
    if (self) {
        _apiClient = apiClient;

        _seasonsViewModel = [[JSSeasonsViewModel alloc] initWithAPIClient:_apiClient];
        _standingsViewModel = [[JSStandingsViewModel alloc] initWithAPIClient:_apiClient];
        _calendarViewModel = [[JSCalendarViewModel alloc] initWithAPIClient:_apiClient];
        _teamViewModel = [[JSTeamViewModel alloc] initWithAPIClient:_apiClient];
        _playerViewModel = [[JSPlayerViewModel alloc] initWithAPIClient:_apiClient];
        _settingsViewModel = [[JSSettingsViewModel alloc] initWithAPIClient:_apiClient];
        _newsViewModel = [[JSNewsViewModel alloc] initWithAPIClient:_apiClient];
        _newsDetailsViewModel = [[JSNewsDetailsViewModel alloc] initWithAPIClient:_apiClient];
    }
    return self;
}

- (JSSeasonsViewModel *)seasonsViewModel {
    return _seasonsViewModel;
}

- (JSStandingsViewModel *)standingsViewModel {
    return _standingsViewModel;
}

- (JSCalendarViewModel *)calendarViewModel {
    return _calendarViewModel;
}

- (JSGameResultsViewModel *)gameResultsViewModel:(NSString *)gameId of:(NSString *)seasonId {
    return [[JSGameResultsViewModel alloc] initWithAPIClient:_apiClient gameId:gameId seasonId:seasonId];
}

- (JSTeamViewModel *)teamViewModel {
    return _teamViewModel;
}

- (JSPlayerViewModel *)playerViewModel {
    return _playerViewModel;
}

- (JSSettingsViewModel *)settingsViewModel {
    return _settingsViewModel;
}

- (JSNewsViewModel *)newsViewModel {
    return _newsViewModel;
}

- (JSNewsDetailsViewModel *)newsDetailsViewModel {
    return _newsDetailsViewModel;
}

@end
