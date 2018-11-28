//
//  AppDelegate.h
//  GEOMoby
//
//  Created by N.D. on 07/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import "Firebase.h"
#import "GEOMoby.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,FIRMessagingDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

