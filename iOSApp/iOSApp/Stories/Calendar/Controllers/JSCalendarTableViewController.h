// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSCalendarViewModel;

typedef void (^JSCalendarTableViewControllerHandler)(NSString *gameId);

@interface JSCalendarTableViewController : UITableViewController

@property (nonatomic, copy) JSCalendarTableViewControllerHandler onGameTap;

- (instancetype)initWithCalendarModel:(JSCalendarViewModel *)calendarModel;

@end
