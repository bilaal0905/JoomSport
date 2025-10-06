// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;

#import "JSNewsRequest.h"
#import "JSNewsEntity+CoreDataClass.h"

@implementation JSNewsRequest {
    NSURL *_base;
}

#pragma mark - Private methods

+ (NSDate *)date:(NSString *)dateString {
    JSOnceSet(NSDateFormatter *, formatter, [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter.dateFormat = @"y-M-d H:m:s";
    );
    return [formatter dateFromString:dateString];
}

+ (NSDictionary *)images:(NSDictionary *)news {
    NSError *error;
    NSData *data = [news[@"images"] dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions) 0 error:&error];
    if (!jsonObject) {
        JSLogError(@"Error while parsing news images json data\n\terror: %@\n\news: %@", error, news);
        return nil;
    }
    return jsonObject;
}

#pragma mark - JSRequest methods

- (void)map:(NSDictionary *)json from:(NSData *)data in:(NSManagedObjectContext *)context {
    [super map:json from:data in:context];

    NSMutableSet *ids = [[NSMutableSet alloc] init];
    for (NSDictionary *newsDict in json[@"root"]) {
        [ids addObject:(NSString * _Nonnull) newsDict[@"id"]];

        NSDictionary *images = [self.class images:newsDict];

        JSNewsEntity *news = [JSNewsEntity js_object:context where:@"newsId" equals:newsDict[@"id"]];
        news.date = [self.class date:newsDict[@"publish_up"]];
        news.title = newsDict[@"title"];

        if (images[@"image_intro"]) {
            news.previewImageURL =  [_base URLByAppendingPathComponent:(NSString * _Nonnull) images[@"image_intro"]].absoluteString;
        }
        else {
            news.previewImageURL = nil;
        }

        if (images[@"image_fulltext"]) {
            news.imageURL = [_base URLByAppendingPathComponent:(NSString * _Nonnull) images[@"image_fulltext"]].absoluteString;
        }
        else {
            news.imageURL = nil;
        }
    }

    for (JSNewsEntity *news in [JSNewsEntity js_all:context].copy) {
        if (![ids containsObject:(id _Nonnull) news.newsId]) {
            [context deleteObject:news];
        }
    }
}

#pragma mark - Interface methods

- (instancetype)initWithCoreDataManager:(JSCoreDataManager *)coreDataManager base:(NSString *)base {
    JSParameterAssert(base);

    self = [self initWithPath:@"index.php" coreDataManager:coreDataManager extraParams:@{
            @"option": @"com_joomsport",
            @"task": @"getNews",
            @"controller": @"aws"
    }];
    if (self) {
        _base = [NSURL URLWithString:base];
    }
    return self;
}

@end
