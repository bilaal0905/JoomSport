// Created for BearDev by drif
// drif@mail.ru

#import <JSCore/JSViewModel.h>

@class JSSeason;

@interface JSSeasonsViewModel : JSViewModel

@property (nonatomic, copy, readonly) NSArray *tournaments;
@property (nonatomic, copy) JSSeason *activeSeason;

@end
