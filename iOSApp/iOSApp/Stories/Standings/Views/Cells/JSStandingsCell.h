// Created for BearDev by drif
// drif@mail.ru

@class JSStandingsCellLayout;
@class JSStandingsRecord;

@protocol JSStandingsCell

- (void)setup:(JSStandingsCellLayout *)layout record:(JSStandingsRecord *)record sortIndex:(NSInteger)sortIndex;

@end
