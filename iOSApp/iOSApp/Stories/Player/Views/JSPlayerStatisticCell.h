// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSExtraInfo;

extern CGFloat const JSPlayerStatisticCellHeight;
extern UIEdgeInsets const JSPlayerStatisticCellSeparatorInset;

@interface JSPlayerStatisticCell : UITableViewCell

- (void)setup:(JSExtraInfo *)info;

@end
