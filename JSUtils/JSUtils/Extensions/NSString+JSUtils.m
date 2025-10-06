// Created for BearDev by drif
// drif@mail.ru

@import CommonCrypto;

#import "NSString+JSUtils.h"
#import "JSLog.h"

@implementation NSString (JSUtils)

#pragma mark - Interface methods

- (NSString *)js_substring:(NSString *)regex {

    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:regex options:(NSRegularExpressionOptions) 0 error:nil];
    JSParameterAssert(expression);

    NSArray *matches = [expression matchesInString:self options:(NSMatchingOptions) 0 range:NSMakeRange(0, self.length)];
    JSParameterAssert(matches.count == 1);

    return [self substringWithRange:[matches.firstObject range]];
}

- (NSString *)js_string {
    return self;
}

- (NSString *)js_md5 {
    const char *cstr = self.UTF8String;
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG) strlen(cstr), result);

    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

+ (NSString *)js_cachesPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    JSParameterAssert(paths.count == 1);

    return paths.firstObject;
}

- (NSNumber *)js_number {
    NSNumber *number = @(self.doubleValue);
    return [number.stringValue isEqualToString:self] ? number : nil;
}

- (NSAttributedString *)js_html:(NSString *)family weights:(NSDictionary *)weights size:(CGFloat)size {

    NSError *error;
    NSMutableAttributedString *string = [[NSAttributedString alloc] initWithData:(NSData * _Nonnull) [self dataUsingEncoding:NSUTF8StringEncoding] options:@{
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
    } documentAttributes:nil error:&error].mutableCopy;

    if (!string) {
        JSLogError(@"Error while create HTML string:\n\tstring: %@\n\terror: %@", self, error);
        return nil;
    }

    [string enumerateAttributesInRange:NSMakeRange(0, string.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIFont *font = attrs[NSFontAttributeName];

        CGFloat pointSize = font.pointSize;
        if (ABS((double) pointSize - 12.0) < DBL_EPSILON) {
            pointSize = size;
        }

        NSString *weight = [[font.fontName componentsSeparatedByString:@"-"] lastObject];
        weight = weights[weight] ?: @"Regular";

        NSString *name = [NSString stringWithFormat:@"%@-%@", family, weight];

        attrs = ({
            NSMutableDictionary *dict = attrs.mutableCopy;
            dict[NSFontAttributeName] = [UIFont fontWithName:name size:pointSize];
            dict.copy;
        });

        [string setAttributes:attrs range:range];
    }];

    return string.copy;
}

@end
