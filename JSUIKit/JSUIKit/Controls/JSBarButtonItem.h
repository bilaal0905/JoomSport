// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@interface JSBarButtonItem : UIBarButtonItem

@property (nonatomic, copy) JSEventBlock onTap;

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem;

@end
