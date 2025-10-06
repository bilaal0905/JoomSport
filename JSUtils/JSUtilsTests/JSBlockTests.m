// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSUtils.JSBlock;

typedef void (^JSBlockTestsBlock)();
typedef void (^JSBlockTestsObjectsBlock)(NSObject *object1, NSObject *object2);

@interface JSBlockTests : XCTestCase

@end

@implementation JSBlockTests

#pragma mark - Interface methods

- (void)testBlock {
    JSBlockTestsBlock block = nil;
    JSBlockTestsObjectsBlock objectsBlock = nil;
    
    NSObject *object1 = [[NSObject alloc] init];
    NSObject *object2 = [[NSObject alloc] init];

    JSBlock(block, nil);
    JSBlock(objectsBlock, nil, nil);
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Waiting for block"];
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Waiting for block"];

    block = ^{
        [expectation1 fulfill];
    };

    objectsBlock = ^(NSObject *o1, NSObject *o2) {
        XCTAssertEqual(o1, object1);
        XCTAssertEqual(o2, object2);

        [expectation2 fulfill];
    };

    JSBlock(block, nil);
    JSBlock(objectsBlock, object1, object2);

    [self waitForExpectationsWithTimeout:0.001 handler:nil];
}

@end
