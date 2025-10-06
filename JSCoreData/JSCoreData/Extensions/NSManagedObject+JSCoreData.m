// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "NSManagedObject+JSCoreData.h"

@implementation NSManagedObject (JSCoreData)

#pragma mark - Private methods

+ (NSFetchRequest *)js_request:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(self.class)];
    request.predicate = predicate;
    return request;
}

+ (NSArray *)js_execute:(NSFetchRequest *)request in:(NSManagedObjectContext *)context {
    JSParameterAssert(request);
    JSParameterAssert(context);

    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (!objects) {
        JSLogError(@"Error while executing fetch request\n\terror: %@\n\trequest: %@", error, request);
    }

    return objects;
}

#pragma mark - Interface methods

+ (NSArray *)js_all:(NSManagedObjectContext *)context {
    return [self js_execute:[self js_request:nil] in:context];
}

+ (instancetype)js_new:(NSManagedObjectContext *)context {
    JSParameterAssert(context);
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self.class) inManagedObjectContext:context];
}

+ (instancetype)js_object:(NSManagedObjectContext *)context where:(NSString *)name equals:(NSString *)value {
    JSParameterAssert(context);
    JSParameterAssert(name);
    JSParameterAssert(value);

    NSFetchRequest *request = [self js_request:[NSPredicate predicateWithFormat:@"%K == %@", name, value]];
    NSArray *objects = [self js_execute:request in:context];
    JSParameterAssert(objects);
    JSParameterAssert(objects.count <= 1);

    if (objects.firstObject) {
        return objects.firstObject;
    }
    else {
        return ({
            NSEntityDescription *entityDescription = request.entity;
            NSManagedObject *object = [[self alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
            [object setPrimitiveValue:value forKey:name];
            object;
        });
    }
}

@end
