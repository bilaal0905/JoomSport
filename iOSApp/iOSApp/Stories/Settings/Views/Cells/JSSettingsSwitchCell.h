// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSBlock;

#import "JSSettingsCell.h"

typedef NS_ENUM(NSInteger, JSSettingsSwitchCellStatus) {
    JSSettingsSwitchCellStatusOn,
    JSSettingsSwitchCellStatusOff,
    JSSettingsSwitchCellStatusInProgress
};

@interface JSSettingsSwitchCell : JSSettingsCell

@property (nonatomic, copy) JSEventBlock onSwitch;

- (void)setStatus:(JSSettingsSwitchCellStatus)status;

@end
