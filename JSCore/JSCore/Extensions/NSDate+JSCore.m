// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSOnce;

#import "NSDate+JSCore.h"

@implementation NSDate (JSCore)

#pragma mark - Interface methods

- (NSString *)js_dateString {
    JSOnceSet(NSDateFormatter *, formatter, [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"d MMM, y, hh:mm a";
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"]
    );
    return [formatter stringFromDate:self];
}

@end
