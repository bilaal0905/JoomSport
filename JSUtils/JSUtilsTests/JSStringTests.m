// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSUtils.NSString_JSUtils;

@interface JSStringTests : XCTestCase

@end

@implementation JSStringTests

#pragma mark - Interface methods

- (void)testSubstring {
    NSString *string = @"Json is: {key:value}.";
    NSString *substring = [string js_substring:@"\\{.*\\}"];
    XCTAssertEqualObjects(substring, @"{key:value}");
}

- (void)testString {
    NSString *string = @"Test";
    XCTAssertEqual(string, string.js_string);
}

- (void)testMD5 {
    XCTAssertEqualObjects(@"md5".js_md5, @"1BC29B36F623BA82AAF6724FD3B16718");
    XCTAssertEqualObjects(@"md4".js_md5, @"C93D3BF7A7C4AFE94B64E30C2CE39F4F");
    XCTAssertEqualObjects(@"".js_md5, @"D41D8CD98F00B204E9800998ECF8427E");
}

- (void)testNumber {
    XCTAssertEqualObjects(@"42".js_number, @42);
    XCTAssertEqualObjects(@"13.37".js_number, @13.37);
    XCTAssertEqualObjects(@"-13.37".js_number, @-13.37);
    XCTAssertNil(@"13-37".js_number);
}

- (void)testCaches {
    XCTAssertTrue([NSString.js_cachesPath rangeOfString:@"data/Library/Caches"].location != NSNotFound);
}

@end
