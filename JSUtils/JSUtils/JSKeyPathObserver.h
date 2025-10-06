// Created for BearDev by drif
// drif@mail.ru

#import <Foundation/Foundation.h>

typedef void (^JSKeyPathObserverHandler)();

@interface JSKeyPathObserver : NSObject

- (instancetype)initWithTarget:(NSObject *)target;
- (void)observe:(NSString *)keyPath handler:(JSKeyPathObserverHandler)handler;

+ (instancetype)observerFor:(NSObject *)target keyPath:(NSString *)keyPath handler:(JSKeyPathObserverHandler)handler;

@end
