// Created for BearDev by drif
// drif@mail.ru

@import XCTest;

#import "NSString+JSCore.h"

@interface JSStringTests : XCTestCase

@end

@implementation JSStringTests

#pragma mark - Interface methods

- (void)testDate {
    NSDate *parsedDate = @"09-03-2010 11:00 PM".js_date;
    NSString *string = [NSString stringWithFormat:@"%@", parsedDate];
    XCTAssertEqualObjects(string, @"2010-09-03 23:00:00 +0000");
}

@end
