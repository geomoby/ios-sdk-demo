//
//  GeolocationManager.m
//  GEO_Test
//
//  Created by admin on 19.09.17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "GeolocationManager.h"

@implementation GeolocationManager

// Instance
static GeolocationManager *sharedInstance = nil;

// Constants
NSString* const APPKEY = @"XXXXXXXX";
NSString* const UUID = @"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";




// Create instance
+ (GeolocationManager *)createInstanceWithTags:(NSDictionary*)tags andDelegate:(id<GeomobyDelegate>)delegate
{
    if (!sharedInstance)
    {
        sharedInstance = [[GeolocationManager alloc] initWithTags:tags andDelegate:delegate];
    }
    else
    {
        NSLog(@"GeolocationManager instance has been already created! You can use [sharedInstance] for accessing it.");
    }
    return sharedInstance;
}




// Get instance
+ (GeolocationManager *)sharedInstance
{
    if (!sharedInstance)
    {
        NSLog(@"GeolocationManager instance is not created! Use [createInstanceWithTags: andDelegate:] for accessing it.");
        sharedInstance = [[GeolocationManager alloc] initWithTags:nil andDelegate:nil];
    }
    return sharedInstance;
}




// Constructor (app key is nessesary)
- (id)initWithTags:(NSDictionary*)tags andDelegate:(id<GeomobyDelegate>)delegate
{
    if (self = [super init])
    {
        _mGeomoby = [[Geomoby alloc] initWithAppKey:APPKEY];
        [_mGeomoby setDevMode:true];
        [_mGeomoby setUUID:UUID];
        [_mGeomoby setSilenceWindowStart:23 andStop:5];
        [_mGeomoby setTags:tags];
        [_mGeomoby setDelegate:delegate];
    }
    return self;
}



// Start
- (void)start
{
    [_mGeomoby start];
}




// Stop
- (void)stop
{
    [_mGeomoby stop];
}




// Set tags
- (void)setTags:(NSDictionary*)tags
{
    [_mGeomoby setTags:tags];
}

@end
