// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSBlock;

#import "JSTitledViewController.h"

@class JSSettingsViewModel;

@interface JSSettingsTeamsViewController : JSTitledViewController

@property (nonatomic, copy) JSEventBlock onDone;

- (instancetype)initWithModel:(JSSettingsViewModel *)model;

@end
