// Created for BearDev by drif
// drif@mail.ru

@import Foundation;

@interface JSGameParticipant : NSObject

- (instancetype)initWithId:(NSString *)participantId name:(NSString *)name;

- (NSString *)participantId;
- (NSString *)name;

@end
