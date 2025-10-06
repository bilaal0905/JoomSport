// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSGameParticipant.h"

@implementation JSGameParticipant {
    NSString *_participantId;
    NSString *_name;
}

#pragma mark - NSObject methods

- (NSUInteger)hash {
    return _participantId.hash;
}

- (BOOL)isEqual:(id)other {
    if (self == other) {
        return YES;
    }

    if (![[other class] isEqual:self.class]) {
        return NO;
    }

    return [_participantId isEqualToString:((JSGameParticipant *)other).participantId];
}

#pragma mark - Interface methods

- (instancetype)initWithId:(NSString *)participantId name:(NSString *)name {
    JSParameterAssert(participantId);
    JSParameterAssert(name);

    self = [super init];
    if (self) {
        _participantId = participantId.copy;
        _name = name.copy;
    }
    return self;
}

- (NSString *)participantId {
    return _participantId;
}

- (NSString *)name {
    return _name;
}

@end
