// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;

#import "JSHTTPClient.h"
#import "JSHTTPRequest.h"

NSErrorDomain const JSHTTPClientError = @"JSHTTPClientError";

@implementation JSHTTPClient {
    NSURL *_base;
    NSURLSession *_session;
    NSOperationQueue *_parseQueue;
}

#pragma mark - Private methods

- (NSDictionary *)json:(NSData *)data {
    JSParameterAssert(data);

    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions) 0 error:&error];
    if (!jsonObject) {
        JSLogError(@"Error while parsing json data\n\terror: %@\n\tdata: %@", error, data);
        return nil;
    }

    if ([jsonObject isKindOfClass:NSDictionary.class]) {
        return jsonObject;
    }
    else {
        JSParameterAssert([jsonObject isKindOfClass:NSArray.class]);
        return @{@"root": jsonObject};
    }
}

- (NSError *)error:(NSHTTPURLResponse *)response {
    JSParameterAssert([response isKindOfClass:NSHTTPURLResponse.class]);

    if (response.statusCode == 200) {
        return nil;
    }
    else {
        return [NSError errorWithDomain:JSHTTPClientError code:JSHTTPClientErrorCodeInternalServerError userInfo:nil];
    }
}

#pragma mark - NSObject methods

- (void)dealloc {
    [_session invalidateAndCancel];
    [_parseQueue cancelAllOperations];
}

#pragma mark - Interface methods

- (instancetype)initWithBase:(NSString *)base {
    JSParameterAssert(base);

    self = [super init];
    if (self) {
        _base = [[NSURL alloc] initWithString:base];
        JSParameterAssert(_base);

        _session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];

        _parseQueue = ({
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            queue.qualityOfService = NSQualityOfServiceUserInitiated;
            queue.maxConcurrentOperationCount = 1;
            queue;
        });
    }
    return self;
}

- (void)perform:(JSHTTPRequest *)request {
    JSParameterAssert(request);

    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[request url:_base]];
    JSParameterAssert(urlRequest);

    JSWeakify(self);
    NSURLSessionTask *task = [_session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        JSStrongify(self);

        [self->_parseQueue addOperationWithBlock:^{
            JSStrongify(self);

            if (error) {
                [request process:error];
            }
            else {
                NSError *responseError = [self error:(NSHTTPURLResponse *) response];
                if (responseError) {
                    [request process:responseError];
                }
                else {
                    if (data.length > 0 && request.expectsResponse) {
                        NSDictionary *json = [self json:data];
                        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"Response JSON string: %@", jsonString);
                        if (json) {
                            [request process:json data:data];
                        }
                        else {
                            JSLogError(@"Error while processing request:\n\turl: %@", urlRequest.URL.absoluteString);
                            [request process:[NSError errorWithDomain:JSHTTPClientError code:JSHTTPClientErrorCodeInvalidResponse userInfo:nil]];
                        }
                    }
                    else {
                        // empty response with no error
                    }
                }
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                JSBlock(request.onFinish, nil);
            });
        }];
    }];

    [task resume];
}

- (NSString *)base {
    return _base.absoluteString;
}

@end
