// Created for BearDev by drif
// drif@mail.ru

#import "NSArray+JSUtils.h"
#import "JSLog.h"

@implementation NSArray (JSUtils)

#pragma mark - Interface methods

- (NSArray *)js_map:(JSArrayMapper)mapper {
    JSParameterAssert(mapper);

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSObject *object in self) {
        [array addObject:mapper(object)];
    }
    return array.copy;
}

@end
