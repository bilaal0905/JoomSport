// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSHTTP.JSHTTPRequest;

@interface JSHTTPRequestTests : XCTestCase

@end

@implementation JSHTTPRequestTests

#pragma mark - Interface methods

- (void)testURLPath {
    NSURL *base = [[NSURL alloc] initWithString:@"http://baseurl.com"];

    JSHTTPRequest *request = [[JSHTTPRequest alloc] initWithPath:@"testpath" params:nil];
    XCTAssertEqualObjects([request url:base].absoluteString, @"http://baseurl.com/testpath");

    request = [[JSHTTPRequest alloc] initWithPath:@"testpath/test_subpath" params:nil];
    XCTAssertEqualObjects([request url:base].absoluteString, @"http://baseurl.com/testpath/test_subpath");

    base = [[NSURL alloc] initWithString:@"http://baseurl.com/app_name/"];
    XCTAssertEqualObjects([request url:base].absoluteString, @"http://baseurl.com/app_name/testpath/test_subpath");
}

- (void)testURLParams {
    NSURL *base = [[NSURL alloc] initWithString:@"http://baseurl.com"];

    JSHTTPRequest *request = [[JSHTTPRequest alloc] initWithPath:@"testpath" params:@{@"param": @"value"}];
    XCTAssertEqualObjects([request url:base].absoluteString, @"http://baseurl.com/testpath?param=value");

    request = [[JSHTTPRequest alloc] initWithPath:@"testpath" params:@{
            @"param1": @"value1",
            @"param2": @"value2"
    }];
    BOOL firstToSecond = [[request url:base].absoluteString isEqualToString:@"http://baseurl.com/testpath?param1=value1&param2=value2"];
    BOOL secondToFirst = [[request url:base].absoluteString isEqualToString:@"http://baseurl.com/testpath?param2=value2&param1=value1"];
    XCTAssertTrue(firstToSecond || secondToFirst);
}

@end
