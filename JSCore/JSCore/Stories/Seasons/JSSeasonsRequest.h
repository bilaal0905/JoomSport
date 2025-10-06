// Created for BearDev by drif
// drif@mail.ru

#import "JSRequest.h"

@class JSCoreDataManager;

extern NSString *const JSSeasonsRequestDefaultSeasonIdKey;
extern NSString *const JSSeasonsRequestDefaultTeamIdKey;

@interface JSSeasonsRequest : JSRequest

- (instancetype)initWithCoreDataManager:(JSCoreDataManager *)coreDataManager;

@end
