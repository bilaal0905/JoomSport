// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit.JSDetailedTableViewController;

@class JSStandingsViewModel;

typedef void (^JSStandingsTableViewControllerTeamBlock)(NSString *teamId);

@interface JSStandingsTableViewController : JSDetailedTableViewController

@property (nonatomic, copy) JSStandingsTableViewControllerTeamBlock onTeamTap;

- (instancetype)initWithStandingsModel:(JSStandingsViewModel *)standingsModel;

@end
