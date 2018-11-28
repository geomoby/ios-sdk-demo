//
//  MainPresenter.h
//  GEOMoby
//
//  Created by N.D. on 07/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Geomoby/Geomoby.h>

#import "GEOMoby.h"

@protocol MainViewDelegate
@optional
-(void) updateCurrentLoction:(CLLocation *) _location;
-(void) updateDistanceToFence:(double) _distance;
-(void) updateBeaconScane:(bool) _state;
-(void) newActionArrived:(GeomobyActionBasic*) _action;
-(void) newAction:(int) _mode;
-(void) clearRegions;
-(void) addRegion:(GeomobyFenceView*) _fenceView;
-(void) generatePolygoneOnMap;
-(void) showAlert:(NSString*)_title :(NSString*)_message :(int)_id;
-(void) showNotification:(NSString*)_text;
-(void) showNotificationWithKey:(NSString*)_text :(int) _id;
@end


@interface MainPresenter : NSObject <GEOMobyModelDelegate,UIAlertViewDelegate>

-(id) init:(id<MainViewDelegate>) _view :(GEOMobyModel*) _geomoby;
-(void) dealloc;
-(CLLocation*) getLastCurrentLocation;
@end




