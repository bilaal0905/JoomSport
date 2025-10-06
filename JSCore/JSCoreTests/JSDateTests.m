// Created for BearDev by drif
// drif@mail.ru

@import XCTest;

#import "NSDate+JSCore.h"
#import "NSString+JSCore.h"

@interface JSDateTests : XCTestCase

@end

@implementation JSDateTests

#pragma mark - Interface methods

- (void)testDate {
    NSDate *date = [@"09-03-2010 11:00 PM".js_date dateByAddingTimeInterval:-NSTimeZone.localTimeZone.secondsFromGMT];
    XCTAssertEqualObjects(date.js_dateString, @"3 Sep, 2010, 11:00 PM");
}

@end
