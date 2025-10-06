// Created for BearDev by drif
// drif@mail.ru

@import JSUIKit;
@import JSUtils;

#import "JSTeamStandingsCell.h"
#import "UIColor+JS.h"

CGFloat const JSTeamStandingsCellHeight = 92.0;

@implementation JSTeamStandingsCell {
    UIScrollView *_scrollView;
    NSArray *_columns;
}

#pragma mark - Private methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Semibold" size:11.0]);
}

+ (UIColor *)titleColor {
    JSOnceSetReturn(UIColor *, color, [UIColor js_R:140 G:140 B:140]);
}

+ (UIColor *)backgroundColor {
    JSOnceSetReturn(UIColor *, color, [UIColor js_R:250 G:250 B:250]);
}

+ (UIView *)column:(NSString *)title with:(NSString *)value {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = self.titleColor;
        label.font = self.font;
        label.text = title;

        label.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:label];

        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=10)-[label]-(>=10)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-11-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    }

    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColor.js_Gray;
        label.font = self.font;
        label.text = value;

        label.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:label];

        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=10)-[label]-(>=10)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-55-[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    }

    return view;
}

+ (UIView *)padding {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    return view;
}

- (void)layout:(NSArray *)titles with:(NSArray *)values forWidth:(CGFloat)width {
    for (UIView *view in _columns) {
        [view removeFromSuperview];
    }

    NSMutableArray *columns = [[NSMutableArray alloc] init];

    for (NSUInteger i = 0; i < titles.count; i++) {
        UIView *view = [self.class column:titles[i] with:values[i]];
        UIView *leftPadding = [self.class padding];
        UIView *rightPadding = [self.class padding];

        [_scrollView addSubview:view];
        [_scrollView addSubview:leftPadding];
        [_scrollView addSubview:rightPadding];
        [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[leftPadding]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftPadding)]];
        [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightPadding]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightPadding)]];

        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:leftPadding attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rightPadding attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];

        if (i == 0) {
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[leftPadding][view][rightPadding]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftPadding, view, rightPadding)]];
            [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:leftPadding attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.1]];
        }
        else {
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[prev][leftPadding][view][rightPadding]" options:0 metrics:nil views:@{
                    @"prev": (id _Nonnull) columns.lastObject,
                    @"leftPadding": leftPadding,
                    @"view": view,
                    @"rightPadding": rightPadding
            }]];
            [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:leftPadding attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:columns.lastObject attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        }
        if (i == titles.count - 1) {
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightPadding]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightPadding)]];

            if (width > 0.0) {
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:rightPadding attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_scrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:width]];
            }
        }

        [columns addObject:leftPadding];
        [columns addObject:view];
        [columns addObject:rightPadding];
    }

    _columns = columns.copy;
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = self.class.backgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;

        UIView *background = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = UIColor.whiteColor;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(62)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });

        {
            JSPxView *view = [[JSPxView alloc] initWithType:JSPxViewTypeHorizontal];
            view.backgroundColor = UIColor.js_Separator;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view][background]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view, background)]];
        }

        _scrollView = ({
            UIScrollView *view = [[UIScrollView alloc] init];
            view.showsHorizontalScrollIndicator = NO;

            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:view];

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

            view;
        });
    }
    return self;
}

#pragma mark - Interface methods

- (void)setup:(NSArray *)titles with:(NSArray *)values forWidth:(CGFloat)width {
    JSParameterAssert(titles.count == values.count);

    [self layout:titles with:values forWidth:width];
}

@end
