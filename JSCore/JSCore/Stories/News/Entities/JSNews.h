// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@class JSNewsEntity;

@interface JSNews : NSObject

- (instancetype)initWithEntity:(JSNewsEntity *)entity;

- (NSString *)newsId;
- (NSString *)title;
- (NSString *)date;
- (NSString *)text;
- (NSURL *)previewImageURL;
- (NSURL *)imageURL;

@end
