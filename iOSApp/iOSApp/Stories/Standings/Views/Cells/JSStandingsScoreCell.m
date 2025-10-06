// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;
@import JSUIKit.UIColor_JSUIKit;

#import "JSStandingsScoreCell.h"
#import "JSStandingsCellLayout.h"
#import "UIColor+JS.h"

@implementation JSStandingsScoreCell {
    NSArray *_scoresLabels;
    JSStandingsCellLayout *_layout;
    NSInteger _selectedScoreIndex;
}

#pragma mark - Private methods

+ (UIColor *)deselectedColor {
    JSOnceSetReturn(UIColor *, color, UIColor.js_Gray);
}

+ (UIColor *)selectedColor {
    JSOnceSetReturn(UIColor *, color, UIColor.js_Black);
}

- (void)createScoresLabels:(NSUInteger)count {
    for (UILabel *label in _scoresLabels) {
        [label removeFromSuperview];
    }

    _scoresLabels = ({
        NSMutableArray *labels = NSMutableArray.array;

        for (NSUInteger i = 0; i < count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = self.class.font;
            label.textColor = ((NSInteger) i == _selectedScoreIndex) ? self.class.selectedColor : self.class.deselectedColor;

            [self.contentView addSubview:label];

            [labels addObject:label];
        }

        labels.copy;
    });
}

- (void)setSelectedScoreIndex:(NSInteger)selectedScoreIndex {
    if (_selectedScoreIndex == selectedScoreIndex) {
        return;
    }
    _selectedScoreIndex = selectedScoreIndex;

    for (NSUInteger i = 0; i < _scoresLabels.count; i++) {
        [_scoresLabels[i] setTextColor:((NSInteger) i == _selectedScoreIndex) ? self.class.selectedColor : self.class.deselectedColor];
    }
}

#pragma mark - UIView methods

- (void)layoutSubviews {
    [super layoutSubviews];

    for (NSUInteger i = 0; i < _scoresLabels.count; i++) {
        [_scoresLabels[i] setFrame:[_layout scoreLabelFrame:i]];
    }
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - JSStandingsCell protocol

- (void)setup:(JSStandingsCellLayout *)layout record:(JSStandingsRecord *)record sortIndex:(NSInteger)sortIndex {
    JSParameterAssert(layout);
    JSParameterAssert(record);

    if (record.valuesStrings.count != _scoresLabels.count) {
        [self createScoresLabels:record.valuesStrings.count];
    }

    if (_layout != layout) {
        _layout = layout;
        [self setNeedsLayout];
    }

    self.selectedScoreIndex = sortIndex;
    for (NSUInteger i = 0; i < record.valuesStrings.count; i++) {
        [_scoresLabels[i] setText:record.valuesStrings[i]];
    }
}

#pragma mark - Interface methods

+ (UIFont *)font {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Semibold" size:11.0]);
}

@end
