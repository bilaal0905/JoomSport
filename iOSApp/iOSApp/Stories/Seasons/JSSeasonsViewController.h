// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSSeasonsViewModel;

@interface JSSeasonsViewController : UITableViewController

@property (nonatomic, copy) JSEventBlock onDone;

- (instancetype)initWithModel:(JSSeasonsViewModel *)viewModel;

@end
