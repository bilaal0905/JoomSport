// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import OHHTTPStubs;
@import JSCore;
@import JSUtils;
@import JSCoreData;
@import JSHTTP;

@interface JSStandingsViewModelTests : XCTestCase

@end

@implementation JSStandingsViewModelTests

#pragma mark - Private methods

+ (JSAPIClient *)apiClient {
    JSOnceSetReturn(JSAPIClient *, apiClient, [[JSAPIClient alloc] initWithType:NSInMemoryStoreType]);
}

+ (JSStandingsViewModel *)standingsViewModel {
    JSOnceSetReturn(JSStandingsViewModel *, viewModel, [[JSStandingsViewModel alloc] initWithAPIClient:self.apiClient]; viewModel.seasonId = @"3");
}

- (void)performRequest:(NSString *)json code:(int)code handler:(void (^)(JSStandingsViewModel *viewModel))handler {

    id <OHHTTPStubsDescriptor> stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://demo.joomsport.com/kodiak-top-menu/component/joomsport/table/3?jsformat=json"];
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
    JSStandingsViewModel *viewModel = self.class.standingsViewModel;

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
    [self performRequest:@"standings" code:200 handler:^(JSStandingsViewModel *viewModel) {
        XCTAssertNil(viewModel.error);

        XCTAssertEqual(viewModel.standings.fields.count, 24U);
        XCTAssertEqualObjects(viewModel.standings.fields.firstObject, @"Points");
        XCTAssertEqualObjects(viewModel.standings.fields.lastObject, @"Manager");
        XCTAssertEqualObjects(viewModel.standings.fields[12], @"Won home");

        XCTAssertEqual(viewModel.standings.groups.count, 2U);

        JSStandingsGroup *group = [viewModel.standings.groups filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSStandingsGroup *object, NSDictionary *bindings) {
            return [object.name isEqualToString:@"Western conference"];
        }]].firstObject;
        XCTAssertEqual(group.records.count, 15U);
        
        JSStandingsRecord *record = [group.records filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSStandingsRecord *object, NSDictionary *bindings) {
            return [object.teamName isEqualToString:@"Colorado"];
        }]].firstObject;
        XCTAssertEqualObjects(record.valuesStrings.firstObject, @"52");
        XCTAssertEqualObjects(record.valuesStrings[7], @"67");
        XCTAssertEqualObjects(record.valuesStrings.lastObject, @"");
    }];
}

- (void)testMerging {
    [self performRequest:@"standings" code:200 handler:nil];

    [self performRequest:@"standings_updated" code:200 handler:^(JSStandingsViewModel *viewModel) {

        XCTAssertEqual(viewModel.standings.groups.count, 1U);
        XCTAssertEqualObjects([viewModel.standings.groups.firstObject name], @"Eastern conference Updated");
        XCTAssertEqual([viewModel.standings.groups.firstObject records].count, 15U);
    }];
}

- (void)testError {
    [self performRequest:nil code:500 handler:^(JSStandingsViewModel *viewModel) {
        XCTAssertEqualObjects(viewModel.error.domain, JSHTTPClientError);
        XCTAssertEqual(viewModel.error.code, JSHTTPClientErrorCodeInternalServerError);
        XCTAssertNil(viewModel.standings);
    }];
}

@end
