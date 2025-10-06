// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import OHHTTPStubs;
@import JSCore;
@import JSUtils;
@import JSCoreData;
@import JSHTTP;

@interface JSSeasonsViewModelTests : XCTestCase

@end

@implementation JSSeasonsViewModelTests

#pragma mark - Private methods

+ (JSAPIClient *)apiClient {
    JSOnceSetReturn(JSAPIClient *, apiClient, [[JSAPIClient alloc] initWithType:NSInMemoryStoreType]);
}

+ (JSSeasonsViewModel *)seasonsViewModel {
    JSOnceSetReturn(JSSeasonsViewModel *, viewModel, [[JSSeasonsViewModel alloc] initWithAPIClient:self.apiClient]);
}

- (void)performRequest:(NSString *)json code:(int)code handler:(void (^)(JSSeasonsViewModel *viewModel))handler {

    id <OHHTTPStubsDescriptor> stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://demo.joomsport.com/kodiak-top-menu/index.php?task=seasonlist&jsformat=json"];
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
    JSSeasonsViewModel *viewModel = self.class.seasonsViewModel;

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

- (void)checkTournamentsLoaded:(JSSeasonsViewModel *)viewModel {
    XCTAssertEqual(viewModel.tournaments.count, 4U);

    JSTournament *tournament = [viewModel.tournaments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSTournament *object, NSDictionary *bindings) {
        return [object.tournamentId isEqualToString:@"5"];
    }]].firstObject;
    XCTAssertEqualObjects(tournament.name, @"NHL");
}

- (void)checkTournamentsMerged:(JSSeasonsViewModel *)viewModel {
    XCTAssertEqual(viewModel.tournaments.count, 4U);

    JSTournament *deletedTournament = [viewModel.tournaments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSTournament *object, NSDictionary *bindings) {
        return [object.tournamentId isEqualToString:@"5"];
    }]].firstObject;
    XCTAssertNil(deletedTournament);

    JSTournament *addedTournament = [viewModel.tournaments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSTournament *object, NSDictionary *bindings) {
        return [object.tournamentId isEqualToString:@"10"];
    }]].firstObject;
    XCTAssertEqualObjects(addedTournament.name, @"Added Tournament");

    JSTournament *updatedTournament = [viewModel.tournaments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSTournament *object, NSDictionary *bindings) {
        return [object.tournamentId isEqualToString:@"9"];
    }]].firstObject;
    XCTAssertEqualObjects(updatedTournament.name, @"Updated Tournament");
}

- (void)checkSeasonsLoaded:(JSSeasonsViewModel *)viewModel {

    JSTournament *tournament = [viewModel.tournaments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSTournament *object, NSDictionary *bindings) {
        return [object.tournamentId isEqualToString:@"2"];
    }]].firstObject;

    XCTAssertEqual(tournament.seasons.count, 2U);

    XCTAssertTrue([[tournament.seasons[0] seasonId] isEqualToString:@"2"]);
    XCTAssertTrue([[tournament.seasons[0] name] isEqualToString:@"2010-2011"]);

    XCTAssertTrue([[tournament.seasons[1] seasonId] isEqualToString:@"4"]);
    XCTAssertTrue([[tournament.seasons[1] name] isEqualToString:@"2009-2010"]);
}

- (void)checkSeasonsMerged:(JSSeasonsViewModel *)viewModel {

    JSTournament *tournamentWithDeletion = [viewModel.tournaments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSTournament *object, NSDictionary *bindings) {
        return [object.tournamentId isEqualToString:@"2"];
    }]].firstObject;

    XCTAssertEqual(tournamentWithDeletion.seasons.count, 1U);

    JSTournament *tournamentWithAdding = [viewModel.tournaments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSTournament *object, NSDictionary *bindings) {
        return [object.tournamentId isEqualToString:@"1"];
    }]].firstObject;

    XCTAssertEqual(tournamentWithAdding.seasons.count, 2U);
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

        [context js_saveToStore];
    }];
}

#pragma mark - Interface methods

- (void)testLoading {
    [self performRequest:@"seasons" code:200 handler:^(JSSeasonsViewModel *viewModel) {
        XCTAssertNil(viewModel.error);

        [self checkTournamentsLoaded:viewModel];
        [self checkSeasonsLoaded:viewModel];
    }];
}

- (void)testMerging {
    [self performRequest:@"seasons" code:200 handler:nil];
    
    [self performRequest:@"seasons_updated" code:200 handler:^(JSSeasonsViewModel *viewModel) {
        [self checkTournamentsMerged:viewModel];
        [self checkSeasonsMerged:viewModel];
    }];
}

- (void)testError {
    [self performRequest:nil code:500 handler:^(JSSeasonsViewModel *viewModel) {
        XCTAssertEqualObjects(viewModel.error.domain, JSHTTPClientError);
        XCTAssertEqual(viewModel.error.code, JSHTTPClientErrorCodeInternalServerError);
        XCTAssertEqual(viewModel.tournaments.count, 0U);
    }];
}

@end
