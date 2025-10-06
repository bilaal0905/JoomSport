// Created for BearDev by drif
// drif@mail.ru
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@import JSUtils.JSLog;

#import "JSStandingsRecord.h"
#import "JSStandingsRecordEntity+CoreDataClass.h"
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@implementation JSStandingsRecord {
    NSNumber *_rank;
    NSString *_rankString;
    NSString *_teamId;
    NSString *_teamName;
    NSURL *_teamLogoURL;
    NSURL *_placeholder;
    NSArray *_values;
    NSArray *_valuesStrings;
}

#pragma mark - Interface methods

- (instancetype)initWithEntity:(JSStandingsRecordEntity *)entity placeholder:(NSURL *)placeholder {
    JSParameterAssert(entity);
    JSParameterAssert(placeholder);

    self = [super init];
    if (self) {
        _rank = @(entity.rank);
        _rankString = [_rank stringValue];
        _teamId = entity.teamId.copy;
        _teamName = entity.teamName.copy;
        _teamLogoURL = [NSURL URLWithString:(NSString * _Nonnull) entity.teamLogoURL];
        _placeholder = placeholder;
        _values = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData * _Nonnull) entity.values];
        _valuesStrings = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData * _Nonnull) entity.valuesStrings];
    }
    return self;
}

- (NSNumber *)rank {
    return _rank;
}

- (NSString *)rankString {
    return _rankString;
}

- (NSString *)teamId {
    return _teamId;
}

- (NSString *)teamName {
    return _teamName;
}

- (NSURL *)teamLogoURL {
    return _teamLogoURL;
}

- (NSURL *)placeholder {
    return _placeholder;
}

- (NSArray *)values {
    return _values;
}

- (NSArray *)valuesStrings {
    return _valuesStrings;
}

@end
