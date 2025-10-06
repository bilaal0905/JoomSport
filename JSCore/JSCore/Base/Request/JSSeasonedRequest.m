// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSSeasonedRequest.h"

@implementation JSSeasonedRequest {
    NSString *_seasonId;
}

#pragma mark - Interface methods

- (instancetype)initWithPath:(NSString *)path seasonId:(NSString *)seasonId coreDataManager:(JSCoreDataManager *)coreDataManager {
    JSParameterAssert(seasonId);

    self = [super initWithPath:path coreDataManager:coreDataManager];
    if (self) {
        _seasonId = seasonId.copy;
    }
    return self;
}

- (NSString *)seasonId {
    return _seasonId;
}

@end
