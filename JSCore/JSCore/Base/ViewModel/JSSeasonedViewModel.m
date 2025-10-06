// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSSeasonedViewModel.h"
#import "JSSeasonedRequest.h"

@implementation JSSeasonedViewModel

#pragma mark - JSViewModel methods

- (void)update {
    if (!self.seasonId) {
        return;
    }

    [super update];
}

- (BOOL)skip:(JSRequest *)request {
    JSParameterAssert([request isKindOfClass:JSSeasonedRequest.class]);

    JSSeasonedRequest *seasonedRequest = (JSSeasonedRequest *) request;
    return ![seasonedRequest.seasonId isEqualToString:self.seasonId];
}

#pragma mark - Interface methods

- (void)setSeasonId:(NSString *)seasonId {
    JSParameterAssert(seasonId);

    if ([_seasonId isEqualToString:seasonId]) {
        return;
    }

    _seasonId = seasonId.copy;

    [self cancel];
    [self reset];
    [self invalidate];
}

- (void)reset {}

@end
