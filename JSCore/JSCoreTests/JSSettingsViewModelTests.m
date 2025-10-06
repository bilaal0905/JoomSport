// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSCoreData;
@import JSUtils;
@import JSCore;

@interface JSSettingsViewModelTestsStub : NSObject

@property (nonatomic, strong) NSString *teamId;

@end

@implementation JSSettingsViewModelTestsStub

@end

@interface JSSettingsViewModelTests : XCTestCase

@end

@implementation JSSettingsViewModelTests

#pragma mark - Private methods

+ (JSAPIClient *)apiClient {
    JSOnceSetReturn(JSAPIClient *, apiClient, [[JSAPIClient alloc] initWithType:NSInMemoryStoreType]);
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
            [season performSelector:@selector(setStandings:) withObject:({
                id standings = [NSClassFromString(@"JSStandingsEntity") js_new:context];
                [standings performSelector:@selector(addGroupsObject:) withObject:({
                    id group = [NSClassFromString(@"JSStandingsGroupEntity") js_new:context];
                    [group setName:@"Group"];
                    [group performSelector:@selector(addRecordsObject:) withObject:({
                        id record = [NSClassFromString(@"JSStandingsRecordEntity") js_new:context];
                        [record setValue:@(1) forKeyPath:@"rank"];
                        [record setValue:@"1" forKeyPath:@"teamId"];
                        [record setValue:@"http://ya.ru" forKeyPath:@"teamLogoURL"];
                        [record setValue:@"name" forKeyPath:@"teamName"];
                        [record setValue:[[NSData alloc] init] forKeyPath:@"values"];
                        [record setValue:[[NSData alloc] init] forKeyPath:@"valuesStrings"];
                        record;
                    })];
                    [group performSelector:@selector(addRecordsObject:) withObject:({
                        id record = [NSClassFromString(@"JSStandingsRecordEntity") js_new:context];
                        [record setValue:@(1) forKeyPath:@"rank"];
                        [record setValue:@"2" forKeyPath:@"teamId"];
                        [record setValue:@"http://ya.ru" forKeyPath:@"teamLogoURL"];
                        [record setValue:@"name" forKeyPath:@"teamName"];
                        [record setValue:[[NSData alloc] init] forKeyPath:@"values"];
                        [record setValue:[[NSData alloc] init] forKeyPath:@"valuesStrings"];
                        record;
                    })];
                    [group performSelector:@selector(addRecordsObject:) withObject:({
                        id record = [NSClassFromString(@"JSStandingsRecordEntity") js_new:context];
                        [record setValue:@(1) forKeyPath:@"rank"];
                        [record setValue:@"2" forKeyPath:@"teamId"];
                        [record setValue:@"http://ya.ru" forKeyPath:@"teamLogoURL"];
                        [record setValue:@"name" forKeyPath:@"teamName"];
                        [record setValue:[[NSData alloc] init] forKeyPath:@"values"];
                        [record setValue:[[NSData alloc] init] forKeyPath:@"valuesStrings"];
                        record;
                    })];
                    group;
                })];
                standings;
            })];
            season;
        })];

        [context js_saveToStore];
    }];

    [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"JSSettingsViewModelKeyNotifications"];
    [NSUserDefaults.standardUserDefaults setObject:nil forKey:@"JSSettingsViewModelKeyNotificationsTeams"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

#pragma mark - Interface methods

- (void)testTeams {
    JSSettingsViewModel *model = [[JSSettingsViewModel alloc] initWithAPIClient:self.class.apiClient];
    XCTAssertEqual(model.teams.count, 2U);
}

- (void)testNotifications {
    JSTeam *team1 = (id) ({
        JSSettingsViewModelTestsStub *stub = [[JSSettingsViewModelTestsStub alloc] init];
        stub.teamId = @"1";
        stub;
    });

    JSTeam *team2 = (id) ({
        JSSettingsViewModelTestsStub *stub = [[JSSettingsViewModelTestsStub alloc] init];
        stub.teamId = @"2";
        stub;
    });

    JSSettingsViewModel *model1 = [[JSSettingsViewModel alloc] initWithAPIClient:self.class.apiClient];
    model1.notificationsEnabled = YES;
    [model1 setNotificationsEnabled:YES for:team1];
    [model1 setNotificationsEnabled:YES for:team2];

    JSSettingsViewModel *model2 = [[JSSettingsViewModel alloc] initWithAPIClient:self.class.apiClient];
    XCTAssertTrue(model2.notificationsEnabled);
    XCTAssertTrue([model2 notificationsEnabled:team1]);
    XCTAssertTrue([model2 notificationsEnabled:team2]);

    model1.notificationsEnabled = NO;
    [model1 setNotificationsEnabled:NO for:team1];

    model2 = [[JSSettingsViewModel alloc] initWithAPIClient:self.class.apiClient];
    XCTAssertFalse(model2.notificationsEnabled);
    XCTAssertFalse([model2 notificationsEnabled:team1]);
    XCTAssertTrue([model2 notificationsEnabled:team2]);
}

@end
