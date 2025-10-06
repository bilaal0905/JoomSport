// Created for BearDev by drif
// drif@mail.ru

#import <JSCore/JSSeasonedViewModel.h>

@class JSTeam;

@interface JSTeamViewModel : JSSeasonedViewModel

@property (nonatomic, strong, readonly) JSTeam *team;
@property (nonatomic, strong, readonly) NSArray *teams;

- (void)setTeamId:(NSString *)teamId;

@end
