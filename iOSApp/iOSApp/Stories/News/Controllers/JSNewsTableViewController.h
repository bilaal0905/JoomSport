// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit.JSTableViewController;

@class JSNewsViewModel;

typedef void (^JSNewsTableViewControllerBlock)(NSString *newsId);

@interface JSNewsTableViewController : JSTableViewController

@property (nonatomic, copy) JSNewsTableViewControllerBlock onNewsTap;

- (instancetype)initWithModel:(JSNewsViewModel *)model;

@end
