// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;

#import "UIImage+JSUIKit.h"

@implementation UIImage (JSUIKit)

#pragma mark - Private methods

+ (CGFloat)scaleFactor {
    JSOnceSetReturn(CGFloat, factor, UIScreen.mainScreen.scale);
}

#pragma mark - Interface methods

- (UIImage *)js_of:(CGSize)targetSize by:(CGFloat)radius {

    if (ABS(targetSize.height) < DBL_EPSILON || ABS(targetSize.width) < DBL_EPSILON) {
        return nil;
    }

    CGSize scaledSize = targetSize;
    CGPoint thumbnailPoint = CGPointZero;

    if (!CGSizeEqualToSize(self.size, targetSize))
    {
        CGFloat widthFactor = targetSize.width / self.size.width;
        CGFloat heightFactor = targetSize.height / self.size.height;

        CGFloat scaleFactor = MIN(widthFactor, heightFactor);

        scaledSize.width = self.size.width * scaleFactor;
        scaledSize.height = self.size.height * scaleFactor;

        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetSize.height - scaledSize.height) / 2.0;
        }
        else {
            thumbnailPoint.x = (targetSize.width - scaledSize.width) / 2.0;
        }
    }

    UIGraphicsBeginImageContextWithOptions(targetSize, NO, self.class.scaleFactor);

    if (ABS(radius) > DBL_EPSILON) {
        CGRect round = CGRectZero;
        round.size = targetSize;

        [[UIBezierPath bezierPathWithRoundedRect:round cornerRadius:radius] addClip];
    }

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size = scaledSize;

    [self drawInRect:thumbnailRect];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    JSParameterAssert(image);

    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)js_original {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
