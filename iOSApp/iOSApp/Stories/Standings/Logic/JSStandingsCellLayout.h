// Created for BearDev by drif
// drif@mail.ru

@import UIKit;

@class JSStandings;

extern CGFloat const JSStandingsCellLayoutHeight;

@interface JSStandingsCellLayout : NSObject

- (instancetype)initWithStandings:(JSStandings *)standings;

@end

@interface JSStandingsCellLayout (TeamCell)

- (void)setTeamCellMaxWidth:(CGFloat)maxWidth;

- (CGFloat)teamCellWidth;
- (CGRect)indexLabelFrame;
- (CGRect)logoImageViewFrame;
- (CGRect)nameLabelFrame;

@end

@interface JSStandingsCellLayout (ScoreCell)

- (CGFloat)scoreCellWidth;
- (CGRect)scoreLabelFrame:(NSUInteger)index;

@end
