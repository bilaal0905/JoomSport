// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSUtils.JSKeyPathObserver;

@interface JSKeyPathObserverTestsObject : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *anotherKey;
@property (nonatomic, strong) NSString *yetAnotherKey;

@end

@implementation JSKeyPathObserverTestsObject

@end

@interface JSKeyPathObserverTests : XCTestCase

@end

@implementation JSKeyPathObserverTests

#pragma mark - Interface methods

- (void)testObserve {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for handler"];

    JSKeyPathObserverTestsObject *object = [[JSKeyPathObserverTestsObject alloc] init];
    __unused JSKeyPathObserver *observer = [JSKeyPathObserver observerFor:object keyPath:@"key" handler:^{
        [expectation fulfill];
    }];

    object.key = @"value";

    [self waitForExpectationsWithTimeout:0.001 handler:nil];
}

- (void)testMultipleObserve {
    NSArray *expectations = @[
            [self expectationWithDescription:@"Waiting for handler"],
            [self expectationWithDescription:@"Waiting for handler"],
            [self expectationWithDescription:@"Waiting for handler"]
    ];

    JSKeyPathObserverTestsObject *object = [[JSKeyPathObserverTestsObject alloc] init];

    JSKeyPathObserver *observer = [JSKeyPathObserver observerFor:object keyPath:@"key" handler:^{
        [expectations[0] fulfill];
    }];
    [observer observe:@"key" handler:^{
        [expectations[1] fulfill];
    }];
    [observer observe:@"anotherKey" handler:^{
        [expectations[2] fulfill];
    }];
    [observer observe:@"yetAnotherKey" handler:^{
        XCTAssertFalse(nil);
    }];

    object.key = @"value";
    object.anotherKey = @"value";

    [self waitForExpectationsWithTimeout:0.001 handler:nil];
}

- (void)testReference {
    JSKeyPathObserverTestsObject *strongObject = [[JSKeyPathObserverTestsObject alloc] init];
    __weak JSKeyPathObserverTestsObject *weakObject = strongObject;

    JSKeyPathObserver *observer;
    @autoreleasepool {
        observer = [JSKeyPathObserver observerFor:strongObject keyPath:@"key" handler:^{}];
    }

    strongObject = nil;
    XCTAssertNotNil(weakObject);

    observer = nil;
    XCTAssertNil(weakObject);
}

@end
