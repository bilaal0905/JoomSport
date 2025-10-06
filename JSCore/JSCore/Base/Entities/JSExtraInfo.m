// Created for BearDev by drif
// drif@mail.ru

@import JSUtils.JSLog;

#import "JSExtraInfo.h"

@implementation JSExtraInfo {
    NSString *_name;
    NSString *_value;
    NSURL *_url;
    NSURL *_imageURL;
}

#pragma mark - NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"JSExtrasInfo.name"];
    [coder encodeObject:_value forKey:@"JSExtrasInfo.value"];
    [coder encodeObject:_url forKey:@"JSExtrasInfo.url"];
    [coder encodeObject:_imageURL forKey:@"JSExtrasInfo.imageURL"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"JSExtrasInfo.name"];
        _value = [coder decodeObjectForKey:@"JSExtrasInfo.value"];
        _url = [coder decodeObjectForKey:@"JSExtrasInfo.url"];
        _imageURL = [coder decodeObjectForKey:@"JSExtrasInfo.imageURL"];
    }
    return self;
}

#pragma mark - Interface methods

- (instancetype)initWithName:(NSString *)name value:(NSString *)value type:(NSString *)type {
    JSParameterAssert(name);
    JSParameterAssert(value);

    self = [super init];
    if (self) {
        _name = name.copy;

        if (!type || [type isEqualToString:@"text"]) {
            _value = value.copy;
        }
        else if ([type isEqualToString:@"link"]) {
            _url = [NSURL URLWithString:value];
            if (!_url) {
                _value = value.copy;
            }
        }
        else if ([type isEqualToString:@"image"]) {
            _imageURL = [NSURL URLWithString:value];
        }
        else {
            JSParameterAssert(nil);
        }
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name value:(NSString *)value image:(NSString *)image {
    JSParameterAssert(name);
    JSParameterAssert(value);
    JSParameterAssert(image);

    self = [super init];
    if (self) {
        _name = name.copy;
        _value = value.copy;
        _imageURL = [NSURL URLWithString:image];
    }
    return self;
}

- (NSString *)name {
    return _name;
}

- (NSString *)value {
    return _value;
}

- (NSURL *)url {
    return _url;
}

- (NSURL *)imageURL {
    return _imageURL;
}

@end
