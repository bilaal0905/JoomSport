// Created for BearDev by drif
// drif@mail.ru

#import "JSTitledViewController.h"
#import "JSBackgroundView.h"
#import "JSTitledView.h"

@implementation JSTitledViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titledView.titleLabel.text = self.title;
}

#pragma mark - JSViewController methods

- (void)loadBackgroundView {
    self.backgroundView = [[JSBackgroundView alloc] init];
}

- (void)loadContentView {
    self.contentView = [[JSTitledView alloc] init];
}

#pragma mark - Interface methods

- (JSTitledView *)titledView {
    return (JSTitledView *) self.contentView;
}

@end
