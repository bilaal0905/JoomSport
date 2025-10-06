// Created for BearDev by drif
// drif@mail.ru

@import JSCore;
@import JSUtils;

#import "JSStandingsTeamCell.h"
#import "JSStandingsCellLayout.h"
#import "UIColor+JS.h"
#import "JSLogoView.h"

@implementation JSStandingsTeamCell {
    UILabel *_indexLabel;
    JSLogoView *_logoView;
    UILabel *_nameLabel;

    JSStandingsCellLayout *_layout;
}

#pragma mark - UIView methods

- (void)layoutSubviews {
    [super layoutSubviews];

    _indexLabel.frame = _layout.indexLabelFrame;
    _logoView.frame = _layout.logoImageViewFrame;
    _nameLabel.frame = _layout.nameLabelFrame;

    _nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(_nameLabel.frame);

    self.separatorInset = UIEdgeInsetsMake(0.0, _indexLabel.frame.origin.x, 0.0, 0.0);
}

#pragma mark - UITableViewCell methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;

        _indexLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.indexLabelFont;
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = UIColor.js_Black;

            [self.contentView addSubview:label];

            label;
        });

        _logoView = ({
            JSLogoView *logoView = [[JSLogoView alloc] init];
            [self.contentView addSubview:logoView];
            logoView;
        });

        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = self.class.nameLabelFont;
            label.numberOfLines = 0;
            label.textColor = UIColor.js_Black;

            [self.contentView addSubview:label];

            label;
        });
    }
    return self;
}

#pragma mark - JSStandingsCell protocol

- (void)setup:(JSStandingsCellLayout *)layout record:(JSStandingsRecord *)record sortIndex:(NSInteger)sortIndex {
    JSParameterAssert(layout);
    JSParameterAssert(record);

    if (_layout != layout) {
        _layout = layout;
        [self setNeedsLayout];
    }

    _indexLabel.text = record.rankString;
    _nameLabel.text = record.teamName;
    [_logoView setURL:record.teamLogoURL placeholder:record.placeholder];
}

#pragma mark - Interface methods

+ (UIFont *)indexLabelFont {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Semibold" size:11.0]);
}

+ (UIFont *)nameLabelFont {
    JSOnceSetReturn(UIFont *, font, [UIFont fontWithName:@"SFUIText-Semibold" size:11.0]);
}

@end
