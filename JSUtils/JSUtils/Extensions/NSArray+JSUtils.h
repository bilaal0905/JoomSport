// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

typedef id (^JSArrayMapper)(id object);
typedef BOOL (^JSArrayFilter)(id object);

@interface NSArray (JSUtils)

- (NSArray *)js_map:(JSArrayMapper)mapper;

@end
