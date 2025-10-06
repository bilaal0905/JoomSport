// Created for BearDev by drif
// drif@mail.ru

@import UIKit;
@import JSUtils.JSBlock;

@interface JSSegmentedBar : UIView

@property (nonatomic, copy) JSEventBlock onChange;
@property (nonatomic, assign) NSUInteger selected;

- (void)setTitles:(NSArray *)titles;
- (void)setFontName:(NSString *)fontName;
- (void)setActiveColor:(UIColor *)color;
- (void)setInactiveColor:(UIColor *)color;

@end
