// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSUtils.JSOnce;

@interface JSOnceTests : XCTestCase

@end

@implementation JSOnceTests {
    NSUInteger _counter;
}

#pragma mark - Private methods

- (NSString *)example {
    JSOnceSetReturn(NSString *, str, @"test"; self->_counter++);
}

#pragma mark - Interface methods

- (void)testSet {
    JSOnceSet(NSString *, str, @"example");
    XCTAssertEqualObjects(str, @"example");

    JSOnceSet(NSString *, str2, @"example2");
    XCTAssertEqualObjects(str2, @"example2");
}

- (void)testOnce {
    [self example];
    XCTAssertEqual(_counter, 1U);

    [self example];
    XCTAssertEqual(_counter, 1U);
}

@end
