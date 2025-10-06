// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class NSManagedObjectContext;

@interface JSCoreDataManager : NSObject

- (instancetype)initWithModelURL:(NSURL *)modelURL type:(NSString *)type url:(NSURL *)url;

- (NSManagedObjectContext *)mainContext;
- (NSManagedObjectContext *)workingContext;

@end
