// Created for BearDev by drif
// drif@mail.ru

//@import JSUtils;
#import "/Users/user/Downloads/BaernerCup/BaernerCup 2023/JSUtils/JSUtils/Supporting Files/JSUtils.h"

#import "JSHTTPRequest.h"

@implementation JSHTTPRequest {
    NSString *_path;
    NSURLComponents *_urlComponents;

    NSError *_error;
    NSDictionary *_json;
}

#pragma mark - Interface methods

- (instancetype)initWithPath:(NSString *)path params:(NSDictionary *)params {
    JSParameterAssert(path);

    self = [super init];
    if (self) {
        _expectsResponse = YES;
        _path = path.copy;
        _urlComponents = !params.count ? nil : ({
            NSURLComponents *components = [[NSURLComponents alloc] init];
            components.queryItems = [params.allKeys js_map:^NSURLQueryItem *(NSString *key) {
                return [[NSURLQueryItem alloc] initWithName:key value:params[key]];
            }];
            components;
        });
    }
    return self;
}

- (NSURL *)url:(NSURL *)base {
    NSURL *adjustedURL = [base URLByAppendingPathComponent:_path];
    return _urlComponents ? [_urlComponents URLRelativeToURL:adjustedURL] : adjustedURL;
}

- (void)process:(NSError *)error {
    _error = error;
}

- (void)process:(NSDictionary *)json data:(NSData *)data {
    _json = json;
}

- (NSError *)error {
    return _error;
}

- (NSDictionary *)json {
    return _json;
}

@end
