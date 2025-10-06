// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "NSManagedObjectContext+JSCoreData.h"

@implementation NSManagedObjectContext (JSCoreData)

#pragma mark - Interface methods

- (void)js_save {
    NSError *error;
    if (![self save:&error]) {
        JSLogError(@"Error while saving context\n\terror: %@\n\tcontext: %@", error, self);
    }
}

- (void)js_saveToStore {
    [self js_save];
    [self.parentContext performBlockAndWait:^{
        [self.parentContext js_saveToStore];
    }];
}

@end
