// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSUtils.NSArray_JSUtils;

@interface JSArrayTests : XCTestCase

@end

@implementation JSArrayTests

#pragma mark - Interface methods

- (void)testMap {
    NSArray *original = @[@1, @2, @3];
    NSArray *mapped = [original js_map:^NSString *(NSNumber *object) {
        return object.stringValue;
    }];

    XCTAssertEqual(original.count, mapped.count);

    for (NSUInteger i = 0; i < mapped.count; i++) {
        NSString *s = mapped[i];

        XCTAssertTrue([s isKindOfClass:NSString.class]);
        XCTAssertEqualObjects(s, [original[i] stringValue]);
    }
}

@end
