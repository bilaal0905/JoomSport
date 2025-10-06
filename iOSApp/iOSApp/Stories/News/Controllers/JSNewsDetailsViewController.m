// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore;
@import JSUIKit.UIViewController_JSUIKit;

#import "JSNewsDetailsViewController.h"
#import "JSTitledView.h"
#import "JSBackButton.h"
#import "JSNewsDetailsView.h"

@implementation JSNewsDetailsViewController {
    JSNewsDetailsViewModel *_model;
    JSKeyPathObserver *_observer;
    JSNewsDetailsView *_view;
    NSString *_newsText;
}

#pragma mark - Private methods

- (void)reloadData {
    if ([_newsText isEqualToString:_model.news.text]) {
        return;
    }

    _newsText = _model.news.text;
    [_view setup:_model.news];
}

#pragma mark - UIViewController methods

- (void)loadView {
    [super loadView];

    _view = ({
        JSNewsDetailsView *view = [[JSNewsDetailsView alloc] init];

        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.titledView.contentContainer addSubview:view];

        [self.titledView.contentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [self.titledView.contentContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

        view;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];

    JSWeakify(self);

    self.titledView.backButton.onTap = ^{
        JSStrongify(self);
        JSBlock(self.onBackTap, nil);
    };

    {
        _observer = [JSKeyPathObserver observerFor:_model keyPath:@"isUpdating" handler:^{
            JSStrongify(self);
            self->_view.isUpdating = self->_model.isUpdating;
        }];

        [_observer observe:@"news" handler:^{
            JSStrongify(self);
            [self reloadData];
        }];

        [_observer observe:@"error" handler:^{
            JSStrongify(self);
            if (self->_model.error) {
                [self js_showError:self->_model.error.js_error];
            }
        }];
    }

    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _view.isUpdating = _model.isUpdating;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (_model.news.text.length == 0) {
        [_model update];
    }
}

#pragma mark - Interface methods

- (instancetype)initWithModel:(JSNewsDetailsViewModel *)model {
    JSParameterAssert(model);

    self = [super init];
    if (self) {
        self.title = @"News";
        _model = model;
        self.modalPresentationStyle = UIModalPresentationFullScreen; // force here
    }
    return self;
}

@end
