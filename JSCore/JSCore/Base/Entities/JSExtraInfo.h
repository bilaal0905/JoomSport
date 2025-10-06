// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@interface JSExtraInfo : NSObject <
    NSCoding
>

- (instancetype)initWithName:(NSString *)name value:(NSString *)value type:(NSString *)type;
- (instancetype)initWithName:(NSString *)name value:(NSString *)value image:(NSString *)image;

- (NSString *)name;
- (NSString *)value;
- (NSURL *)url;
- (NSURL *)imageURL;

@end
