// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSCalendarViewModel;

@interface JSCalendarParticipantsViewController : UITableViewController

@property (nonatomic, copy) JSEventBlock onDone;

- (instancetype)initWithModel:(JSCalendarViewModel *)model;

@end
