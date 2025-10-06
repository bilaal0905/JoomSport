// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSUtils.NSURL_JSUtils;

@interface JSURLTests : XCTestCase

@end

@implementation JSURLTests

#pragma mark - Interface methods

- (void)testCaches {
    XCTAssertTrue([NSURL.js_cachesURL.absoluteString rangeOfString:@"data/Library/Caches"].location != NSNotFound);
}

@end
