// Created for BearDev by drif
// drif@mail.ru
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#import <JSCore/JSViewModel.h>

@interface JSSeasonedViewModel : JSViewModel

@property (nonatomic, strong) NSString *seasonId;

- (void)reset;

@end
