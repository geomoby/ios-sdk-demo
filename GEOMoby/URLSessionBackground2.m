//
//  URLSessionBackground.m
//  Geomoby
//
//  Created by Roma Melnychenko on 15.05.2020.
//  Copyright © 2020 Geomoby. All rights reserved.
//

#import "URLSessionBackground2.h"

@interface URLSessionBackground2 ()

@property (strong) DataCompletionBlock completionBlock;
@property (strong) NSURLSession * session;

@end

@implementation URLSessionBackground2

+ (instancetype)sharedInstance {
    __block URLSessionBackground2* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [URLSessionBackground2 new];
    });
    return instance;
}

- (NSURLSession*)urlSession {
    if (self.session) return self.session;
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"GeomobyBackgroundSession2"];
    [config setDiscretionary:YES];
    [config setSessionSendsLaunchEvents:YES];
    config.allowsCellularAccess = YES;
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    return self.session;
}

- (void)sendRequest:(NSURLRequest*)request completion:(DataCompletionBlock)block {
    self.completionBlock = block;
    NSLog(@"Background request :%@", request);
    [[[self urlSession] downloadTaskWithRequest:request] resume];
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
    if (self.savedCompletionHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.savedCompletionHandler();
        });
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // handle failure here
    NSLog(@"Request error %@", error.localizedDescription);
    if (self.completionBlock && error) {
        self.completionBlock(nil, error);
    }
}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    NSLog(@"Request done");
    NSData* data = [NSData dataWithContentsOfURL:location];
    if (self.completionBlock) {
        self.completionBlock(data, nil);
    }
}

@end
