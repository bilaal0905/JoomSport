// Created for BearDev by drif
// drif@mail.ru

@import JSHTTP;

#import "NSError+JSCore.h"

@implementation NSError (JSCore)

#pragma mark - Interface methods

- (NSString *)js_error {
    if ([self.domain isEqualToString:JSHTTPClientError]) {
        JSHTTPClientErrorCode code = self.code;

        switch (code) {
            case JSHTTPClientErrorCodeInternalServerError:
                return NSLocalizedString(@"Internal sever error", nil);

            case JSHTTPClientErrorCodeInvalidResponse:
                return NSLocalizedString(@"Received inappropriate response", nil);
        }
    }
    else if ([self.domain isEqualToString:NSURLErrorDomain]) {

        switch (self.code) {
            case NSURLErrorNotConnectedToInternet:
                return NSLocalizedString(@"Check your Internet connection", nil);

            default:
                return NSLocalizedString(@"Network error", nil);
        }
    }
    else {
        return NSLocalizedString(@"Unknown error", nil);
    }
}

@end
