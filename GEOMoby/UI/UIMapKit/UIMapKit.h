//
//  UIMapKit.h
//  GEOMoby
//
//  Created by N.D. on 08/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
// Google API key
static NSString *const kAPIKey = @"AIzaSyC6zHFTZ7yeyKzvJ5uwJHVkKmt5Nqj0mNU";

typedef  enum{
    UIMapKitModeError = 0,
    UIMapKitModeAppleMaps = 1,
    UIMapKitModeGoogleMaps = 2
}UIMapKitMode;



@interface UIMapKit : NSObject{
    MKMapView *m_mapKit;
    GMSMapView *m_mapView;
    UIMapKitMode m_mode;
}

-(id) initAppleMapKit;
-(id) initGoogleMapKit;
-(void) InitVariables;
-(void) InitLocationManager;
-(void) StopLocationManager;
-(void) SetCurrentLocation:(CLLocation*) _location;
-(void) SetConstraints:(UIView*) _superview;
-(void) RemoveAllConstraints;
-(void) setMapShowMode:(int) _mode;
-(void) dealloc;
-(void) setMapKitMode:(UIMapKitMode)_mode;
-(CLLocation*) getCurrentLocation;
-(UIView*) view;
-(UIMapKitMode) getMapKitMode;
@end
