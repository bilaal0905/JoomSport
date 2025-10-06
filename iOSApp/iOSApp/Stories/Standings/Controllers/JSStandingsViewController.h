// Created for BearDev by drif
// drif@mail.ru

#import "JSSeasonedViewController.h"
#import "JSStandingsTableViewController.h"

@class JSStandingsViewModel;

@interface JSStandingsViewController : JSSeasonedViewController

@property (nonatomic, copy) JSEventBlock onSortTap;
@property (nonatomic, copy) JSStandingsTableViewControllerTeamBlock onTeamTap;

- (instancetype)initWithSeasonsModel:(JSSeasonsViewModel *)seasonsModel standingsModel:(JSStandingsViewModel *)standingsModel;

@end
