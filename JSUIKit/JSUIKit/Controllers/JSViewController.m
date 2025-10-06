// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSOnce;
@import JSUtils.JSBlock;

#import "JSViewController.h"

#if defined(DEBUG)

    @interface JSViewController (Private)

    + (BOOL)debugDesign_IsDebugDesign;
    + (UIImageView *)debugDesign_ImageView;

    @end

#endif

static JSBannerInitializer _bannerInitializer;

@implementation JSViewController {
    UIView *_bannerView;
    NSLayoutConstraint *_contentViewBannerConstraint;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>) self;

    if (self.class.bannerInitializer) {
        UIView *banner = self.class.bannerInitializer(self);
        if (banner) {
            banner.translatesAutoresizingMaskIntoConstraints = NO;
            [_bannerView addSubview:banner];

            [_bannerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[banner]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(banner)]];
            [_bannerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[banner]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(banner)]];
        }
    }
}

#if defined(DEBUG)

    - (void)viewDidAppear:(BOOL)animated {
        [super viewDidAppear:animated];

        if (self.class.debugDesign_IsDebugDesign) {
            self.class.debugDesign_ImageView.image = [UIImage imageNamed:NSStringFromClass(self.class)];
        }
    }

    - (void)viewWillDisappear:(BOOL)animated {
        [super viewWillDisappear:animated];

        if (self.class.debugDesign_IsDebugDesign) {
            self.class.debugDesign_ImageView.image = nil;
        }
    }

#endif

- (void)loadView {
    [self loadBackgroundView];

    if (self.backgroundView) {
        self.view = self.backgroundView;
    }
    else {
        [super loadView];
    }


    [self loadContentView];
    if (!self.contentView) {
        return;
    }

    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.contentView];

    {
        _bannerView = [[UIView alloc] init];
        _bannerView.hidden = YES;

        _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_bannerView];
    }

    NSDictionary *views = @{
            @"contentView": self.contentView,
            @"topLayoutGuide": self.topLayoutGuide,
            @"bottomLayoutGuide": self.bottomLayoutGuide,
            @"bannerView": _bannerView
    };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bannerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][contentView]-0@1-[bottomLayoutGuide]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bannerView][bottomLayoutGuide]" options:0 metrics:nil views:views]];

    _contentViewBannerConstraint = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bannerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [self.view addConstraint:_contentViewBannerConstraint];
    _contentViewBannerConstraint.active = NO;
}

#pragma mark - Interface methods

- (void)loadBackgroundView {}
- (void)loadContentView {}

- (void)setBannerHidden:(BOOL)hidden {
    _bannerView.hidden = hidden;
    _contentViewBannerConstraint.active = !hidden;
}

+ (JSBannerInitializer)bannerInitializer {
    @synchronized (self) {
        return _bannerInitializer;
    }
}

+ (void)setBannerInitializer:(JSBannerInitializer)bannerInitializer {
    @synchronized (self) {
        _bannerInitializer = [bannerInitializer copy];
    }
}

@end

#if defined(DEBUG)

    @implementation JSViewController (DebugDesign)

    #pragma mark - Private methods

    + (BOOL)debugDesign_IsDebugDesign {
        JSOnceSetReturn(BOOL, isDebugDesign, [NSProcessInfo.processInfo.environment[@"DEBUG_DESIGN"] boolValue]);
    }

    + (UIImageView *)debugDesign_ImageView {
        static NSInteger const debugDesignTag = 666;

        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        UIImageView *imageView = [window viewWithTag:debugDesignTag];

        if (!imageView) {
            imageView = [[UIImageView alloc] initWithFrame:window.bounds];
            imageView.alpha = 0.4;
            imageView.tag = debugDesignTag;
            [window addSubview:imageView];
        }

        [window bringSubviewToFront:imageView];

        return imageView;
    }

    @end

#endif
