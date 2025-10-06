// Created for BearDev by drif
// drif@mail.ru

@import UIKit;
@import JSUtils.JSBlock;

@class JSTeamViewModel;
@class JSStandingsViewModel;

@interface JSTeamsTableViewController : UITableViewController

@property (nonatomic, copy) JSEventBlock onDone;
@property (nonatomic, copy) JSEventBlock onCancel;

- (instancetype)initWithTeamModel:(JSTeamViewModel *)teamModel standingsModel:(JSStandingsViewModel *)standingsModel;

@end
