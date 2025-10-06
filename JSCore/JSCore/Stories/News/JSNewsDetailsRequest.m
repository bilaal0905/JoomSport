// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;

#import "JSNewsDetailsRequest.h"
#import "JSNewsEntity+CoreDataClass.h"

@implementation JSNewsDetailsRequest {
    NSString *_newsId;
}

#pragma mark - JSRequest methods

- (void)map:(NSDictionary *)json from:(NSData *)data in:(NSManagedObjectContext *)context {
    [super map:json from:data in:context];

    JSNewsEntity *news = [JSNewsEntity js_object:context where:@"newsId" equals:[NSString stringWithFormat: @"%@", json[@"id"]]];
    news.text = json[@"introtext"];
}

#pragma mark - Interface methods

- (instancetype)initWithId:(NSString *)newsId coreDataManager:(JSCoreDataManager *)coreDataManager {
    JSParameterAssert(newsId);

    self = [self initWithPath:@"index.php" coreDataManager:coreDataManager extraParams:@{
            @"option": @"com_joomsport",
            @"task": @"getNewsItem",
            @"controller": @"aws",
            @"id": newsId
    }];
    if (self) {
        _newsId = newsId;
    }
    return self;
}

- (NSString *)newsId {
    return _newsId;
}

@end
