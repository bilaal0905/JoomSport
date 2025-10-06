// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import OHHTTPStubs;
@import JSCore;
@import JSUtils;
@import JSCoreData;
@import JSHTTP;

@interface JSPlayerViewModelTests : XCTestCase

@end

@implementation JSPlayerViewModelTests

#pragma mark - Private methods

+ (JSAPIClient *)apiClient {
    JSOnceSetReturn(JSAPIClient *, apiClient, [[JSAPIClient alloc] initWithType:NSInMemoryStoreType]);
}

+ (JSPlayerViewModel *)playerViewModel {
    JSOnceSetReturn(JSPlayerViewModel *, viewModel, [[JSPlayerViewModel alloc] initWithAPIClient:self.apiClient]; viewModel.seasonId = @"2"; viewModel.playerId = @"1173");
}

- (void)performRequest:(NSString *)json code:(int)code handler:(void (^)(JSPlayerViewModel *viewModel))handler {

    id <OHHTTPStubsDescriptor> stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://demo.joomsport.com/kodiak-top-menu/component/joomsport/player/2/1173?jsformat=json"];
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
    JSPlayerViewModel *viewModel = self.class.playerViewModel;

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
            [season performSelector:@selector(addTeamsObject:) withObject:({
                id team = [NSClassFromString(@"JSTeamEntity") js_new:context];
                [team performSelector:@selector(setLogoURL:) withObject:@"http://ya.ru"];
                [team performSelector:@selector(setName:) withObject:@"team 4"];
                [team performSelector:@selector(setCompetitorId:) withObject:@"4"];
                [team performSelector:@selector(setInfo:) withObject:@""];
                [team performSelector:@selector(addPlayersObject:) withObject:({
                    id player = [NSClassFromString(@"JSTeamPlayerEntity") js_new:context];
                    [player performSelector:@selector(setLogoURL:) withObject:@"http://ya.ru"];
                    [player performSelector:@selector(setName:) withObject:@"Didier Drogba"];
                    [player performSelector:@selector(setCompetitorId:) withObject:@"1173"];
                    player;
                })];
                team;
            })];
            season;
        })];

        [context js_saveToStore];
    }];
}

#pragma mark - Interface methods

- (void)testPreloading {
    self.class.playerViewModel.playerId = @"1174";
    self.class.playerViewModel.playerId = @"1173";

    XCTAssertEqualObjects(self.class.playerViewModel.player.name, @"Didier Drogba");
    XCTAssertEqualObjects(self.class.playerViewModel.player.photoURL, [NSURL URLWithString:@"http://ya.ru"]);
}

- (void)testLoading {
    [self performRequest:@"player" code:200 handler:^(JSPlayerViewModel *viewModel) {
        XCTAssertNil(viewModel.error);

        XCTAssertEqualObjects(viewModel.player.name, @"Didier Drogba");
        XCTAssertEqualObjects(viewModel.player.photoURL, [NSURL URLWithString:@"http://ya.ru"]);
        XCTAssertEqualObjects(viewModel.player.info, @"");

        XCTAssertEqualObjects([viewModel.player.extras.firstObject name], @"Birth");
        XCTAssertEqualObjects([(JSExtraInfo *) viewModel.player.extras.firstObject value], @"11/03/1978");

        XCTAssertEqualObjects([viewModel.player.extras.lastObject name], @"Country");
        XCTAssertEqualObjects([(JSExtraInfo *) viewModel.player.extras.lastObject imageURL], [NSURL URLWithString:@"http://demo.joomsport.com/kodiak-top-menu/components/com_joomsport/img/flags/ci.png"]);
    }];
}

- (void)testMerging {
    [self performRequest:@"player" code:200 handler:nil];

    [self performRequest:@"player_updated" code:200 handler:^(JSPlayerViewModel *viewModel) {

        XCTAssertEqualObjects(viewModel.player.name, @"Didier Drogba");
        XCTAssertEqualObjects(viewModel.player.photoURL, [NSURL URLWithString:@"http://ya.ru"]);
        XCTAssertEqualObjects(viewModel.player.info, @"Good player");

        XCTAssertEqual(viewModel.player.extras.count, 1U);
        XCTAssertEqualObjects([viewModel.player.extras.firstObject name], @"Birth");
        XCTAssertEqualObjects([(JSExtraInfo *) viewModel.player.extras.firstObject value], @"11/03/1998");
    }];
}

- (void)testError {
    [self performRequest:nil code:500 handler:^(JSPlayerViewModel *viewModel) {
        XCTAssertEqualObjects(viewModel.error.domain, JSHTTPClientError);
        XCTAssertEqual(viewModel.error.code, JSHTTPClientErrorCodeInternalServerError);

        XCTAssertEqualObjects(viewModel.player.name, @"Didier Drogba");
        XCTAssertEqualObjects(viewModel.player.photoURL, [NSURL URLWithString:@"http://ya.ru"]);
    }];
}

@end
