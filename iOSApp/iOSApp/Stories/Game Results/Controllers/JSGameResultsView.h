// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSBackButton;
@class JSGame;
@class JSSubtitledLogoView;

@interface JSGameResultsView : UIView

- (void)setup:(JSGame *)game;

- (JSBackButton *)backButton;
- (JSSubtitledLogoView *)homeLogo;
- (JSSubtitledLogoView *)awayLogo;
- (UIView *)segmentedControllerContainer;

@end
