// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSGameEvent;

extern CGFloat const JSGameEventCellHeight;

@interface JSGameEventCell : UITableViewCell

- (void)setup:(JSGameEvent *)event;

@end
