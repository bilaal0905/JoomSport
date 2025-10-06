// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit.JSTableViewController;

@class JSTeamViewModel;

typedef void (^JSTeamPlayersViewControllerBlock)(NSString *playerId);

@interface JSTeamPlayersViewController : JSTableViewController

@property (nonatomic, copy) JSEventBlock onSeasonTap;
@property (nonatomic, copy) JSTeamPlayersViewControllerBlock onPlayerTap;

- (instancetype)initWithTeamModel:(JSTeamViewModel *)teamModel seasonsModel:(JSSeasonsViewModel *)seasonsModel;

@end
