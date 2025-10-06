// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

typedef UIImage *(^JSImageViewProcessor)(UIImage *original);

@interface UIImageView (JSHTTP)

- (void)js_setImage:(NSURL *)url after:(JSImageViewProcessor)processor;

@end
