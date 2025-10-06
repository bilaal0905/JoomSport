// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import OHHTTPStubs;
@import JSHTTP;
@import JSUtils.JSScope;

@interface JSHTTPClientTests : XCTestCase

@end

@implementation JSHTTPClientTests

#pragma mark - Private methods

- (void)performRequest:(NSString *)path completion:(void (^)(JSHTTPRequest *))completion {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for finish"];

    NSString *base = @"http://base.com";
    JSHTTPClient *client = [[JSHTTPClient alloc] initWithBase:base];
    JSHTTPRequest *request = [[JSHTTPRequest alloc] initWithPath:path params:nil];

    JSWeakify(request);
    request.onFinish = ^{
        JSStrongify(request);
        completion(request);
        [expectation fulfill];
    };

    [client perform:request];
    [self waitForExpectationsWithTimeout:0.001 handler:nil];
}

#pragma mark - XCTestCase methods

+ (void)setUp {
    [super setUp];

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://base.com/dict"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithJSONObject:@{
                @"key1": @"value1",
                @"key2": @"value2"
        } statusCode:200 headers:nil];
    }];

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://base.com/arr"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithJSONObject:@[@"val1", @"val2"] statusCode:200 headers:nil];
    }];

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://base.com/err"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithJSONObject:@[] statusCode:500 headers:nil];
    }];
}

#pragma mark - Interface methods

- (void)testDict {
    [self performRequest:@"dict" completion:^(JSHTTPRequest *request) {
        NSDictionary *json = @{
                @"key1": @"value1",
                @"key2": @"value2"
        };
        XCTAssertEqualObjects(request.json, json);
        XCTAssertNil(request.error);
    }];
}

- (void)testArr {
    [self performRequest:@"arr" completion:^(JSHTTPRequest *request) {
        NSDictionary *json = @{
                @"root": @[
                        @"val1",
                        @"val2"
                ]
        };
        XCTAssertEqualObjects(request.json, json);
        XCTAssertNil(request.error);
    }];
}

- (void)testErr {
    [self performRequest:@"err" completion:^(JSHTTPRequest *request) {
        XCTAssertNil(request.json);
        XCTAssertEqual(request.error.domain, JSHTTPClientError);
        XCTAssertEqual(request.error.code, JSHTTPClientErrorCodeInternalServerError);
    }];
}

@end
