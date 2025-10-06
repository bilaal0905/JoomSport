// Created for BearDev by drif
// drif@mail.ru

#import <JSCore/JSViewModel.h>

@class JSNews;

@interface JSNewsDetailsViewModel : JSViewModel

@property (nonatomic, strong, readonly) JSNews *news;

- (void)setNewsId:(NSString *)newsId;

@end
