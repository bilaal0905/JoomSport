// Created for BearDev by drif
// drif@mail.ru

#import <JSCore/JSSeasonedViewModel.h>

@class JSPlayer;

@interface JSPlayerViewModel : JSSeasonedViewModel

@property (nonatomic, strong, readonly) JSPlayer *player;

- (void)setPlayerId:(NSString *)playerId;

@end
