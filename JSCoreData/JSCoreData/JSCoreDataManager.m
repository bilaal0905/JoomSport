// Created for BearDev by drif
// drif@mail.ru

@import CoreData;
@import JSUtils.JSLog;

#import "JSCoreDataManager.h"

@implementation JSCoreDataManager {
    NSManagedObjectContext *_backgroundContext;
}

#pragma mark - Interface methods

- (instancetype)initWithModelURL:(NSURL *)modelURL type:(NSString *)type url:(NSURL *)url {
    JSParameterAssert(modelURL);
    JSParameterAssert(type);

    self = [super init];
    if (self) {

        NSPersistentStoreCoordinator *storeCoordinator = ({
            NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
            JSParameterAssert(model);

            NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

            NSError *error;
            NSPersistentStore *store = [coordinator addPersistentStoreWithType:type configuration:nil URL:url options:@{
                    NSMigratePersistentStoresAutomaticallyOption: @YES,
                    NSInferMappingModelAutomaticallyOption: @YES
            } error:&error];

            if (!store) {
                JSLogError(@"Error while creating store\n\terror: %@", error);
            }

            JSParameterAssert(store);
            coordinator;
        });

        _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundContext.persistentStoreCoordinator = storeCoordinator;
    }
    return self;
}

- (NSManagedObjectContext *)mainContext {
    return ({
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        context.parentContext = _backgroundContext;
        context;
    });
}

- (NSManagedObjectContext *)workingContext {
    return ({
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        context.parentContext = _backgroundContext;
        context;
    });
}

@end
