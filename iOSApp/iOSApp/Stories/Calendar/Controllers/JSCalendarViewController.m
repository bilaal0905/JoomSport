// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit;
@import JSUtils;
@import JSCore;

#import "JSCalendarViewController.h"
#import "JSSeasonedView.h"
#import "JSCalendarTableViewController.h"
#import "JSRoundedButton.h"
#import "UIColor+JS.h"
#import "JSAPNManager.h"

@implementation JSCalendarViewController {
    JSCalendarTableViewController *_tableViewController;

    JSCalendarViewModel *_calendarModel;
    JSSeasonsViewModel *_seasonsModel;

    JSKeyPathObserver *_seasonsObserver;
    JSKeyPathObserver *_calendarObserver;
}

#pragma mark - Private methods

- (void)onUIApplicationDidBecomeActiveNotification {
    if (self.view.window) {
        [NSNotificationCenter.defaultCenter postNotificationName:JSAPNManagerResetBadgeNotification object:nil];
    }
}

#pragma mark - UIViewController methods

- (void)loadView {
    [super loadView];

    {
        JSPxView *view = [[JSPxView alloc] initWithType:JSPxViewTypeHorizontal];
        view.backgroundColor = UIColor.js_Separator;

        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.seasonedView.tableViewContainer addSubview:view];

        [self.seasonedView.tableViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        
        [self.seasonedView.tableViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    }

    {
        [self addChildViewController:_tableViewController];

        _tableViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.seasonedView.tableViewContainer addSubview:_tableViewController.view];

        [self.seasonedView.tableViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _tableViewController.view}]];
        [self.seasonedView.tableViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _tableViewController.view}]];

        [_tableViewController didMoveToParentViewController:self];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.seasonedView.titleLabel.text = NSLocalizedString(@"Calendar", nil);

    JSWeakify(self);

    self.seasonedView.sortButton.onTap = ^{
        JSStrongify(self);
        JSBlock(self.onParticipantTap, nil);
    };

    _calendarObserver = [JSKeyPathObserver observerFor:_calendarModel keyPath:@"participantName" handler:^{
        JSStrongify(self);
        [self.seasonedView.sortButton setTitle:self->_calendarModel.participantName forState:UIControlStateNormal];
    }];
    [self.seasonedView.sortButton setTitle:_calendarModel.participantName forState:UIControlStateNormal];

    _seasonsObserver = [JSKeyPathObserver observerFor:_seasonsModel keyPath:@"activeSeason" handler:^{
        JSStrongify(self);
        self->_calendarModel.seasonId = self->_seasonsModel.activeSeason.seasonId;
    }];

    if (_seasonsModel.activeSeason) {
        _calendarModel.seasonId = _seasonsModel.activeSeason.seasonId;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSNotificationCenter.defaultCenter postNotificationName:JSAPNManagerResetBadgeNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat bottomInset = self.tabBarController.tabBar.frame.size.height;
    _tableViewController.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomInset, 0);
    _tableViewController.tableView.scrollIndicatorInsets = _tableViewController.tableView.contentInset;
}

#pragma mark - Interface methods

- (instancetype)initWithSeasonsModel:(JSSeasonsViewModel *)seasonsModel standingsModel:(JSCalendarViewModel *)calendarModel {
    JSParameterAssert(seasonsModel);
    JSParameterAssert(calendarModel);

    self = [super initWithSeasonsModel:seasonsModel];
    if (self) {
        _seasonsModel = seasonsModel;
        _calendarModel = calendarModel;
        
        _tableViewController = [[JSCalendarTableViewController alloc] initWithCalendarModel:_calendarModel];

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar_calendar"].js_original selectedImage:[UIImage imageNamed:@"tabbar_calendar_selected"].js_original];

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onUIApplicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:UIApplication.sharedApplication];
    }
    return self;
}

- (JSCalendarTableViewControllerHandler)onGameTap {
    return _tableViewController.onGameTap;
}

- (void)setOnGameTap:(JSCalendarTableViewControllerHandler)onGameTap {
    _tableViewController.onGameTap = onGameTap;
}

@end
