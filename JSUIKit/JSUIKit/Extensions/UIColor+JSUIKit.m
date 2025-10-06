// Created for BearDev by drif
// drif@mail.ru

#import "UIColor+JSUIKit.h"

@implementation UIColor (JSUIKit)

#pragma mark - Interface methods

+ (UIColor *)js_R:(NSUInteger)r G:(NSUInteger)g B:(NSUInteger)b {
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}

@end
