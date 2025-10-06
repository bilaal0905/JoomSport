// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSBlock;

#import "JSTitledViewController.h"

@class JSSettingsViewModel;

@interface JSSettingsViewController : JSTitledViewController

@property (nonatomic, copy) JSEventBlock onTeamsTap;

- (instancetype)initWithModel:(JSSettingsViewModel *)model;

@end
