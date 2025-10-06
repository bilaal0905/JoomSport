// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@interface JSTextCellLayout : NSObject

- (instancetype)initWithText:(NSAttributedString *)text;
- (void)setWidth:(CGFloat)width;

- (NSAttributedString *)text;
- (CGRect)labelFrame;
- (CGFloat)height;

@end
