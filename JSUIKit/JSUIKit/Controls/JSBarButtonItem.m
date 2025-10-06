// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSBlock;

#import "JSBarButtonItem.h"

@implementation JSBarButtonItem

#pragma mark - Private methods

- (void)onSelfTap {
    JSBlock(self.onTap, nil);
}

#pragma mark - Interface methods

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
{
    return [self initWithBarButtonSystemItem:systemItem target:self action:@selector(onSelfTap)];
}

@end
