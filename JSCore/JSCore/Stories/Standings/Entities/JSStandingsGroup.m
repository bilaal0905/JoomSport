// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;

#import "JSStandingsGroup.h"
#import "JSStandingsRecord.h"
#import "JSStandingsGroupEntity+CoreDataClass.h"
#import "JSStandingsRecordEntity+CoreDataClass.h"

@implementation JSStandingsGroup {
    NSString *_name;
    NSArray *_records;
}

#pragma mark - Interface methods

- (instancetype)initWithEntity:(JSStandingsGroupEntity *)entity sortIndex:(NSInteger)sortIndex placeholder:(NSURL *)placeholder skipName:(BOOL)skipName {
    JSParameterAssert(entity);

    self = [super init];
    if (self) {
        _name = skipName ? nil : entity.name.copy;
        _records = [[entity.records.allObjects js_map:^JSStandingsRecord *(JSStandingsRecordEntity *recordEntity) {
            return [[JSStandingsRecord alloc] initWithEntity:recordEntity placeholder:placeholder];
        }] sortedArrayUsingComparator:^NSComparisonResult(JSStandingsRecord *record1, JSStandingsRecord *record2) {
            if (sortIndex != -1) {

                NSNumber *num1 = record1.values[sortIndex];
                NSNumber *num2 = record2.values[sortIndex];

                if (![num1 isKindOfClass:NSNull.class] && ![num2 isKindOfClass:NSNull.class]) {
                    return [num2 compare:num1];
                }
                else {
                    return [record2.valuesStrings[sortIndex] compare:record1.valuesStrings[sortIndex]];
                }
            }
            else {
                return [record1.rank compare:record2.rank];
            }
        }];
    }
    return self;
}

- (NSString *)name {
    return _name;
}

- (NSArray *)records {
    return _records;
}

@end
