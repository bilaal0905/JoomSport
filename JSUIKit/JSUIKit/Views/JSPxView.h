// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

typedef NS_ENUM(NSUInteger, JSPxViewType) {
    JSPxViewTypeHorizontal,
    JSPxViewTypeVertical
};

@interface JSPxView : UIView

- (instancetype)initWithType:(JSPxViewType)type;

@end
