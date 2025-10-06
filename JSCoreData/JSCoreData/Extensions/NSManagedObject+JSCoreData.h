// Created for BearDev by drif
// drif@mail.ru

@import CoreData;

@interface NSManagedObject (JSCoreData)

+ (NSArray *)js_all:(NSManagedObjectContext *)context;
+ (instancetype)js_new:(NSManagedObjectContext *)context;
+ (instancetype)js_object:(NSManagedObjectContext *)context where:(NSString *)name equals:(NSString *)value;

@end
