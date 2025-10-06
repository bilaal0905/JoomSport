// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit.JSTableViewController;

@class JSPlayerViewModel;
@class JSSeasonsViewModel;

@interface JSPlayerStatisticViewController : JSTableViewController

@property (nonatomic, copy) JSEventBlock onSeasonTap;

- (instancetype)initWithPlayerModel:(JSPlayerViewModel *)playerModel seasonsModel:(JSSeasonsViewModel *)seasonsModel;

@end
