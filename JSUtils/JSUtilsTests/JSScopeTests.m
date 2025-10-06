// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSUtils.JSScope;

@interface JSScopeTests : XCTestCase

@end

@implementation JSScopeTests

#pragma mark - Interface methods

- (void)testWeakify {
    NSObject *obj = [[NSObject alloc] init];

    JSWeakify(obj);
    XCTAssertEqualObjects(obj, js_weak_obj);

    obj = nil;
    XCTAssertNil(js_weak_obj);
}

- (void)testStrongify {
    NSObject *originalObj = [[NSObject alloc] init];
    NSObject *strongifiedObj = nil;

    void **originalAddr = ({
        void *p = (__bridge void *)(originalObj);
        &p;
    });

    JSWeakify(originalObj);
    {
        JSStrongify(originalObj);
        strongifiedObj = originalObj;

        void **strongifiedAddr = ({
            void *p = (__bridge void *)(originalObj);
            &p;
        });

        XCTAssertNotEqual(originalAddr, strongifiedAddr);
    }

    XCTAssertEqual(originalObj, strongifiedObj);
}

- (void)testScope {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for async block"];

    __block NSObject *obj = [[NSObject alloc] init];
    void (^setObjToNil)() = ^{
        obj = nil;
    };

    JSWeakify(obj);
    dispatch_async(dispatch_get_main_queue(), ^{
        JSStrongify(obj);
        setObjToNil();
        XCTAssertNotNil(js_weak_obj);

        obj = nil;
        XCTAssertNil(js_weak_obj);

        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:0.001 handler:nil];
}

@end
