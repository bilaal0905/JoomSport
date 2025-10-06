// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSBlock;
@import JSUIKit.JSViewController;

@class JSSeasonedView;
@class JSSeasonsViewModel;

@interface JSSeasonedViewController : JSViewController

@property (nonatomic, copy) JSEventBlock onSeasonTap;

- (instancetype)initWithSeasonsModel:(JSSeasonsViewModel *)seasonsModel;

- (JSSeasonedView *)seasonedView;
- (JSSeasonsViewModel *)seasonsModel;

@end
