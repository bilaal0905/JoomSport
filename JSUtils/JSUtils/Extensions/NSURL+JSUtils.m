// Created for BearDev by drif
// drif@mail.ru

#import "NSURL+JSUtils.h"
#import "JSUtils.h"

@implementation NSURL (JSUtils)

#pragma mark - Interface methods

+ (NSURL *)js_cachesURL {
    return [[NSURL alloc] initFileURLWithPath:NSString.js_cachesPath];
}

@end
