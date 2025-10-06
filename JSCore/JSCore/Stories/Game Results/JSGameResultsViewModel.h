// Created for BearDev by drif
// drif@mail.ru

#import <JSCore/JSViewModel.h>

@class JSGame;
@class JSAPIClient;

@interface JSGameResultsViewModel : JSViewModel

@property (nonatomic, strong, readonly) JSGame *game;
@property (nonatomic, strong, readonly) NSArray *events;
@property (nonatomic, strong, readonly) NSArray *statistics;

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient gameId:(NSString *)gameId seasonId:(NSString *)seasonId;

@end
