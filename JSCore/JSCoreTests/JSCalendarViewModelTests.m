// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import OHHTTPStubs;
@import JSCore;
@import JSUtils;
@import JSCoreData;
@import JSHTTP;

@interface JSCalendarViewModelTests : XCTestCase

@end

@implementation JSCalendarViewModelTests

#pragma mark - Private methods

+ (JSAPIClient *)apiClient {
    JSOnceSetReturn(JSAPIClient *, apiClient, [[JSAPIClient alloc] initWithType:NSInMemoryStoreType]);
}

+ (JSCalendarViewModel *)calendarViewModel {
    JSOnceSetReturn(JSCalendarViewModel *, viewModel, [[JSCalendarViewModel alloc] initWithAPIClient:self.apiClient]; viewModel.seasonId = @"3");
}

- (void)performRequest:(NSString *)json code:(int)code handler:(void (^)(JSCalendarViewModel *viewModel))handler {

    id <OHHTTPStubsDescriptor> stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://demo.joomsport.com/kodiak-top-menu/component/joomsport/calendar/3?jsformat=json"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        if (json) {
            NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:json withExtension:@"json"];
            return [OHHTTPStubsResponse responseWithFileURL:url statusCode:code headers:nil];
        }
        else {
            return [OHHTTPStubsResponse responseWithJSONObject:@{} statusCode:code headers:nil];
        }
    }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for parsing"];
    JSCalendarViewModel *viewModel = self.class.calendarViewModel;

    __unused JSKeyPathObserver *observer = [JSKeyPathObserver observerFor:viewModel keyPath:@"isUpdating" handler:^{
        if (!viewModel.isUpdating) {
            JSBlock(handler, viewModel);
            [expectation fulfill];
        }
    }];

    XCTAssertFalse(viewModel.isUpdating);
    [viewModel update];
    XCTAssertTrue(viewModel.isUpdating);

    [self waitForExpectationsWithTimeout:0.1 handler:nil];

    [OHHTTPStubs removeStub:stub];
}

#pragma mark - XCTestCase methods

- (void)setUp {
    [super setUp];

    NSManagedObjectContext *context = self.class.apiClient.coreDataManager.workingContext;
    [context performBlockAndWait:^{

        NSArray *tournaments = [NSClassFromString(@"JSTournamentEntity") js_all:context];
        for (NSManagedObject *entity in tournaments) {
            [context deleteObject:entity];
        }

        id tournament = [NSClassFromString(@"JSTournamentEntity") js_object:context where:@"tournamentId" equals:@"3"];
        [tournament setName:@"Tournament 3"];
        [tournament performSelector:@selector(addSeasonsObject:) withObject:({
            id season = [NSClassFromString(@"JSSeasonEntity") js_object:context where:@"seasonId" equals:@"3"];
            [season setName:@"Season 3"];
            season;
        })];

        [context js_saveToStore];
    }];
}

#pragma mark - Interface methods

- (void)testLoading {
    [self performRequest:@"calendar" code:200 handler:^(JSCalendarViewModel *viewModel) {
        XCTAssertNil(viewModel.error);

        XCTAssertEqual(viewModel.games.count, 37U);
        XCTAssertEqualObjects([viewModel.games.firstObject home].name, @"Manchester City");
        XCTAssertEqualObjects([viewModel.games.lastObject home].name, @"Liverpool");

        JSGame *game = viewModel.games.lastObject;
        XCTAssertEqual(game.status, JSGameStatusPlayed);
        XCTAssertEqualObjects(game.away.score, @"2");
    }];
}

- (void)testMerging {
    [self performRequest:@"calendar" code:200 handler:nil];

    [self performRequest:@"calendar_updated" code:200 handler:^(JSCalendarViewModel *viewModel) {

        XCTAssertEqual(viewModel.games.count, 2U);
        XCTAssertEqualObjects([viewModel.games.firstObject home].name, @"Manchester City");
        XCTAssertEqualObjects([viewModel.games.lastObject home].name, @"Chelsea");

        XCTAssertEqual(viewModel.participants.count, 3U);
        XCTAssertEqualObjects([viewModel.participants[0] name], @"Arsenal");
        XCTAssertEqualObjects([viewModel.participants[1] name], @"Chelsea");
        XCTAssertEqualObjects([viewModel.participants[2] name], @"Manchester City");
    }];
}

- (void)testError {
    [self performRequest:nil code:500 handler:^(JSCalendarViewModel *viewModel) {
        XCTAssertEqualObjects(viewModel.error.domain, JSHTTPClientError);
        XCTAssertEqual(viewModel.error.code, JSHTTPClientErrorCodeInternalServerError);
        XCTAssertEqual(viewModel.games.count, 0U);
    }];
}

@end
