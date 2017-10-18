//
//  AppDelegate.h
//  GEO_Test
//
//  Created by admin on 30.01.17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "Firebase.h"
#import <UIKit/UIKit.h>
#import <Geomoby/Geomoby.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeomobyDelegate, FIRMessagingDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property bool mFirstSend;
@property int mTimeFromLastReport;

@end

