// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSAPIClient;
@class JSSeasonsViewModel;
@class JSStandingsViewModel;
@class JSCalendarViewModel;
@class JSGameResultsViewModel;
@class JSTeamViewModel;
@class JSPlayerViewModel;
@class JSSettingsViewModel;

@interface JSModelsStore : NSObject

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient;

- (JSSeasonsViewModel *)seasonsViewModel;
- (JSStandingsViewModel *)standingsViewModel;
- (JSCalendarViewModel *)calendarViewModel;
- (JSGameResultsViewModel *)gameResultsViewModel:(NSString *)gameId of:(NSString *)seasonId;
- (JSTeamViewModel *)teamViewModel;
- (JSPlayerViewModel *)playerViewModel;
- (JSSettingsViewModel *)settingsViewModel;
- (JSNewsViewModel *)newsViewModel;
- (JSNewsDetailsViewModel *)newsDetailsViewModel;

@end
