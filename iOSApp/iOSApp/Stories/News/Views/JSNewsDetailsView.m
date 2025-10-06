// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCore.JSNews;
@import JSHTTP.UIImageView_JSHTTP;

#import "JSNewsDetailsView.h"
#import "UIColor+JS.h"

@implementation JSNewsDetailsView {
    UIActivityIndicatorView *_activityIndicatorView;
    NSString *_newsId;
    UILabel *_titleLabel;
    UIImageView *_imageView;
    UILabel *_textLabel;
    NSLayoutConstraint *_aspectRatioConstraint;
    UIScrollView *_scrollView;
}

#pragma mark - Private methods

+ (UIFont *)titleLabelFont {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Heavy" size:15.0]);
}

#pragma mark - NSObject methods

- (instancetype)init {
    self = [super init];
    if (self) {

        _scrollView = ({
            UIScrollView *view = [[UIScrollView alloc] init];
            view.showsVerticalScrollIndicator = NO;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });

        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = self.class.titleLabelFont;
            label.textColor = UIColor.js_Black;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [_scrollView addSubview:label];

            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[label]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeWidth multiplier:1.0 constant:16.0]];

            label;
        });

        _activityIndicatorView = ({
            UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            view.color = UIColor.blackColor;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [_scrollView addSubview:view];

            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(50)]-8-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view, _titleLabel)]];

            view;
        });

        _imageView = ({
            UIImageView *view = [[UIImageView alloc] init];

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [_scrollView addSubview:view];

            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-8-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, view)]];

            view;
        });

        _textLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = UIColor.js_Black;

            label.translatesAutoresizingMaskIntoConstraints = NO;
            [_scrollView addSubview:label];

            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[label]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView]-8-[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView, label)]];

            label;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(JSNews *)news {
    JSParameterAssert(news);

    _textLabel.attributedText = [news.text js_html:@"SFUIText" weights:@{
            @"TimesNewRomanPSMT": @"Regular"
    } size:14.0];

    if (![_newsId isEqualToString:news.newsId]) {
        _titleLabel.text = news.title;

        JSWeakify(self);
        [_imageView js_setImage:news.imageURL after:^UIImage *(UIImage *original) {
            dispatch_async(dispatch_get_main_queue(), ^{
                JSStrongify(self);
                if (self->_aspectRatioConstraint) {
                    [self removeConstraint:self->_aspectRatioConstraint];
                }
                if (original) {
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:self->_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self->_imageView attribute:NSLayoutAttributeHeight multiplier:(original.size.width / original.size.height) constant:0.0]];
                }
            });
            return original;
        }];

        _newsId = news.newsId;
    }
}

- (void)setIsUpdating:(BOOL)updating {
    if (updating) {
        [_activityIndicatorView startAnimating];
        [_scrollView setContentOffset:CGPointMake(0.0, -50.0) animated:YES];
    }
    else {
        [_activityIndicatorView stopAnimating];

        JSWeakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            JSStrongify(self);
            [self->_scrollView setContentOffset:CGPointZero animated:YES];
        });
    }
}

@end
