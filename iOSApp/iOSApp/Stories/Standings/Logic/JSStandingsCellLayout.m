// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;
@import JSCore;

#import "JSStandingsCellLayout.h"
#import "JSStandingsTeamCell.h"
#import "JSStandingsScoreCell.h"
#import "JSScoresTitlesView.h"

CGFloat const JSStandingsCellLayoutHeight = 61.0;

@interface JSStandingsCellLayout (Private)

- (void)initTeamLayout:(JSStandings *)standings;
- (void)initScoreLayout:(JSStandings *)standings;

@end

@implementation JSStandingsCellLayout {
    CGFloat _teamCellMaxWidth;

    CGFloat _indexWidth;
    CGFloat _nameWidth;

    CGFloat _teamCellWidth;
    CGRect _indexLabelFrame;
    CGRect _logoImageViewFrame;
    CGRect _nameLabelFrame;

    CGFloat _scoreCellWidth;
    NSArray *_scoreLabelsFrames;
}

#pragma mark - Interface methods

- (instancetype)initWithStandings:(JSStandings *)standings {
    JSParameterAssert(standings);

    self = [super init];
    if (self) {
        [self initTeamLayout:standings];
        [self initScoreLayout:standings];
    }
    return self;
}

@end

@implementation JSStandingsCellLayout (TeamCell)

#pragma mark - Private methods

- (void)initTeamLayout:(JSStandings *)standings {

    for (JSStandingsGroup *group in standings.groups) {
        for (JSStandingsRecord *record in group.records) {

            CGFloat indexWidth = [record.rankString sizeWithAttributes:@{
                    NSFontAttributeName: JSStandingsTeamCell.indexLabelFont
            }].width;

            CGFloat nameWidth = [record.teamName sizeWithAttributes:@{
                    NSFontAttributeName: JSStandingsTeamCell.nameLabelFont
            }].width;

            _indexWidth = MAX(_indexWidth, indexWidth);
            _nameWidth = MAX(_nameWidth, nameWidth);
        }
    }

    _indexWidth = ceil(_indexWidth);
    _nameWidth = ceil(_nameWidth);

    [self invalidateTeamCellLayout];
}

- (void)invalidateTeamCellLayout {
    static CGFloat const imageSize = 42.0;

    CGFloat offset = 7.0;

    _indexLabelFrame = CGRectMake(offset, 0.0, _indexWidth, JSStandingsCellLayoutHeight);
    offset += _indexWidth + 6.0;

    _logoImageViewFrame = CGRectMake(offset, (JSStandingsCellLayoutHeight - imageSize) / 2.0, imageSize, imageSize);
    offset += imageSize + 8.0;

    _nameLabelFrame = CGRectMake(offset, 0.0, _nameWidth, JSStandingsCellLayoutHeight);
    offset += _nameWidth;

    if (_teamCellMaxWidth > 0 && offset > _teamCellMaxWidth) {
        _nameLabelFrame.size.width = _teamCellMaxWidth - _nameLabelFrame.origin.x;
        offset = _teamCellMaxWidth;
    }

    _teamCellWidth = offset;
}

#pragma mark - Interface methods

- (void)setTeamCellMaxWidth:(CGFloat)maxWidth {
    JSParameterAssert(maxWidth >= 0.0);

    if (ABS(_teamCellMaxWidth - maxWidth) < DBL_EPSILON) {
        return;
    }

    _teamCellMaxWidth = maxWidth;
    [self invalidateTeamCellLayout];
}

- (CGFloat)teamCellWidth {
    return _teamCellWidth;
}

- (CGRect)indexLabelFrame {
    return _indexLabelFrame;
}

- (CGRect)logoImageViewFrame {
    return _logoImageViewFrame;
}

- (CGRect)nameLabelFrame {
    return _nameLabelFrame;
}

@end

@implementation JSStandingsCellLayout (ScoreCell)

#pragma mark - Private methods

- (void)initScoreLayout:(JSStandings *)standings {

    NSMutableArray *widths = ({
        NSMutableArray *array = [[NSMutableArray alloc] init];

        for (NSUInteger i = 0; i < standings.fields.count; i++) {

            CGFloat titleWidth = [standings.fields[i] sizeWithAttributes:@{
                    NSFontAttributeName: JSScoresTitlesView.font
            }].width;

            CGFloat valueWidth = 0.0;

            for (JSStandingsGroup *group in standings.groups) {
                for (JSStandingsRecord *record in group.records) {

                    CGFloat width = [record.valuesStrings[i] sizeWithAttributes:@{
                            NSFontAttributeName: JSStandingsScoreCell.font
                    }].width;

                    valueWidth = MAX(valueWidth, width);
                }
            }

            [array addObject:@(MAX(valueWidth, titleWidth))];
        }

        array;
    });

    CGFloat offset = 12.0;

    _scoreLabelsFrames = ({
        NSMutableArray *array = NSMutableArray.array;

        for (NSUInteger i = 0; i < widths.count; i++) {
            CGFloat width = ceil([widths[i] doubleValue]);
            [array addObject:[NSValue valueWithCGRect:CGRectMake(offset, 0.0, width, JSStandingsCellLayoutHeight)]];
            offset += width + 12.0;
        }
        _scoreCellWidth = offset;

        array.copy;
    });
}

#pragma mark - Interface methods

- (CGFloat)scoreCellWidth {
    return _scoreCellWidth;
}

- (CGRect)scoreLabelFrame:(NSUInteger)index {
    return [_scoreLabelsFrames[index] CGRectValue];
}

@end
