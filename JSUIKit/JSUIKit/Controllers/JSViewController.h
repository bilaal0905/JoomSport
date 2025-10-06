// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSViewController;

typedef UIView *(^JSBannerInitializer)(JSViewController *);

@interface JSViewController : UIViewController

@property (class, nonatomic, copy) JSBannerInitializer bannerInitializer;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;

- (void)loadBackgroundView;
- (void)loadContentView;
- (void)setBannerHidden:(BOOL)hidden;

@end
