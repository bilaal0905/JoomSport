// Created for BearDev by drif
// drif@mail.ru

@import UIKit;
@import JSUtils;

@class JSSeasonsViewModel;

@interface JSFirstLaunchViewController : UIViewController

@property (nonatomic, copy) JSEventBlock onDone;

- (instancetype)initWithModel:(JSSeasonsViewModel *)viewModel;

@end
