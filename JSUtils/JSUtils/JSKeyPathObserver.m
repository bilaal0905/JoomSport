// Created for BearDev by drif
// drif@mail.ru

#import "JSKeyPathObserver.h"
#import "JSLog.h"

@implementation JSKeyPathObserver {
    NSObject *_target;
    NSMutableDictionary *_handlers;
}

#pragma mark - NSObject methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([change[NSKeyValueChangeNewKey] isEqual:change[NSKeyValueChangeOldKey]]) {
        return;
    }

    NSArray *handlers = _handlers[keyPath];
    for (JSKeyPathObserverHandler handler in handlers) {
        handler();
    }
}

- (void)dealloc {
    for (NSString *keyPath in _handlers.allKeys) {
        [_target removeObserver:self forKeyPath:keyPath];
    }
}

#pragma mark - Interface methods

- (instancetype)initWithTarget:(NSObject *)target {
    JSParameterAssert(target);

    self = [super init];
    if (self) {
        _target = target;
        _handlers = NSMutableDictionary.dictionary;
    }
    return self;
}

- (void)observe:(NSString *)keyPath handler:(JSKeyPathObserverHandler)handler {
    JSParameterAssert(keyPath);
    JSParameterAssert(handler);

    @synchronized (self) {
        if (!_handlers[keyPath]) {
            _handlers[keyPath] = NSMutableArray.array;
            [_target addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
        [_handlers[keyPath] addObject:handler];
    }
}

+ (instancetype)observerFor:(NSObject *)target keyPath:(NSString *)keyPath handler:(JSKeyPathObserverHandler)handler {
    JSKeyPathObserver *observer = [[JSKeyPathObserver alloc] initWithTarget:target];
    [observer observe:keyPath handler:handler];
    return observer;
}

@end
