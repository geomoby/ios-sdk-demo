//
//  AppDelegate.h
//  GEO_Test
//
//  Created by admin on 30.01.17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeolocationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeomobyDelegate>

@property (strong, nonatomic) UIWindow *window;
@property bool mFirstSend;
@property int mTimeFromLastReport;

@end

