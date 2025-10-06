// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import OHHTTPStubs;
@import JSUtils;
@import JSHTTP.JSImagesLoader;

@interface JSImagesLoaderTests : XCTestCase

@end

@implementation JSImagesLoaderTests

#pragma mark - Private methods

+ (NSString *)cachesPath {
    JSOnceSetReturn(NSString *, path, [NSString.js_cachesPath stringByAppendingPathComponent:@"images"]);
}

+ (JSImagesLoader *)imagesLoader {
    JSOnceSetReturn(JSImagesLoader *, imagesLoader, [[JSImagesLoader alloc] initWithCachesPath:self.cachesPath]);
}

- (id <OHHTTPStubsDescriptor>)stub:(NSURL *)url with:(NSString *)image of:(NSString *)type {
    return [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL isEqual:url];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:image ofType:type];
        return [OHHTTPStubsResponse responseWithFileAtPath:path statusCode:200 headers:nil];
    }];
}

- (id <OHHTTPStubsDescriptor>)stubError:(NSURL *)url {
    return [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL isEqual:url];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithJSONObject:@{} statusCode:500 headers:nil];
    }];
}

#pragma mark - XCTestCase methods

- (void)setUp {
    [super setUp];

    if ([NSFileManager.defaultManager fileExistsAtPath:self.class.cachesPath]) {
        NSError *error;
        if (![NSFileManager.defaultManager removeItemAtPath:self.class.cachesPath error:&error]) {
            JSLogError(@"Error while deleting path:\n\tpath: %@\n\terror: %@", self.class.cachesPath, error);
        }
    }

    NSError *error;
    if (![NSFileManager.defaultManager createDirectoryAtPath:self.class.cachesPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        JSLogError(@"Error while creating directory:\n\tpath: %@\n\terror: %@", self.class.cachesPath, error);
    }
}

#pragma mark - Interface methods

- (void)testLoading {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for image"];

    NSURL *url = [NSURL URLWithString:@"http://sample.com"];
    id <OHHTTPStubsDescriptor> stub = [self stub:url with:@"sample" of:@"png"];

    [self.class.imagesLoader image:url completion:^(UIImage *image, NSURL *imageURL) {
        NSString *samplePath = [[NSBundle bundleForClass:self.class] pathForResource:@"sample" ofType:@"png"];
        UIImage *originalImage = [UIImage imageWithContentsOfFile:samplePath];

        XCTAssertEqualObjects(UIImagePNGRepresentation(image), UIImagePNGRepresentation(originalImage));
        XCTAssertEqualObjects(url, imageURL);

        [OHHTTPStubs removeStub:stub];
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:nil];
}

- (void)testError {
    NSURL *url = [NSURL URLWithString:@"http://sample.com"];

    {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for error"];
        id <OHHTTPStubsDescriptor> stub = [self stubError:url];

        [self.class.imagesLoader image:url completion:^(UIImage *image, NSURL *imageURL) {
            XCTAssertNil(image);

            [OHHTTPStubs removeStub:stub];
            [expectation fulfill];
        }];

        [self waitForExpectationsWithTimeout:0.1 handler:nil];
    }

    {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for image"];
        id <OHHTTPStubsDescriptor> stub = [self stub:url with:@"sample" of:@"png"];

        [self.class.imagesLoader image:url completion:^(UIImage *image, NSURL *imageURL) {
            XCTAssertNotNil(image);

            [OHHTTPStubs removeStub:stub];
            [expectation fulfill];
        }];

        [self waitForExpectationsWithTimeout:0.1 handler:nil];
    }
}

- (void)testCaching {
    NSURL *url = [NSURL URLWithString:@"http://sample.com"];

    {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for image"];
        id <OHHTTPStubsDescriptor> stub = [self stub:url with:@"sample" of:@"png"];

        [self.class.imagesLoader image:url completion:^(UIImage *image, NSURL *imageURL) {
            [OHHTTPStubs removeStub:stub];
            [expectation fulfill];
        }];

        [self waitForExpectationsWithTimeout:0.1 handler:nil];
    }

    {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for cache"];

        [self.class.imagesLoader image:url completion:^(UIImage *image, NSURL *imageURL) {
            NSString *samplePath = [[NSBundle bundleForClass:self.class] pathForResource:@"sample" ofType:@"png"];
            UIImage *originalImage = [UIImage imageWithContentsOfFile:samplePath];

            XCTAssertEqualObjects(UIImagePNGRepresentation(image), UIImagePNGRepresentation(originalImage));

            [expectation fulfill];
        }];

        [self waitForExpectationsWithTimeout:0.1 handler:nil];
    }
}

@end
