// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSBlock;

#import "JSTitledViewController.h"

@class JSNewsDetailsViewModel;

@interface JSNewsDetailsViewController : JSTitledViewController

@property (nonatomic, copy) JSEventBlock onBackTap;

- (instancetype)initWithModel:(JSNewsDetailsViewModel *)model;

@end
