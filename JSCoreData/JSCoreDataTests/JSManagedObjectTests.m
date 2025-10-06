// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSCoreData;
@import JSUtils;

#import "JSEntity+CoreDataClass.h"

@interface JSManagedObjectTests : XCTestCase

@end

@implementation JSManagedObjectTests

#pragma mark - Private methods

+ (JSCoreDataManager *)coreDataManager {
    NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"JSCoreDataTests" withExtension:@"momd"];
    JSOnceSetReturn(JSCoreDataManager *, manager, [[JSCoreDataManager alloc] initWithModelURL:url type:NSInMemoryStoreType url:nil]);
}

#pragma mark - Interface methods

- (void)testFetch {
    NSManagedObjectContext *context = self.class.coreDataManager.workingContext;
    [context performBlockAndWait:^{

        JSEntity *newEntity1 = [JSEntity js_object:context where:@"entityId" equals:@"1"];
        XCTAssertEqualObjects(newEntity1.entityId, @"1");

        JSEntity *newEntity2 = [JSEntity js_object:context where:@"entityId" equals:@"2"];
        XCTAssertEqualObjects(newEntity2.entityId, @"2");

        JSEntity *existingEntity1 = [JSEntity js_object:context where:@"entityId" equals:@"1"];
        XCTAssertEqualObjects(newEntity1.objectID, existingEntity1.objectID);
    }];
}

- (void)testAll {
    NSManagedObjectContext *context = self.class.coreDataManager.workingContext;
    [context performBlockAndWait:^{

        NSDictionary *expectations = @{
                @"1": [self expectationWithDescription:@"Waiting for entity"],
                @"2": [self expectationWithDescription:@"Waiting for entity"],
                @"3": [self expectationWithDescription:@"Waiting for entity"]
        };

        for (NSString *key in expectations.allKeys) {
            [JSEntity js_object:context where:@"entityId" equals:key];
        }

        NSArray *entities = [JSEntity js_all:context];
        XCTAssertEqual(expectations.count, 3U);

        for (JSEntity *entity in entities) {
            NSString *entityId = entity.entityId;
            [expectations[entityId] fulfill];
        }

        [self waitForExpectationsWithTimeout:0.0 handler:nil];
    }];
}

- (void)testNew {
    NSManagedObjectContext *context = self.class.coreDataManager.workingContext;
    [context performBlockAndWait:^{

        JSEntity *newEntity1 = [JSEntity js_new:context];
        XCTAssertNotNil(newEntity1);

        JSEntity *newEntity2 = [JSEntity js_new:context];
        XCTAssertNotEqualObjects(newEntity1.objectID, newEntity2.objectID);
    }];
}

@end
