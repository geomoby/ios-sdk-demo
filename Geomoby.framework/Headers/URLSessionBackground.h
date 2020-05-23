//
//  URLSessionBackground.h
//  Geomoby
//
//  Created by Roma Melnychenko on 15.05.2020.
//  Copyright © 2020 Geomoby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EmptyCompletionBlock)(void);
typedef void(^DataCompletionBlock)(NSData* _Nullable, NSError* _Nullable );

@interface URLSessionBackground: NSObject <NSURLSessionDownloadDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

+ (instancetype)sharedInstance;
@property (strong) EmptyCompletionBlock savedCompletionHandler;

@end

NS_ASSUME_NONNULL_END
