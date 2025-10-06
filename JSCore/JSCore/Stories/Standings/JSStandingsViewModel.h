// Created for BearDev by drif
// drif@mail.ru

#import <JSCore/JSSeasonedViewModel.h>

@class JSStandings;

@interface JSStandingsViewModel : JSSeasonedViewModel

@property (nonatomic, strong, readonly) JSStandings *standings;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, strong, readonly) NSString *sortName;

@end
