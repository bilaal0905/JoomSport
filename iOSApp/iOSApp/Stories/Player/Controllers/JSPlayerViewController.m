// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore;

#import "JSPlayerViewController.h"
#import "JSPlayerStatisticViewController.h"
#import "JSPlayerInfoViewController.h"
#import "JSBackButton.h"
#import "JSSubtitledLogoView.h"
#import "JSLogoView.h"

@implementation JSPlayerViewController {
    JSSeasonsViewModel *_seasonsModel;
    JSPlayerViewModel *_playerModel;
    JSKeyPathObserver *_seasonsObserver;
    BOOL _shouldUpdate;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.headerBackground.image = [UIImage imageNamed:@"player_page_background"];

    if (!_seasonsModel.activeSeason.isSinglePlayer) {
        JSBackButton *button = [JSBackButton button:UIColor.whiteColor];

        JSWeakify(self);
        button.onTap = ^{
            JSStrongify(self);
            JSBlock(self.onDone, nil);
        };

        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:button];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    }

    {
        JSWeakify(self);
        _seasonsObserver = [JSKeyPathObserver observerFor:_seasonsModel keyPath:@"activeSeason" handler:^{
            JSStrongify(self);
            self->_playerModel.seasonId = self->_seasonsModel.activeSeason.seasonId;
            self->_shouldUpdate = YES;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _playerModel.seasonId = _seasonsModel.activeSeason.seasonId;

    self.logo.label.text = _playerModel.player.name;
    [self.logo.logoView setURL:_playerModel.player.photoURL placeholder:_playerModel.player.placeholder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!_playerModel.player) {
        JSBlock(self.onNoData, nil);
        return;
    }

    if (_shouldUpdate) {
        _shouldUpdate = NO;
        [_playerModel update];
    }
}

#pragma mark - Interface methods

- (instancetype)initWithSeasonsModel:(JSSeasonsViewModel *)seasonsModel playerModel:(JSPlayerViewModel *)playerModel {
    JSParameterAssert(seasonsModel);
    JSParameterAssert(playerModel);

    self = [super init];
    if (self) {
        _seasonsModel = seasonsModel;
        _playerModel = playerModel;

        _shouldUpdate = YES;

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar_team"].js_original selectedImage:[UIImage imageNamed:@"tabbar_team_selected"].js_original];
        self.segmentedController.tabBarController.viewControllers = @[
                ({
                    JSPlayerStatisticViewController *viewController = [[JSPlayerStatisticViewController alloc] initWithPlayerModel:_playerModel seasonsModel:_seasonsModel];

                    JSWeakify(self);
                    viewController.onSeasonTap = ^{
                        JSStrongify(self);
                        JSBlock(self.onSeasonTap, nil);
                    };

                    viewController;
                }),
                [[JSPlayerInfoViewController alloc] initWithModel:_playerModel]
        ];
    }
    return self;
}

@end
