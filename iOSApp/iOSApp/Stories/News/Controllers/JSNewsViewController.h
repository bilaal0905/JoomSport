// Created for BearDev by drif
// drif@mail.ru

#import "JSTitledViewController.h"
#import "JSNewsTableViewController.h"

@class JSNewsViewModel;

@interface JSNewsViewController : JSTitledViewController

@property (nonatomic, copy) JSNewsTableViewControllerBlock onNewsTap;

- (instancetype)initWithModel:(JSNewsViewModel *)model;

@end
