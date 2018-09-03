//
//  GEOMoby.h
//  GEOMoby
//
//  Created by N.D. on 07/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Geomoby/Geomoby.h>
#import <UserNotifications/UserNotifications.h>


@protocol GEOMobyModelDelegate
-(void) GEOMobyActionBasic:(GeomobyActionBasic *)message;
-(void) GEOMobyActionData:(GeomobyActionData *)message;
-(void) GEOMobyFenceList:(NSArray *)fanceView;
-(void) GEOMobyUpdatedInitLocation:(CLLocation *)location;
-(void) GEOMobyUpdatedDistanceToNearestFence:(double)distance inside:(int)flag;
-(void) GEOMobyUpdatedBeaconScan:(bool)flag;

@end

@interface GEOMobyModel : NSObject<GeomobyDelegate>

+ (id)sharedInstance;
-(void) startGeoMoby;
-(void) stopGeoMoby;
-(void) setTags:(NSDictionary*) _tags;
-(void) setIBeaconUUID:(NSString*) _uuid;
-(void) updateInstanceId:(NSString *) _token;
-(void) addDelegate:(id<GEOMobyModelDelegate>) _delegate;
-(void) removeDelegate:(id<GEOMobyModelDelegate>) _delegate;
-(CLLocation*) getCurrentLocation;
@end
