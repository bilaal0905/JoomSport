// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import OHHTTPStubs;
@import JSCore;
@import JSUtils;
@import JSCoreData;
@import JSHTTP;

@interface JSTeamViewModelTests : XCTestCase

@end

@implementation JSTeamViewModelTests

#pragma mark - Private methods

+ (JSAPIClient *)apiClient {
    JSOnceSetReturn(JSAPIClient *, apiClient, [[JSAPIClient alloc] initWithType:NSInMemoryStoreType]);
}

+ (JSTeamViewModel *)teamViewModel {
    JSOnceSetReturn(JSTeamViewModel *, viewModel, [[JSTeamViewModel alloc] initWithAPIClient:self.apiClient]; viewModel.seasonId = @"2"; viewModel.teamId = @"4");
}

- (void)performRequest:(NSString *)json code:(int)code handler:(void (^)(JSTeamViewModel *viewModel))handler {

    id <OHHTTPStubsDescriptor> stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://demo.joomsport.com/kodiak-top-menu/component/joomsport/team/2/4?jsformat=json"];
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
    JSTeamViewModel *viewModel = self.class.teamViewModel;

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
            id season = [NSClassFromString(@"JSSeasonEntity") js_object:context where:@"seasonId" equals:@"2"];
            [season setName:@"Season 2"];
            [season performSelector:@selector(addGamesObject:) withObject:({
                id game = [NSClassFromString(@"JSGameEntity") js_object:context where:@"gameId" equals:@"6864"];
                [game performSelector:@selector(setStatus:) withObject:@"1"];
                [game performSelector:@selector(setHome:) withObject:({
                    id team = [NSClassFromString(@"JSGameTeamEntity") js_new:context];
                    [team performSelector:@selector(setLogoURL:) withObject:@"http://ya.ru"];
                    [team performSelector:@selector(setName:) withObject:@"team 4"];
                    [team performSelector:@selector(setTeamId:) withObject:@"4"];
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

- (void)testPreloading {
    self.class.teamViewModel.teamId = @"1";
    self.class.teamViewModel.teamId = @"4";

    XCTAssertEqualObjects(self.class.teamViewModel.team.name, @"team 4");
    XCTAssertEqualObjects(self.class.teamViewModel.team.logoURL, [NSURL URLWithString:@"http://ya.ru"]);
}

- (void)testLoading {
    [self performRequest:@"team" code:200 handler:^(JSTeamViewModel *viewModel) {
        XCTAssertNil(viewModel.error);

        XCTAssertEqualObjects(viewModel.team.name, @"Chelsea");
        XCTAssertEqualObjects(viewModel.team.logoURL, [NSURL URLWithString:@"http://demo.joomsport.com/kodiak-top-menu/media/bearleague/thumb/bl1436536967508.png"]);
        XCTAssertNotNil(viewModel.team.info);

        XCTAssertEqualObjects([viewModel.team.extras.firstObject name], @"City");
        XCTAssertEqualObjects([(JSExtraInfo *) viewModel.team.extras.firstObject value], @"London");

        XCTAssertEqual(viewModel.team.players.count, 11U);
        XCTAssertEqualObjects([viewModel.team.players.firstObject name], @"Alex  ");
    }];
}

- (void)testMerging {
    [self performRequest:@"team" code:200 handler:nil];

    [self performRequest:@"team_updated" code:200 handler:^(JSTeamViewModel *viewModel) {

        XCTAssertEqualObjects(viewModel.team.name, @"Chelsea");
        XCTAssertEqualObjects(viewModel.team.logoURL, [NSURL URLWithString:@"http://demo.joomsport.com/kodiak-top-menu/media/bearleague/thumb/bl1436536967508.png"]);
        XCTAssertEqualObjects(viewModel.team.info, @"");

        XCTAssertEqualObjects([viewModel.team.extras.firstObject name], @"City");
        XCTAssertEqualObjects([(JSExtraInfo *) viewModel.team.extras.firstObject value], @"Roma");
        XCTAssertEqualObjects([viewModel.team.extras.lastObject name], @"Country");
        XCTAssertEqualObjects([(JSExtraInfo *) viewModel.team.extras.lastObject value], @"Italy");

        XCTAssertEqual(viewModel.team.players.count, 1U);
        XCTAssertEqualObjects([viewModel.team.players.firstObject name], @"Didier Drogba 2");
    }];
}

- (void)testError {
    [self performRequest:nil code:500 handler:^(JSTeamViewModel *viewModel) {
        XCTAssertEqualObjects(viewModel.error.domain, JSHTTPClientError);
        XCTAssertEqual(viewModel.error.code, JSHTTPClientErrorCodeInternalServerError);

        XCTAssertEqualObjects(viewModel.team.name, @"team 4");
        XCTAssertEqualObjects(viewModel.team.logoURL, [NSURL URLWithString:@"http://ya.ru"]);
    }];
}

@end
