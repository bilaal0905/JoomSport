// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSStandingsCellLayout;
@class JSStandingsViewModel;

@interface JSScoresTitlesView : UIView

+ (UIFont *)font;

- (instancetype)initWithLayout:(JSStandingsCellLayout *)layout titles:(NSArray *)titles;

@end
