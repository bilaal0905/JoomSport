// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore;

#import "JSSeasonedViewController.h"
#import "JSSeasonedView.h"
#import "JSRoundedButton.h"
#import "JSBackgroundView.h"

@implementation JSSeasonedViewController {
    JSSeasonsViewModel *_seasonsModel;
    JSKeyPathObserver *_seasonsObserver;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    JSWeakify(self);

    self.seasonedView.seasonButton.onTap = ^{
        JSStrongify(self);
        JSBlock(self.onSeasonTap, nil);
    };

    _seasonsObserver = [JSKeyPathObserver observerFor:_seasonsModel keyPath:@"activeSeason" handler:^{
        JSStrongify(self);
        [self.seasonedView.seasonButton setTitle:self->_seasonsModel.activeSeason.fullName forState:UIControlStateNormal];
    }];
    [self.seasonedView.seasonButton setTitle:_seasonsModel.activeSeason.fullName forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!_seasonsModel.activeSeason) {
        JSBlock(self.onSeasonTap, nil);
    }
}

#pragma mark - JSViewController methods

- (void)loadBackgroundView {
    self.backgroundView = [[JSBackgroundView alloc] init];
}

- (void)loadContentView {
    self.contentView = [[JSSeasonedView alloc] init];
}

#pragma mark - Interface methods

- (instancetype)initWithSeasonsModel:(JSSeasonsViewModel *)seasonsModel {
    JSParameterAssert(seasonsModel);

    self = [super init];
    if (self) {
        _seasonsModel = seasonsModel;
    }
    return self;
}

- (JSSeasonedView *)seasonedView {
    return (JSSeasonedView *) self.contentView;
}

- (JSSeasonsViewModel *)seasonsModel {
    return _seasonsModel;
}

@end
