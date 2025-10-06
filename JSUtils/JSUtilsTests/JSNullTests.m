// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSUtils.NSNull_JSUtils;

@interface JSNullTests : XCTestCase

@end

@implementation JSNullTests

#pragma mark - Interface methods

- (void)testString {
    NSNull *null = [NSNull null];
    XCTAssertEqualObjects(null.js_string, @"");
}

@end
