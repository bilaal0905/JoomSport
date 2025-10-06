// Created for BearDev by drif
// drif@mail.ru

@import XCTest;
@import JSCoreData;
@import JSUtils;

#import "JSEntity+CoreDataClass.h"

@interface JSManagedObjectContextTests : XCTestCase

@end

@implementation JSManagedObjectContextTests

#pragma mark - Private methods

+ (JSCoreDataManager *)coreDataManager {
    NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"JSCoreDataTests" withExtension:@"momd"];
    JSOnceSetReturn(JSCoreDataManager *, manager, [[JSCoreDataManager alloc] initWithModelURL:url type:NSInMemoryStoreType url:nil]);
}

#pragma mark - XCTestCase methods

- (void)setUp {
    [super setUp];

    NSManagedObjectContext *context = self.class.coreDataManager.workingContext;
    [context performBlockAndWait:^{

        NSArray *entities = [JSEntity js_all:context];
        for (NSManagedObject *entity in entities) {
            [context deleteObject:entity];
        }

        [context js_saveToStore];
    }];
}

#pragma mark - Interface methods

- (void)testSave {
    NSManagedObjectContext *parentContext = self.class.coreDataManager.workingContext;

    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    childContext.parentContext = parentContext;

    [parentContext performBlockAndWait:^{
        NSArray *entities = [JSEntity js_all:parentContext];
        XCTAssertEqual(entities.count, 0U);
    }];

    [childContext performBlockAndWait:^{
        [JSEntity js_object:childContext where:@"entityId" equals:@"1"];
        [childContext js_save];
    }];

    [parentContext performBlockAndWait:^{
        NSArray *entities = [JSEntity js_all:parentContext];
        XCTAssertEqual(entities.count, 1U);
    }];
}

- (void)testSaveToStore {
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    childContext.parentContext = self.class.coreDataManager.workingContext;

    NSManagedObjectContext *storeContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    storeContext.persistentStoreCoordinator = self.class.coreDataManager.workingContext.parentContext.persistentStoreCoordinator;

    [storeContext performBlockAndWait:^{
        NSArray *entities = [JSEntity js_all:storeContext];
        XCTAssertEqual(entities.count, 0U);
    }];

    [childContext performBlockAndWait:^{
        [JSEntity js_object:childContext where:@"entityId" equals:@"1"];
        [childContext js_saveToStore];
    }];

    [storeContext performBlockAndWait:^{
        NSArray *entities = [JSEntity js_all:storeContext];
        XCTAssertEqual(entities.count, 1U);
    }];
}

@end
