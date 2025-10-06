// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit.JSViewController;
@import JSUtils.JSBlock;

#import "JSStandingsTableViewController.h"

@class JSGameResultsViewModel;

@interface JSGameResultsViewController : JSViewController

@property (nonatomic, copy) JSEventBlock onBackTap;
@property (nonatomic, copy) JSStandingsTableViewControllerTeamBlock onTeamTap;

- (instancetype)initWithModel:(JSGameResultsViewModel *)model;

@end
