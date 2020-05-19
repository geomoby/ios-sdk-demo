//
//  GEOMoby.m
//  GEOMoby
//
//  Created by N.D. on 07/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GEOMoby.h"


static NSString *const kAPIKey = @"46WKUL6S";

@implementation GEOMobyModel{
    NSMutableArray *m_delegates;
    NSDictionary   *m_tags;
    BOOL m_geoMobyStarted;
    BOOL m_geoMobyInit;
    NSString * m_ibeacon_uuid;
    CLLocation *m_last_current_location;
}

+ (id)sharedInstance
{
    static GEOMobyModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

-(id) init
{
    if (self = [super init])
    {
        m_delegates = [NSMutableArray new];
        m_tags = NULL;
        m_geoMobyStarted = NO;
        m_last_current_location = NULL;
       
        if ([[Geomoby alloc] initWithAppKey:kAPIKey])
        {
            [[Geomoby sharedInstance]  setDevMode:true];
            [[Geomoby sharedInstance]  setUUID:@"30cab38c-6921-43f4-b005-24af1e070ff3"];
            
            [[Geomoby sharedInstance]  setSilenceWindowStart:23 andStop:5];
            [[Geomoby sharedInstance]  setDelegate:self];
             m_geoMobyInit = YES;
            //[self a:3];
        }
    }
    return self;
}

//- (void)a:(int)buttonIndex
//{
//  
//        switch (buttonIndex) {
//            case 1:
//            {
//                NSDictionary *tags = @{
//                                       @"gender" : @"female",
//                                       @"age" : @"25",
//                                       @"membership" : @"gold"
//                                       };
//                [[Geomoby sharedInstance] setTags:tags];
//                break;
//            }
//                
//            case 2:
//            {
//                NSDictionary *tags = @{
//                                       @"gender" : @"male",
//                                       @"age" : @"27",
//                                       @"membership" : @"silver"
//                                       };
//                [[Geomoby sharedInstance] setTags:tags];
//                break;
//            }
//                
//            case 3:
//            {
//                NSDictionary *tags = @{
//                                       @"gender" : @"female",
//                                       @"age" : @"22",
//                                       @"membership" : @"bronze"
//                                       };
//                [[Geomoby sharedInstance] setTags:tags];
//                break;
//            }
//        
//    }
//}

-(void) setTags:(NSDictionary*) _tags
{
    m_tags = _tags;
    if (m_geoMobyInit)
        [[Geomoby sharedInstance]  setTags:m_tags];
}

-(void) setIBeaconUUID:(NSString*) _uuid
{
    m_ibeacon_uuid = _uuid;
    if (m_geoMobyInit)
        [[Geomoby sharedInstance]  setUUID:m_ibeacon_uuid];
}

-(void) startGeoMoby
{
    [[Geomoby sharedInstance] start];
    m_geoMobyStarted = YES;
}

-(void) stopGeoMoby
{
    [[Geomoby sharedInstance] stop];
    m_geoMobyStarted = NO;
}

-(void) updateInstanceId:(NSString *) _token
{
    if (m_geoMobyInit)
        [[Geomoby sharedInstance] updateInstanceId:_token];
}

-(CLLocation*) getCurrentLocation
{
    return m_last_current_location;
}

#pragma mark - Work with delegate -

-(void) addDelegate:(id<GEOMobyModelDelegate>) _delegate
{
    if (![m_delegates containsObject:_delegate])
    {
        [m_delegates addObject:_delegate];
    }
}

-(void) removeDelegate:(id<GEOMobyModelDelegate>) _delegate
{
    [m_delegates removeObject:_delegate];
}

#pragma mark - GeoMoby delegate -
-(void)actionBasicCallback:(GeomobyActionBasic *)message
{
    for(id<GEOMobyModelDelegate> instance in [m_delegates objectEnumerator])
    {
        [instance GEOMobyActionBasic:message];
    }
}

-(void)actionDataCallback:(GeomobyActionData *)data
{
    for(id<GEOMobyModelDelegate> instance in [m_delegates objectEnumerator])
    {
        [instance GEOMobyActionData:data];
    }
}

-(void)updatedInitLocation:(CLLocation *)location
{
    for(id<GEOMobyModelDelegate> instance in [m_delegates objectEnumerator])
    {
        [instance GEOMobyUpdatedInitLocation:location];
    }
    m_last_current_location = location;
}

-(void)updatedCurrentLocation:(CLLocation *)location
{
    for(id<GEOMobyModelDelegate> instance in [m_delegates objectEnumerator])
    {
        [instance GEOMobyUpdatedInitLocation:location];
    }
    m_last_current_location = location;
}

-(void)eventEnterCallback:(NSString *)name
{

}

-(void)eventExitCallback:(NSString *)name
{

}

-(void)eventDwellCallback:(NSString *)name
{
    
}

-(void)eventCrossCallback:(NSString *)name
{
    
}



-(void)updatedInterval:(int)interval
{
    
}

-(void)updatedDistanceToNearestFence:(double)distance inside:(int)flag
{
    for(id<GEOMobyModelDelegate> instance in [m_delegates objectEnumerator])
    {
        [instance GEOMobyUpdatedDistanceToNearestFence:distance inside:flag];
    }
}

-(void)reportSent
{
    
}

-(void)updatedBeaconScan:(bool)flag
{
    for(id<GEOMobyModelDelegate> instance in [m_delegates objectEnumerator])
    {
        [instance GEOMobyUpdatedBeaconScan:flag];
    }
}

-(void)updatedSpeed:(float)speed
{
    
}

-(void)updatedAvgSpeed:(float)avgspeed
{
    
}

-(void)updatedGPSAccuracy:(float)acuracy
{
    
}

- (void)updatedFenceList:(NSArray *)fences
{
    for(id<GEOMobyModelDelegate> instance in [m_delegates objectEnumerator])
    {
        [instance GEOMobyFenceList:fences];
    }
}
@end
