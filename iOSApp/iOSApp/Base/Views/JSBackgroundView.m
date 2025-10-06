// Created for BearDev by drif
// drif@mail.ru

#import "JSBackgroundView.h"

@implementation JSBackgroundView

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super initWithImage:[UIImage imageNamed:@"viewcontroller_background"]];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

@end
