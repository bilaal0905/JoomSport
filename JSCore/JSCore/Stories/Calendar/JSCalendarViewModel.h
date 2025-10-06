// Created for BearDev by drif
// drif@mail.ru

#import <JSCore/JSSeasonedViewModel.h>

@class JSGameParticipant;

@interface JSCalendarViewModel : JSSeasonedViewModel

@property (nonatomic, strong, readonly) NSArray *games;
@property (nonatomic, strong, readonly) NSArray *participants;
@property (nonatomic, strong, readonly) NSString *participantName;

- (void)setParticipant:(JSGameParticipant *)participant;
- (NSUInteger)visibleGame;

@end
