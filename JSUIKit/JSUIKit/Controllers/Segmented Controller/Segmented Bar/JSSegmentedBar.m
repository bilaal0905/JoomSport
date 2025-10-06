// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;

#import "JSSegmentedBar.h"
#import "JSSegmentedBarItem.h"

@implementation JSSegmentedBar {
    NSString *_fontName;
    UIColor *_activeColor;
    UIColor *_inactiveColor;

    NSArray *_items;
}

#pragma mark - Private methods

- (void)initItems:(NSArray *)titles {
    for (JSSegmentedBarItem *item in _items) {
        [item removeFromSuperview];
    }

    NSMutableArray *items = [[NSMutableArray alloc] init];

    for (NSUInteger i = 0; i < titles.count; i++) {

        JSSegmentedBarItem *item = ({
            JSSegmentedBarItem *barItem = [[JSSegmentedBarItem alloc] initWithTitle:titles[i]];

            JSWeakify(self);
            barItem.onTap = ^(JSSegmentedBarItem *segmentedBarItem) {
                JSStrongify(self);
                self.selected = [self->_items indexOfObject:segmentedBarItem];
                JSBlock(self.onChange, nil);
            };

            barItem.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:barItem];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[barItem]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(barItem)]];

            [items addObject:barItem];
            barItem;
        });

        if (i == 0) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[item]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item)]];
        }
        if (i == titles.count - 1) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[item]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item)]];
        }
        if (i > 0) {
            JSSegmentedBarItem *prev = items[i - 1];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[prev][item]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(prev, item)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:prev attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        }
    }

    _items = items.copy;

    [self update];
}

- (void)update {
    for (JSSegmentedBarItem *item in _items) {
        item.fontName = _fontName;
        item.activeColor = _activeColor;
        item.inactiveColor = _inactiveColor;
    }
}

#pragma mark - UIView methods

- (CGSize)intrinsicContentSize {
    return CGSizeMake(0.0, 42.0);
}

#pragma mark - Interface methods

- (void)setSelected:(NSUInteger)selected {
    _selected = selected;

    for (NSUInteger i = 0; i < _items.count; i++) {
        [(JSSegmentedBarItem *) _items[i] setSelected:(i == _selected)];
    }
}

- (void)setTitles:(NSArray *)titles {
    [self initItems:titles];
}

- (void)setFontName:(NSString *)fontName {
    _fontName = fontName;
    [self update];
}

- (void)setActiveColor:(UIColor *)color {
    _activeColor = color;
    [self update];
}

- (void)setInactiveColor:(UIColor *)color {
    _inactiveColor = color;
    [self update];
}

@end
