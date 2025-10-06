// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSGameTeam.h"
#import "JSGameTeamEntity+CoreDataClass.h"

@implementation JSGameTeam {
    NSString *_name;
    NSString *_score;
    NSURL *_logoURL;
    NSString *_teamId;
}

#pragma mark - Interface methods

- (instancetype)initWithEntity:(JSGameTeamEntity *)entity skipScore:(BOOL)skipScore {
    self = [super init];
    if (self) {
        _teamId = entity.teamId;
        _name = entity.name;
        _score = skipScore ? nil : entity.score;
        _logoURL = [NSURL URLWithString:(NSString * _Nonnull) entity.logoURL];
    }
    return self;
}

- (NSString *)teamId {
    return _teamId;
}

- (NSString *)name {
    return _name;
}

- (NSString *)score {
    return _score;
}

- (NSURL *)logoURL {
    return _logoURL;
}

@end
