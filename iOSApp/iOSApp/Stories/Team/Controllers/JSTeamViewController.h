// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSBlock;

#import "JSDetailsViewController.h"
#import "JSTeamPlayersViewController.h"

@class JSSeasonsViewModel;
@class JSTeamViewModel;

@interface JSTeamViewController : JSDetailsViewController

@property (nonatomic, copy) JSEventBlock onSeasonTap;
@property (nonatomic, copy) JSTeamPlayersViewControllerBlock onPlayerTap;
@property (nonatomic, copy) JSEventBlock onTeamChoose;

- (instancetype)initWithSeasonsModel:(JSSeasonsViewModel *)seasonsModel teamModel:(JSTeamViewModel *)teamModel standingsModel:(JSStandingsViewModel *)standingsModel;

@end
