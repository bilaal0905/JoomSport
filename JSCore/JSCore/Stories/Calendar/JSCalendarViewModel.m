// Created for BearDev by drif
// drif@mail.ru

@import JSCoreData;
@import JSUtils;

#import "JSCalendarViewModel.h"
#import "JSAPIClient.h"
#import "JSCalendarRequest.h"
#import "JSGame.h"
#import "JSSeasonEntity+CoreDataClass.h"
#import "JSGameEntity+CoreDataClass.h"
#import "JSGameParticipant.h"
#import "JSGameTeam.h"
#import "JSGameParticipant.h"

@interface JSCalendarViewModel ()

@property (nonatomic, strong, readwrite) NSArray *games;
@property (nonatomic, strong, readwrite) NSArray *participants;
@property (nonatomic, strong, readwrite) NSString *participantName;

@end

@implementation JSCalendarViewModel {
    JSGameParticipant *_participant;
    NSURL *_placeholder;
    NSUInteger _visibleGame;
}

#pragma mark - JSViewModel methods

- (void)initData:(NSManagedObjectContext *)context {
    if (!self.seasonId) {
        return;
    }

    JSSeasonEntity *season = [JSSeasonEntity js_object:context where:@"seasonId" equals:self.seasonId];

    NSArray *allGames = [[season.games.allObjects sortedArrayUsingComparator:^NSComparisonResult(JSGameEntity *game1, JSGameEntity *game2) {
        if (game1.date && !game2.date) {
            return NSOrderedDescending;
        }
        else if (game2.date && !game1.date) {
            return NSOrderedAscending;
        }
        else {
            NSComparisonResult result = [game1.date compare:(NSDate * _Nonnull) game2.date];
            if (result == NSOrderedSame) {
                return [game1.gameId compare:(NSString * _Nonnull) game2.gameId];
            }
            else {
                return result;
            }
        }
    }] js_map:^JSGame *(JSGameEntity *game) {
        return [[JSGame alloc] initWithEntity:game placeholder:self->_placeholder];
    }];

    self.participants = ({
        NSMutableSet *set = [[NSMutableSet alloc] init];

        for (JSGame *game in allGames) {
            [set addObject:[[JSGameParticipant alloc] initWithId:game.home.teamId name:game.home.name]];
            [set addObject:[[JSGameParticipant alloc] initWithId:game.away.teamId name:game.away.name]];
        }
        [set.allObjects sortedArrayUsingComparator:^NSComparisonResult(JSGameParticipant *team1, JSGameParticipant *team2) {
            return [team1.name compare:team2.name];
        }];
    });

    self.games = _participant ? [allGames filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(JSGame *game, NSDictionary *bindings) {
        return [game.home.teamId isEqualToString:self->_participant.participantId] || [game.away.teamId isEqualToString:self->_participant.participantId];
    }]] : allGames;

    NSDate *now = NSDate.date;
    _visibleGame = 0;

    for (NSUInteger i = 0; i < self.games.count; i++) {
        JSGame *game = self.games[i];
        if (!game.date) {
            continue;
        }

        if ([game.date compare:now] == NSOrderedAscending) {
            _visibleGame = i;
        }
        else {
            break;
        }
    }
}

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient {
    self = [super initWithAPIClient:apiClient];
    if (self) {
        _participantName = NSLocalizedString(@"All teams", nil);
        _placeholder =  ({
            NSString *placeholderPath = [self.base stringByAppendingPathComponent:@"media/bearleague/teams_st.png"];
            [[NSURL alloc] initWithString:placeholderPath];
        });

        [self invalidate];
    }
    return self;
}

- (JSRequest *)request:(JSCoreDataManager *)coreDataManager {
    return [[JSCalendarRequest alloc] initWithSeasonId:self.seasonId coreDataManager:coreDataManager];
}

#pragma mark - JSSeasonedViewModel methods

- (void)reset {
    [super reset];
    self.participant = nil;
}

#pragma mark - Interface methods

- (void)setParticipant:(JSGameParticipant *)participant {
    if ([_participant isEqual:participant] || (!_participant && !participant)) {
        return;
    }
    _participant = participant;
    self.participantName = _participant.name ?: NSLocalizedString(@"All teams", nil);

    [self invalidate];
}

- (NSUInteger)visibleGame {
    return _visibleGame;
}

@end
