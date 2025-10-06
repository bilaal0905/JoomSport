// Created for BearDev by drif
// drif@mail.ru

#import "NSNumber+JSUtils.h"

@implementation NSNumber (JSUtils)

#pragma mark - Interface methods

- (NSString *)js_string {
    return self.stringValue;
}

@end