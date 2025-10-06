// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSStandingsViewModel;

@interface JSStandingsSortViewController : UITableViewController

@property (nonatomic, copy) JSEventBlock onDone;

- (instancetype)initWithModel:(JSStandingsViewModel *)model;

@end
