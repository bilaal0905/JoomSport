// Created for BearDev by drif
// drif@mail.ru

//@import JSUtils;
#import "/Users/user/Downloads/BaernerCup/BaernerCup 2023/JSUtils/JSUtils/Supporting Files/JSUtils.h"

#import "JSImagesLoader.h"

@implementation JSImagesLoader {
    NSURLSession *_session;
    NSOperationQueue *_parseQueue;
    NSString *_cachesPath;
    NSMutableDictionary *_completionBlocks;
    NSMutableArray *_tasks;
}

#pragma mark - Private methods

- (NSString *)path:(NSURL *)url {
    NSString *filename = [url.absoluteString.js_md5 stringByAppendingString:@".png"];
    return [_cachesPath stringByAppendingPathComponent:filename];
}

- (void)adjustTasksPriorities {
    static NSUInteger const batchSize = 3;

    for (NSUInteger i = 0; i < _tasks.count; i++) {
        NSURLSessionTask *task = _tasks[i];

        if (i < batchSize) {
            task.priority = NSURLSessionTaskPriorityHigh;
        }
        else {
            task.priority = NSURLSessionTaskPriorityLow;
        }
    }
}

- (NSURLSessionTask *)task:(NSURL *)url path:(NSString *)path {

    JSWeakify(self);
    __block NSURLSessionTask *task;

    task = [_session dataTaskWithRequest:[[NSURLRequest alloc] initWithURL:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        JSStrongify(self);

        [self->_parseQueue addOperationWithBlock:^{
            JSStrongify(self);

            [self->_tasks removeObject:task];
            [self adjustTasksPriorities];

            UIImage *image = [[UIImage alloc] initWithData:data];
            NSData *imageData = UIImagePNGRepresentation(image);

            NSError *fileError;
            if (imageData && ![imageData writeToFile:path options:NSDataWritingAtomic error:&fileError]) {
                JSLogError(@"Error while saving image to file:\n\tpath: %@\n\turl: %@\n\terror: %@", path, url, fileError);
            }

            NSArray *blocks = self->_completionBlocks[path];
            self->_completionBlocks[path] = nil;

            dispatch_async(dispatch_get_main_queue(), ^{
                for (JSImagesLoaderCompletionBlock block in blocks) {
                    JSBlock(block, image, url);
                }
            });
        }];
    }];

    return task;
}

- (NSURLSessionTask *)task:(NSURL *)url {
    for (NSURLSessionTask *task in _tasks) {
        if ([task.originalRequest.URL isEqual:url]) {
            return task;
        }
    }
    return nil;
}

- (void)performTask:(NSURLSessionTask *)task {
    NSURLSessionTask *existingTask = [self task:task.originalRequest.URL];

    if (existingTask) {
        [_tasks removeObject:existingTask];
        [_tasks insertObject:existingTask atIndex:0];
    }
    else {
        [_tasks insertObject:task atIndex:0];
        [task resume];
    }

    [self adjustTasksPriorities];
}

#pragma mark - NSObject methods

- (void)dealloc {
    [_session invalidateAndCancel];
    [_parseQueue cancelAllOperations];
}

#pragma mark - Interface methods

- (instancetype)initWithCachesPath:(NSString *)cachesPath {
    JSParameterAssert(cachesPath);

    self = [super init];
    if (self) {
        _session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
        _completionBlocks = [[NSMutableDictionary alloc] init];
        _tasks = [[NSMutableArray alloc] init];

        _cachesPath = cachesPath.copy;
        if (![NSFileManager.defaultManager fileExistsAtPath:_cachesPath]) {
            NSError *error;
            if (![NSFileManager.defaultManager createDirectoryAtPath:_cachesPath withIntermediateDirectories:YES attributes:nil error:&error]) {
                JSLogError(@"Error while creating directory:\n\tpath: %@\n\terror: %@", _cachesPath, error);
            }
        }

        _parseQueue = ({
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            queue.qualityOfService = NSQualityOfServiceUserInitiated;
            queue.maxConcurrentOperationCount = 1;
            queue;
        });
    }
    return self;
}

- (void)image:(NSURL *)url completion:(JSImagesLoaderCompletionBlock)completionBlock {
    JSParameterAssert(url);
    JSParameterAssert(completionBlock);

    NSString *path = [self path:url];

    JSWeakify(self);
    [_parseQueue addOperationWithBlock:^{
        JSStrongify(self);

        UIImage *cachedImage = [[UIImage alloc] initWithContentsOfFile:path];

        if (cachedImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                JSBlock(completionBlock, cachedImage, url);
            });
            return;
        }

        {
            NSMutableArray *blocks = self->_completionBlocks[path];

            if (!blocks) {
                blocks = [[NSMutableArray alloc] init];
                self->_completionBlocks[path] = blocks;
            }

            [blocks addObject:[completionBlock copy]];
        }

        [self performTask:[self task:url path:path]];
    }];
}

@end
