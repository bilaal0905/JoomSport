// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit.JSTableViewController;

@class JSSeasonsViewModel;
@class JSTeamViewModel;
@class JSStandingsViewModel;

@interface JSTeamStatisticViewController : JSTableViewController

@property (nonatomic, copy) JSEventBlock onSeasonTap;

- (instancetype)initWithTeamModel:(JSTeamViewModel *)teamModel seasonsModel:(JSSeasonsViewModel *)seasonsModel standingsModel:(JSStandingsViewModel *)standingsModel;

@end
