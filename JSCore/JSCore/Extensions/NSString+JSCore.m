// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSOnce;

#import "NSString+JSCore.h"

@implementation NSString (JSCore)

#pragma mark - Interface methods

- (NSDate *)js_date {
    JSOnceSet(NSDateFormatter *, formatter, [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter.dateFormat = @"M-d-y h:m a";
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"]
    );
    return [formatter dateFromString:self];
}

- (NSDate *)js_date24 {
    JSOnceSet(NSDateFormatter *, formatter, [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter.dateFormat = @"dd-MM-yyyy HH:mm";
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"]
   );
    return [formatter dateFromString:self];
}

@end
