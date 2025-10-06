// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSExtraInfo;

extern CGFloat const JSExtraInfoCellHeight;
extern UIEdgeInsets const JSExtraInfoCellSeparatorInset;

@interface JSExtraInfoCell : UITableViewCell

- (void)setup:(JSExtraInfo *)info;

@end
