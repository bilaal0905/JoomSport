// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@interface NSString (JSUtils)

- (NSString *)js_substring:(NSString *)regex;
- (NSString *)js_string;
- (NSString *)js_md5;
+ (NSString *)js_cachesPath;
- (NSNumber *)js_number;
- (NSAttributedString *)js_html:(NSString *)family weights:(NSDictionary *)weights size:(CGFloat)size;

@end
