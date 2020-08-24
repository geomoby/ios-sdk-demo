//
//  MainPresenter.m
//  GEOMoby
//
//  Created by N.D. on 07/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

#import "Firebase.h"
#import "MainContract.h"

@implementation MainPresenter{
    __weak id<MainViewDelegate> m_viewDelgate;
    __weak GEOMobyModel*   m_geomoby;
}

-(id) init:(id<MainViewDelegate>) _view :(GEOMobyModel*) _geomoby
{
    if (self = [super init])
    {
        m_viewDelgate = _view;
        m_geomoby = _geomoby;
        [m_geomoby addDelegate:self];
        [m_geomoby startGeoMoby];
        
      
     }
    return self;
}

-(void) dealloc
{
    [m_geomoby removeDelegate:self];
    [m_geomoby stopGeoMoby];
   
}




-(CLLocation*) getLastCurrentLocation
{
    return [m_geomoby getCurrentLocation];
}



#pragma mark - GOEMoby Delegates -

-(void) GEOMobyActionBasic:(GeomobyActionBasic *)message
{
   
    if ([[message getTitle] compare:@"(null)"] != NSOrderedSame)
    {
         dispatch_async(dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
            {
               
                
                    [self->m_viewDelgate showNotification: [NSString stringWithFormat:@"Title - %@, Body - %@", [message getTitle], [message getBody]]];
                
                
            }
            else
            {
                [self->m_viewDelgate showAlert:[message getTitle] :[message getBody]:0];
            }
         });
        
    }
}



- (void)GEOMobyActionData:(GeomobyActionData *)message {
    if (m_viewDelgate)
    {
        if ([message getValue:@"id"])
        {
            
                
            int Id = 0;
            if ([[message getValue:@"id"] compare:@"Enter"]==0)
            {
                Id = 1;
            }

            if ([[message getValue:@"id"] compare:@"Exit"]==0)
            {
                Id = 2;
            }

            if ([[message getValue:@"id"] compare:@"Drink"]==0)
            {
                Id = 3;
            }

            if ([[message getValue:@"id"] compare:@"Offer"]==0)
            {
                Id = 4;
            }
             dispatch_async(dispatch_get_main_queue(), ^{
                if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground)
                {
                    [self->m_viewDelgate showAlert:@"Data Action Received!" :@"":Id];
                    
                }
                else
                {
                    [self->m_viewDelgate showNotificationWithKey:@"Data Action Received!":Id];
                }
             });
            
        }
    }
    
  
        
    
}

- (void)GEOMobyUpdatedInitLocation:(CLLocation *)location {
    if (m_viewDelgate)
    {
         //[self sendNotification: [NSDictionary new]]; // FOR TESTING PURPOSES ONLY - CHECK THAT SLC IS WORKING!
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground)
            {
                [self->m_viewDelgate updateCurrentLoction:location];
            }
        });
    }
}

- (void)GEOMobyUpdatedDistanceToNearestFence:(double)distance inside:(int)flag { 
    if (m_viewDelgate)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

            [self->m_viewDelgate updateDistanceToFence:distance * (flag!=0 ? -1:1 )];
        });
    }
}

-(void) GEOMobyUpdatedBeaconScan:(bool)flag
{
    if (m_viewDelgate)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

             [self->m_viewDelgate updateBeaconScane:flag];
        });
    }
}

-(void) GEOMobyFenceList:(NSArray *)fanceView
{
    if (m_viewDelgate)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self->m_viewDelgate clearRegions];
           
            for(GeomobyFenceView *view in [fanceView objectEnumerator])
            {
                [self->m_viewDelgate addRegion:view];
            }
            
            [self->m_viewDelgate generatePolygoneOnMap];
        });
    }
}


- (void)sendNotification: (NSDictionary *) dict {
    if (@available(iOS 10.0, *)) {
    UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
        objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"Notification!" arguments:nil];
        objNotificationContent.body = (dict) ? [NSDate date].description :[NSString localizedUserNotificationStringForKey:@"SLC update!"arguments:nil];
    objNotificationContent.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSDate date].description
                                                                          content:objNotificationContent trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
    }
}

@end
