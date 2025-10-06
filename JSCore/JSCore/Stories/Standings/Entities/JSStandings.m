// Created for BearDev by drif
// drif@mail.ru
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@import JSUtils;

#import "JSStandings.h"
#import "JSStandingsGroup.h"
#import "JSStandingsEntity+CoreDataClass.h"
#import "JSStandingsGroupEntity+CoreDataClass.h"

@implementation JSStandings {
    NSArray *_fields;
    NSArray *_groups;
}

#pragma mark - Interface methods

- (instancetype)initWithEntity:(JSStandingsEntity *)entity sortIndex:(NSInteger)sortIndex placeholder:(NSURL *)placeholder {
    JSParameterAssert(entity);

    self = [super init];
    if (self) {
        NSArray *groups = entity.groups.allObjects;
        BOOL skipName = (groups.count == 1) && [[groups.firstObject name] isEqualToString:@"0"];

        _fields = entity.fields ? [NSKeyedUnarchiver unarchiveObjectWithData:(NSData * _Nonnull) entity.fields]:nil;
        _groups = [[groups js_map:^JSStandingsGroup *(JSStandingsGroupEntity *groupEntity) {
            return [[JSStandingsGroup alloc] initWithEntity:groupEntity sortIndex:sortIndex placeholder:placeholder skipName:skipName];
        }] sortedArrayUsingComparator:^NSComparisonResult(JSStandingsGroup *group1, JSStandingsGroup *group2) {
            return [group1.name compare:group2.name];
        }];
    }
    return self;
}

- (NSArray *)fields {
    return _fields;
}

- (NSArray *)groups {
    return _groups;
}

@end
