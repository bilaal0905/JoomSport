// Created for BearDev by drif
// drif@mail.ru

@import JSUtils;
@import JSCoreData;
@import JSHTTP.JSHTTPClient;

#import "JSViewModel.h"
#import "JSAPIClient.h"
#import "JSRequest.h"

@interface JSViewModel ()

@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, assign, readwrite) BOOL isUpdating;

@end

@implementation JSViewModel {
    JSAPIClient *_apiClient;
}

#pragma mark - Interface methods

- (instancetype)initWithAPIClient:(JSAPIClient *)apiClient {
    JSParameterAssert(apiClient);

    self = [super init];
    if (self) {
        _apiClient = apiClient;
        [self invalidate];
    }
    return self;
}

- (void)update {
    if (self.isUpdating) {
        return;
    }

    self.isUpdating = YES;
    self.error = nil;

    JSRequest *request = [self request:_apiClient.coreDataManager];

    JSWeakify(self);
    JSWeakify(request);

    request.onFinish = ^{

        JSStrongify(self);
        JSStrongify(request);

        if ([self skip:request]) {
            return;
        }

        [self invalidate];

        self.error = request.error;
        self.isUpdating = NO;
    };

    [_apiClient.httpClient perform:request];
}

- (void)cancel {
    self.isUpdating = NO;
}

- (void)initData:(NSManagedObjectContext *)context {}

- (JSRequest *)request:(JSCoreDataManager *)coreDataManager {
    return [[JSRequest alloc] initWithPath:nil coreDataManager:coreDataManager];
}

- (BOOL)skip:(JSRequest *)request {
    return NO;
}

- (void)invalidate {
    [self initData:_apiClient.coreDataManager.mainContext];
}

- (NSString *)base {
    return _apiClient.httpClient.base;
}

@end
