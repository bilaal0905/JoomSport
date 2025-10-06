// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSSegmentedBarItem;

typedef void (^JSSegmentedBarItemHandler)(JSSegmentedBarItem *item);

@interface JSSegmentedBarItem : UIView

@property (nonatomic, copy) JSSegmentedBarItemHandler onTap;

- (instancetype)initWithTitle:(NSString *)title;

- (void)setFontName:(NSString *)fontName;
- (void)setActiveColor:(UIColor *)color;
- (void)setInactiveColor:(UIColor *)color;

- (void)setSelected:(BOOL)isSelected;

@end
