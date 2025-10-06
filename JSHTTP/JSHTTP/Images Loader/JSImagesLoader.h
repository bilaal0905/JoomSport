// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

typedef void (^JSImagesLoaderCompletionBlock)(UIImage *image, NSURL *url);

@interface JSImagesLoader : NSObject

- (instancetype)initWithCachesPath:(NSString *)cachesPath;
- (void)image:(NSURL *)url completion:(JSImagesLoaderCompletionBlock)completionBlock;

@end
