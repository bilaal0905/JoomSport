// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSModelsStore;

@interface JSRouter : NSObject

- (instancetype)initWithModelsStore:(JSModelsStore *)modelsStore;
- (UIViewController *)rootViewController;
- (void)open:(NSString *)gameId of:(NSString *)seasonId;

@end
