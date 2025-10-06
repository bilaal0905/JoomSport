// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSUtils.NSNumber_JSUtils;

@interface JSNumberTests : XCTestCase

@end

@implementation JSNumberTests

#pragma mark - Interface methods

- (void)testString {
    NSNumber *number = @1337;
    XCTAssertEqualObjects(number.js_string, @"1337");
}

@end
