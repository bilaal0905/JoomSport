// Created for BearDev by drif
// drif@mail.ru

@import JSCoreData.NSManagedObject_JSCoreData;
@import JSUtils.JSLog;

#import "JSNewsDetailsViewModel.h"
#import "JSNews.h"
#import "JSNewsEntity+CoreDataClass.h"
#import "JSNewsDetailsRequest.h"

@interface JSNewsDetailsViewModel ()

@property (nonatomic, strong, readwrite) JSNews *news;

@end


@implementation JSNewsDetailsViewModel {
    NSString *_newsId;
}

#pragma mark - JSViewModel methods

- (void)initData:(NSManagedObjectContext *)context {
    if (_newsId.length == 0) {
        self.news = nil;
    }
    else {
        self.news = [[JSNews alloc] initWithEntity:[JSNewsEntity js_object:context where:@"newsId" equals:_newsId]];
    }
}

- (void)update {
    if (!_newsId) {
        return;
    }

    [super update];
}

- (BOOL)skip:(JSRequest *)request {
    BOOL skip = [super skip:request];
    if (skip) {
        return skip;
    }

    JSParameterAssert([request isKindOfClass:JSNewsDetailsRequest.class]);

    JSNewsDetailsRequest *newsRequest = (JSNewsDetailsRequest *) request;
    return ![newsRequest.newsId isEqualToString:_newsId];
}

- (JSRequest *)request:(JSCoreDataManager *)coreDataManager {
    return [[JSNewsDetailsRequest alloc] initWithId:_newsId coreDataManager:coreDataManager];
}

#pragma mark - Interface methods

- (void)setNewsId:(NSString *)newsId {
    JSParameterAssert(newsId);

    if ([_newsId isEqualToString:newsId]) {
        return;
    }
    _newsId = newsId.copy;

    [self cancel];
    [self invalidate];
}

@end
