// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;

#import "JSNews.h"
#import "NSDate+JSCore.h"
#import "JSNewsEntity+CoreDataClass.h"

@implementation JSNews {
    NSString *_newsId;
    NSString *_title;
    NSString *_date;
    NSString *_text;
    NSURL *_previewImageURL;
    NSURL *_imageURL;
}

#pragma mark - Private methods

+ (NSString *)date:(NSDate *)date {
    JSOnceSet(NSDateFormatter *, formatter, [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"d MMMM y";
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"]
    );
    return [formatter stringFromDate:date];
}

#pragma mark - Inteface methods

- (instancetype)initWithEntity:(JSNewsEntity *)entity {
    JSParameterAssert(entity);

    self = [super init];
    if (self) {
        _newsId = entity.newsId;
        _title = entity.title;
        _date = [self.class date:entity.date];
        _text = entity.text;
        _previewImageURL = entity.previewImageURL ? [[NSURL alloc] initWithString:(NSString * _Nonnull) entity.previewImageURL] : nil;
        _imageURL = entity.imageURL ? [[NSURL alloc] initWithString:(NSString * _Nonnull) entity.imageURL] : nil;
    }
    return self;
}

- (NSString *)newsId {
    return _newsId;
}

- (NSString *)title {
    return _title;
}

- (NSString *)date {
    return _date;
}

- (NSString *)text {
    return _text;
}

- (NSURL *)previewImageURL {
    return _previewImageURL;
}

- (NSURL *)imageURL {
    return _imageURL;
}

@end
