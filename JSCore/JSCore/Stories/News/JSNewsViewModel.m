// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;
@import JSHTTP.JSHTTPClient;

#import "JSNews.h"
#import "JSNewsViewModel.h"
#import "JSNewsRequest.h"
#import "JSAPIClient.h"
#import "JSNewsEntity+CoreDataClass.h"

@interface JSNewsViewModel ()

@property (nonatomic, copy, readwrite) NSArray *news;

@end

@implementation JSNewsViewModel {
    NSString *_base;
}

#pragma mark - JSViewModel methods

- (void)initData:(NSManagedObjectContext *)context {
    [super initData:context];

    NSArray *entities = [JSNewsEntity js_all:context];

    self.news = [[[entities sortedArrayUsingComparator:^NSComparisonResult(JSNewsEntity *news1, JSNewsEntity *news2) {
        return [news2.newsId compare:(NSString * _Nonnull) news1.newsId];
    }] sortedArrayUsingComparator:^NSComparisonResult(JSNewsEntity *news1, JSNewsEntity *news2) {
        return [news2.date compare:(NSDate * _Nonnull) news1.date];
    }] js_map:^JSNews *(JSNewsEntity *newsEntity) {
        return [[JSNews alloc] initWithEntity:newsEntity];
    }];
}

- (JSRequest *)request:(JSCoreDataManager *)coreDataManager {
    return [[JSNewsRequest alloc] initWithCoreDataManager:coreDataManager base:_base];
}

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient {
    self = [super initWithAPIClient:apiClient];
    if (self) {
        _base = apiClient.httpClient.base;
    }
    return self;
}

@end
