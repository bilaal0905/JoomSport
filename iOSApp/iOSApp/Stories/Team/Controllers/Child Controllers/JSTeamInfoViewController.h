// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit.JSTableViewController;

@class JSTeamViewModel;

@interface JSTeamInfoViewController : JSTableViewController

@property (nonatomic, copy) JSEventBlock onTeamChoose;
- (instancetype)initWithTeamModel:(JSTeamViewModel *)teamModel;
- (void)onRefreshControl;

@end
