// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSCore.NSError_JSCore;
@import JSHTTP;

@interface JSErrorTests : XCTestCase

@end

@implementation JSErrorTests

#pragma mark - Interface methods

- (void)testError {
    NSDictionary *errors = @{
            @"Check your Internet connection": [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil],
            @"Network error": [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUserCancelledAuthentication userInfo:nil],

            @"Received inappropriate response": [NSError errorWithDomain:JSHTTPClientError code:JSHTTPClientErrorCodeInvalidResponse userInfo:nil],
            @"Internal sever error": [NSError errorWithDomain:JSHTTPClientError code:JSHTTPClientErrorCodeInternalServerError userInfo:nil],

            @"Unknown error": [NSError errorWithDomain:@"test" code:0 userInfo:nil]
    };

    for (NSString *key in errors.allKeys) {
        XCTAssertEqualObjects(key, [errors[key] js_error]);
    }
}

@end
