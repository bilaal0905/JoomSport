// Created for BearDev by drif
// drif@mail.ru

@import UIKit;
@import JSUtils.JSBlock;

@class JSTeam;

extern CGFloat const JSSettingsTeamCellHeight;

typedef NS_ENUM(NSInteger, JSSettingsTeamCellStatus) {
    JSSettingsTeamCellStatusOn,
    JSSettingsTeamCellStatusOff,
    JSSettingsTeamCellStatusInProgress
};

@interface JSSettingsTeamCell : UITableViewCell

@property (nonatomic, copy) JSEventBlock onChange;

- (void)setup:(JSTeam *)team;
- (void)roundTop:(BOOL)top bottom:(BOOL)bottom;

- (void)setStatus:(JSSettingsTeamCellStatus)status;

@end
