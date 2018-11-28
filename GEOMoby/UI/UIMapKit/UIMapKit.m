//
//  UIMapKit.m
//  GEOMoby
//
//  Created by N.D. on 08/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import "UIMapKit.h"


@interface UIMapKit() <GMSMapViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
    // Inside location logic
    BOOL m_firstLocationUpdate;
    CLLocationManager *m_locationManager;
    CLLocation* m_currentLocation;
    GMSMarker *m_google_marker;
}
@end

@implementation UIMapKit
// Check loaded key for Google API
static   BOOL  m_loadKey = NO;

-(id) initAppleMapKit
{
    if (self = [super init])
    {
        [self InitVariables];
  //      [self InitMapKIT];
        [self InitGoogleMaps];
        m_mode = UIMapKitModeAppleMaps;
    }
    return self;
}

-(id) initGoogleMapKit
{
    if (self = [super init])
    {
       
        [self InitVariables];
   //     [self InitMapKIT];
        [self InitGoogleMaps];
        m_mode = UIMapKitModeGoogleMaps;
    }
    return self;
}

-(void) dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    m_mapKit = nil;
    m_mapView = nil;
    [self StopLocationManager];
    
}

-(void) InitVariables
{
    m_mapView =NULL;
    m_mapKit = NULL;
    m_locationManager = NULL;
    m_currentLocation = NULL;
    m_firstLocationUpdate = NO;
    m_google_marker = NULL;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bringToForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void) InitGoogleMaps
{
    if (!m_loadKey)
        m_loadKey = [GMSServices provideAPIKey:kAPIKey];
   
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    m_mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    m_mapView.delegate = self;
    m_mapView.settings.compassButton = NO;
    m_mapView.settings.myLocationButton = NO;
    m_mapView.myLocationEnabled = YES;
 

    

}

-(void) InitMapKIT
{
    m_mapKit = [[MKMapView alloc] init];
    m_mapKit.showsUserLocation = YES;
    m_mapKit.delegate = self;
    [m_mapKit setUserTrackingMode:MKUserTrackingModeFollow animated:YES];

}

-(void)bringToForeground:(NSNotification*)note
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->m_firstLocationUpdate = NO;
        [self SetCurrentLocation:self->m_mapView.myLocation];
    });
}

-(UIView*) view
{
    if (m_mode == UIMapKitModeAppleMaps)
        if (m_mapKit)
            return m_mapKit;
    if (m_mode == UIMapKitModeGoogleMaps)
        if (m_mapView)
            return m_mapView;
    
    return  NULL;
}

-(UIMapKitMode) getMapKitMode
{
    return m_mode;
}

-(void) setMapKitMode:(UIMapKitMode)_mode
{
    m_mode = _mode;
}

-(void) SetConstraints:(UIView*) _superview
{
    UIView *view = NULL;
    if (m_mode == UIMapKitModeAppleMaps)
        if (m_mapKit)
            view = m_mapKit;
    
    if (m_mode == UIMapKitModeGoogleMaps)
        if (m_mapView)
            view = m_mapView;
    
    if(view)
    {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
        [_superview addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:view
                                                  attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_superview attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
        [_superview addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:view
                                                  attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_superview attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        [_superview addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:view
                                                  attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_superview attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        [_superview addConstraint:constraint];
    }
    
}

- (void) RemoveAllConstraints
{
    UIView *view = [self view];
    
    if (view)
    {
        UIView *superview = view.superview;
        while (superview != nil) {
            for (NSLayoutConstraint *c in superview.constraints) {
                if (c.firstItem == view || c.secondItem == view) {
                    [superview removeConstraint:c];
                }
            }
            superview = superview.superview;
        }
        
        [view removeConstraints:view.constraints];
        view.translatesAutoresizingMaskIntoConstraints = YES;
        [view removeFromSuperview];
    }
}
-(void) setMapShowMode:(int) _mode
{
    if (m_mapKit)
    {
        if (_mode == 0) {
            m_mapKit.mapType = MKMapTypeStandard;
        } else if (_mode == 1) {
            m_mapKit.mapType = MKMapTypeHybrid;
        } else if (_mode == 2) {
            m_mapKit.mapType = MKMapTypeSatellite;
        }
    }
    
    if(m_mapView)
    {
        if (_mode == 0) {
            [m_mapView setMapType:kGMSTypeNormal];
        } else if (_mode == 1) {
            [m_mapView setMapType:kGMSTypeHybrid];
        } else if (_mode == 2) {
            [m_mapView setMapType:kGMSTypeSatellite];
        }
        
    }
}



#pragma mark - Location Logic -
-(void) InitLocationManager
{
    if ([CLLocationManager locationServicesEnabled] )
    {
        if (m_locationManager == nil )
        {
            m_locationManager = [[CLLocationManager alloc] init];
            m_locationManager.delegate = self;
            m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            m_locationManager.distanceFilter = kCLDistanceFilterNone; 
        }
        
        [m_locationManager requestWhenInUseAuthorization];
        if ([CLLocationManager locationServicesEnabled])  {
            [m_locationManager startUpdatingLocation];
        }
    }
}

-(void) StopLocationManager
{
    if ([CLLocationManager locationServicesEnabled] )
    {
        if (m_locationManager != NULL )
        {
            [m_locationManager stopUpdatingLocation];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

  
        [self SetCurrentLocation:[locations lastObject]];
    
}

-(void) SetCurrentLocation:(CLLocation*) _location
{
    if (!m_firstLocationUpdate)
    {
        m_currentLocation = _location;
        if(_location)
        {
            if (m_mode == UIMapKitModeAppleMaps)
                if (m_mapKit)
                {
                    CLLocationCoordinate2D center= CLLocationCoordinate2DMake(_location.coordinate.latitude, _location.coordinate.latitude);
                    MKCoordinateRegion region =   MKCoordinateRegionMake(center, MKCoordinateSpanMake( 0.1, 0.1));
                    region.center = m_mapKit.userLocation.coordinate;
                    [m_mapKit setRegion:region animated:YES];
                }
            
            if (m_mode == UIMapKitModeGoogleMaps)
                if (m_mapView)
                {
                    m_mapView.camera = [GMSCameraPosition cameraWithTarget:_location.coordinate zoom:14];
                    m_google_marker.position = CLLocationCoordinate2DMake(_location.coordinate.latitude, _location.coordinate.longitude);
                }
        }
        m_firstLocationUpdate = YES;
    }
}



-(CLLocation*) getCurrentLocation
{
    if (m_mode == UIMapKitModeAppleMaps)
        if (m_mapKit)
            return m_mapKit.userLocation.location;
    
    if (m_mode == UIMapKitModeGoogleMaps)
        if (m_mapView)
            return m_mapView.myLocation;
    
    return NULL;
}

@end
