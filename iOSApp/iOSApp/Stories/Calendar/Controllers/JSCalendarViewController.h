// Created for BearDev by drif
// drif@mail.ru

#import "JSSeasonedViewController.h"
#import "JSCalendarTableViewController.h"

@interface JSCalendarViewController : JSSeasonedViewController

@property (nonatomic, copy) JSEventBlock onParticipantTap;
@property (nonatomic, copy) JSCalendarTableViewControllerHandler onGameTap;

- (instancetype)initWithSeasonsModel:(JSSeasonsViewModel *)seasonsModel standingsModel:(JSCalendarViewModel *)calendarModel;

@end
