// Created for BearDev by drif
// drif@mail.ru

//@import JSUtils;
#import "/Users/user/Downloads/BaernerCup/BaernerCup 2023/JSUtils/JSUtils/Supporting Files/JSUtils.h"

@import ObjectiveC.runtime;

#import "UIImageView+JSHTTP.h"
#import "JSImagesLoader.h"

static char *const JSImageViewURLKey = "JSImageViewURLKey";

@implementation UIImageView (JSHTTP)

#pragma mark - Private methods

+ (NSString *)cachesPath {
    JSOnceSetReturn(NSString *, path, [NSString.js_cachesPath stringByAppendingPathComponent:@"images"]);
}

+ (JSImagesLoader *)imagesLoader {
    JSOnceSetReturn(JSImagesLoader *, imagesLoader, [[JSImagesLoader alloc] initWithCachesPath:self.cachesPath]);
}

- (void)setJs_URL:(NSURL *)url {
    objc_setAssociatedObject(self, JSImageViewURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL *)js_URL {
    return objc_getAssociatedObject(self, JSImageViewURLKey);
}

#pragma mark - Interface methods

- (void)js_setImage:(NSURL *)url after:(JSImageViewProcessor)processor {
    self.image = nil;
    self.js_URL = url;

    if (url) {
        JSWeakify(self);
        [self.class.imagesLoader image:url completion:^(UIImage *image, NSURL *imageURL) {
            JSStrongify(self);

            if (![imageURL isEqual:self.js_URL]) {
                return;
            }

            if (!processor) {
                self.image = image;
                return;
            }

            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                UIImage *processedImage = processor(image);

                dispatch_async(dispatch_get_main_queue(), ^{
                    JSStrongify(self);
                    self.image = processedImage ?: image;
                });
            });
        }];
    }
}

@end
