// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import OHHTTPStubs;
@import JSCore;
@import JSUtils;
@import JSCoreData;
@import JSHTTP;

@interface JSGameResultsViewModelTests : XCTestCase

@end

@implementation JSGameResultsViewModelTests

#pragma mark - Private methods

+ (JSAPIClient *)apiClient {
    JSOnceSetReturn(JSAPIClient *, apiClient, [[JSAPIClient alloc] initWithType:NSInMemoryStoreType]);
}

+ (JSGameResultsViewModel *)gameResultsViewModel {
    JSOnceSetReturn(JSGameResultsViewModel *, viewModel, [[JSGameResultsViewModel alloc] initWithAPIClient:self.apiClient gameId:@"6864" seasonId:nil]);
}

- (void)performRequest:(NSString *)json code:(int)code handler:(void (^)(JSGameResultsViewModel *viewModel))handler {

    id <OHHTTPStubsDescriptor> stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://demo.joomsport.com/kodiak-top-menu/component/joomsport/match/6864?jsformat=json"];
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
    JSGameResultsViewModel *viewModel = self.class.gameResultsViewModel;

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
            [season performSelector:@selector(addGamesObject:) withObject:({
                id game = [NSClassFromString(@"JSGameEntity") js_object:context where:@"gameId" equals:@"6864"];
                [game performSelector:@selector(setStatus:) withObject:@"1"];
                [game performSelector:@selector(setHome:) withObject:({
                    id team = [NSClassFromString(@"JSGameTeamEntity") js_new:context];
                    [team performSelector:@selector(setLogoURL:) withObject:@"http://ya.ru"];
                    [team performSelector:@selector(setName:) withObject:@"team"];
                    [team performSelector:@selector(setTeamId:) withObject:@"1"];
                    team;
                })];
                [game performSelector:@selector(setAway:) withObject:[game performSelector:@selector(home)]];
                game;
            })];
            season;
        })];

        [context js_saveToStore];
    }];
}

#pragma mark - Interface methods

- (void)testLoading {
    [self performRequest:@"match" code:200 handler:^(JSGameResultsViewModel *viewModel) {
        XCTAssertNil(viewModel.error);

        XCTAssertEqual(viewModel.game.status, JSGameStatusPlayed);
        XCTAssertEqualObjects(viewModel.game.venue, @"Emirates Stadium");
        XCTAssertEqualObjects(viewModel.game.stages, (@[@"2 - 1", @"1 - 2"]));

        XCTAssertEqual(viewModel.events.count, 9U);
        XCTAssertEqualObjects([(JSGameEvent *) viewModel.events.firstObject minute], @2);
        XCTAssertFalse([(JSGameEvent *) viewModel.events.lastObject isHome]);
        XCTAssertEqualObjects([(JSGameEvent *) viewModel.events.lastObject minute], @90);

        XCTAssertEqualObjects([viewModel.statistics.firstObject title], @"Attempts on target");
        XCTAssertEqualObjects([viewModel.statistics.firstObject home], @"20");
        XCTAssertTrue(ABS([viewModel.statistics.firstObject homeValue] - 20.0 / 53.0) < DBL_EPSILON);
        XCTAssertEqualObjects([viewModel.statistics.lastObject title], @"Corner");
    }];
}

- (void)testMerging {
    [self performRequest:@"match" code:200 handler:nil];

    [self performRequest:@"match_updated" code:200 handler:^(JSGameResultsViewModel *viewModel) {

        XCTAssertEqualObjects(viewModel.game.venue, @"New Trafford");
        XCTAssertNil(viewModel.game.stages);
        XCTAssertEqual(viewModel.statistics.count, 0U);

        XCTAssertEqual(viewModel.events.count, 3U);
        XCTAssertEqualObjects([(JSGameEvent *) viewModel.events.firstObject minute], @2);
        XCTAssertTrue([(JSGameEvent *) viewModel.events.firstObject isHome]);
        XCTAssertEqualObjects([(JSGameEvent *) viewModel.events.lastObject minute], @80);
    }];
}

- (void)testError {
    [self performRequest:nil code:500 handler:^(JSGameResultsViewModel *viewModel) {
        XCTAssertEqualObjects(viewModel.error.domain, JSHTTPClientError);
        XCTAssertEqual(viewModel.error.code, JSHTTPClientErrorCodeInternalServerError);
        XCTAssertNil(viewModel.game.venue);
        XCTAssertEqual(viewModel.events.count, 0U);
    }];
}

@end
