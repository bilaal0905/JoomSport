// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit;

#import "JSDetailsViewController.h"
#import "JSDetailsBackground.h"
#import "JSDetailsView.h"
#import "JSSubtitledLogoView.h"
#import "JSTeamInfoViewController.h"
#import "UIColor+JS.h"

@implementation JSDetailsViewController {
    JSSegmentedController *_segmentedController;
}

#pragma mark - Private methods

- (JSDetailsView *)detailsView {
    return (JSDetailsView *) self.contentView;
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {

        _segmentedController = ({
            JSSegmentedController *viewController = [[JSSegmentedController alloc] init];
            
            viewController.segmentedBar.fontName = @"SFUIText-Semibold";
            viewController.segmentedBar.activeColor = UIColor.js_Black;
            viewController.segmentedBar.inactiveColor = UIColor.js_Gray;
            viewController.separator.backgroundColor = UIColor.js_Separator;
            
            viewController;
        });
    }
    return self;
}

#pragma mark - UIViewController methods

- (void)loadView {
    [super loadView];

    {
        [self addChildViewController:_segmentedController];

        _segmentedController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.detailsView.container addSubview:_segmentedController.view];

        [self.detailsView.container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _segmentedController.view}]];
        [self.detailsView.container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _segmentedController.view}]];

        [_segmentedController didMoveToParentViewController:self];
    };
}

- (UIStatusBarStyle)preferredStatusBarStyle {    
    return UIStatusBarStyleLightContent;
}

#pragma mark - JSViewController methods

- (void)loadBackgroundView {
    self.backgroundView = [[JSDetailsBackground alloc] init];
}

- (void)loadContentView {
    self.contentView = [[JSDetailsView alloc] init];
}

#pragma mark - Interface methods

- (UIImageView *)headerBackground {
    JSDetailsBackground *background = (JSDetailsBackground *) self.backgroundView;
    return background.header;
}

- (JSSubtitledLogoView *)logo {
    return self.detailsView.logo;
}

- (JSSegmentedController *)segmentedController {
    return _segmentedController;
}

@end
