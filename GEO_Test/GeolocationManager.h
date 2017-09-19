//
//  GeolocationManager.h
//  GEO_Test
//
//  Created by admin on 19.09.17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Geomoby/Geomoby.h>

@interface GeolocationManager : NSObject

@property (strong, nonatomic) Geomoby *mGeomoby;

extern NSString* const APPKEY;
extern NSString* const UUID;

+ (GeolocationManager *)createInstanceWithTags:(NSDictionary*)tags andDelegate:(id<GeomobyDelegate>)delegate;
+ (GeolocationManager *)sharedInstance;
- (id)initWithTags:(NSDictionary*)tags andDelegate:(id<GeomobyDelegate>)delegate;
- (void)start;
- (void)stop;
- (void)setTags:(NSDictionary*)tags;

@end
