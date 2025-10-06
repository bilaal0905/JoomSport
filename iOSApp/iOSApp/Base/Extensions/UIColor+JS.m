// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit.UIColor_JSUIKit;
@import JSUtils.JSOnce;

#import "UIColor+JS.h"

@implementation UIColor (JS)

#pragma mark - Interface methods

+ (UIColor *)js_Black {
    JSOnceSetReturn(UIColor *, color, [UIColor js_R:22 G:20 B:20]);
}

+ (UIColor *)js_Green {
    JSOnceSetReturn(UIColor *, color, [UIColor js_R:58 G:199 B:67]);
}

+ (UIColor *)js_Gray {
    JSOnceSetReturn(UIColor *, color, [UIColor js_R:168 G:168 B:168]);
}

+ (UIColor *)js_Separator {
    JSOnceSetReturn(UIColor *, color, [UIColor js_R:220 G:220 B:220]);
}

@end
