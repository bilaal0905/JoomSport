// Created for BearDev by drif
// drif@mail.ru

#import "JSDetailsViewController.h"

@class JSSeasonsViewModel;
@class JSPlayerViewModel;

@interface JSPlayerViewController : JSDetailsViewController

@property (nonatomic, copy) JSEventBlock onSeasonTap;
@property (nonatomic, copy) JSEventBlock onDone;
@property (nonatomic, copy) JSEventBlock onNoData;

- (instancetype)initWithSeasonsModel:(JSSeasonsViewModel *)seasonsModel playerModel:(JSPlayerViewModel *)playerModel;

@end
