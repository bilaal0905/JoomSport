// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@interface JSToastErrorView : UIView

@property (nonatomic, copy) JSEventBlock onTap;

- (instancetype)initWithError:(NSString *)error;

@end
