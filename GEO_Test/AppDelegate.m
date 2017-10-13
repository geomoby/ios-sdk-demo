//
//  AppDelegate.m
//  GEO_Test
//
//  Created by admin on 30.01.17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@end




@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Notifications permission
    UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max)
        [FIRMessaging messaging].delegate = self;
    else
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTokenRefresh) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    // Firebase init
    [FIRApp configure];


    // Last report timer
    _mFirstSend = false;
    [self updateReportTime];


    // Geomoby init
    NSDictionary *tags = @{
                           @"gender" : @"female",
                           @"age" : @"25",
                           @"membership" : @"gold"
                           };
    
    // First usage of class should be createInstance
    [[Geomoby alloc] initWithAppKey:@"ATPRBM2R"];
    [[Geomoby sharedInstance]  setDevMode:true];
    [[Geomoby sharedInstance]  setUUID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [[Geomoby sharedInstance]  setSilenceWindowStart:23 andStop:5];
    [[Geomoby sharedInstance]  setTags:tags];
    [[Geomoby sharedInstance]  setDelegate:self];
    
    // Geomoby start
    [[Geomoby sharedInstance] start];
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {}




- (void)applicationDidEnterBackground:(UIApplication *)application {}




- (void)applicationWillEnterForeground:(UIApplication *)application {}




- (void)applicationDidBecomeActive:(UIApplication *)application {}




- (void)applicationWillTerminate:(UIApplication *)application {}




// Registered notification
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"Registered");
    [self subscribeToTopic];
}




// Set APNS Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[FIRMessaging messaging] setAPNSToken:deviceToken type:FIRMessagingAPNSTokenTypeSandbox];
}




// Recieve remote notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification");
    [self onMessageReceived:userInfo];
}




// Recieve remote notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"didReceiveRemoteNotification fetchCompletionHandler");
    [self onMessageReceived:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}




// Receive token
- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken
{
    [self onTokenRefresh];
}




// Receive remote data
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage
{
    NSLog(@"didReceiveMessage");
    [self onMessageReceived:[remoteMessage appData]];
}




// Subscribe to topic
- (void)subscribeToTopic
{
    NSLog(@"Subscribing...");
    [FIRMessaging messaging].shouldEstablishDirectChannel = YES;
    [[FIRMessaging messaging] subscribeToTopic:@"/topics/GeomobySync"];
}




// Token refresh
- (void)onTokenRefresh
{
    NSString *token = [[FIRInstanceID instanceID] token];
    [[Geomoby sharedInstance] updateInstanceId:token];
    [self subscribeToTopic];
}




// Receive message
- (void)onMessageReceived:(NSDictionary *)data
{
    NSLog(@"Message received - %@", data);
    if (data[@"MessageType"] && [data[@"MessageType"] isEqualToString:@"GeomobySyncRequest"])
    {
        [[Geomoby sharedInstance] updateFences];
    }
}




// Enter event callback
-(void)eventEnterCallback:(NSString *)name
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0f];
            notification.alertBody = [NSString stringWithFormat:@"Entered location - %@", name];
            notification.alertAction = @"Ok";
            notification.soundName = UILocalNotificationDefaultSoundName;
            //[[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Event triggered!"
                                                            message: [NSString stringWithFormat:@"Entered location - %@", name]
                                                           delegate: nil
                                                  cancelButtonTitle: @"Ok"
                                                  otherButtonTitles: nil, nil];
            //[alert show];
        }
    });
}




// Exit event callback
-(void)eventExitCallback:(NSString *)name
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0f];
            notification.alertBody = [NSString stringWithFormat:@"Exited location - %@", name];
            notification.alertAction = @"Ok";
            notification.soundName = UILocalNotificationDefaultSoundName;
            //[[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Event triggered!"
                                                            message: [NSString stringWithFormat:@"Exited location - %@", name]
                                                           delegate: nil
                                                  cancelButtonTitle: @"Ok"
                                                  otherButtonTitles: nil, nil];
            //[alert show];
        }
    });
}




// Dwell event callback
-(void)eventDwellCallback:(NSString *)name
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0f];
            notification.alertBody = [NSString stringWithFormat:@"Dwelled in location - %@", name];
            notification.alertAction = @"Ok";
            notification.soundName = UILocalNotificationDefaultSoundName;
            //[[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else
        {
	        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Event triggered!"
                                                            message: [NSString stringWithFormat:@"Dwelled in location - %@", name]
                                                           delegate: nil
                                                  cancelButtonTitle: @"Ok"
                                                  otherButtonTitles: nil, nil];
            //[alert show];
        }
    });
}




// Cross event callback
-(void)eventCrossCallback:(NSString *)name
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0f];
            notification.alertBody = [NSString stringWithFormat:@"Crossed location - %@", name];
            notification.alertAction = @"Ok";
            notification.soundName = UILocalNotificationDefaultSoundName;
            //[[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Event triggered!"
                                                            message: [NSString stringWithFormat:@"Crossed location - %@", name]
                                                           delegate: nil
                                                  cancelButtonTitle: @"Ok"
                                                  otherButtonTitles: nil, nil];
            //[alert show];
        }
    });
}




// Action basic callback
-(void)actionBasicCallback:(GeomobyActionBasic *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0f];
            notification.alertBody = [NSString stringWithFormat:@"Body - %@, Title - %@", [message getTitle], [message getBody]];
            notification.alertAction = @"Ok";
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [message getTitle]
                                                            message: [message getBody]
                                                           delegate: nil
                                                  cancelButtonTitle: @"Ok"
                                                  otherButtonTitles: nil, nil];
            [alert show];
        }
    });
}




// Action data callback
-(void)actionDataCallback:(GeomobyActionData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0f];
            notification.alertBody = [NSString stringWithFormat:@"Key1 - %@, Key1 - %@", [data getValue:@"Key1"], [data getValue:@"Key2"]];
            notification.alertAction = @"Ok";
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [data getValue:@"Key1"]
                                                            message: [data getValue:@"Key2"]
                                                           delegate: nil
                                                  cancelButtonTitle: @"Ok"
                                                  otherButtonTitles: nil, nil];
            [alert show];
        }
    });
}




-(void)updatedInitLocation:(CLLocation *)location
{
    
}


-(void)updatedInterval:(int)interval
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ViewController *controller = (ViewController*)self.window.rootViewController;
        controller.intervalLabel.text = [NSString stringWithFormat:@"%is", interval];
    });
}


-(void)updatedDistanceToNearestFence:(double)distance inside:(int)flag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *status = @"out";
        if (flag)status = @"in";
        
        ViewController *controller = (ViewController*)self.window.rootViewController;
        if (distance < DBL_MAX / 2.0)
            controller.distanceLabel.text = [NSString stringWithFormat:@"%.02fm (%@)", distance, status];
        else
            controller.distanceLabel.text = [NSString stringWithFormat:@"N/Am (%@)", status];
    });
}


-(void)reportSent
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_mFirstSend) _mFirstSend = true;
        _mTimeFromLastReport = 0;
    });
}


-(void)updatedBeaconScan:(bool)flag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ViewController *controller = (ViewController*)self.window.rootViewController;
        if (flag)
            controller.scanLabel.text = @"true";
        else
            controller.scanLabel.text = @"false";
    });
}


-(void)updatedSpeed:(float)speed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ViewController *controller = (ViewController*)self.window.rootViewController;
        controller.speedLabel.text = [NSString stringWithFormat:@"%.02fm", speed];
    });
}


-(void)updatedAvgSpeed:(float)avgspeed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ViewController *controller = (ViewController*)self.window.rootViewController;
        controller.avgSpeedLabel.text = [NSString stringWithFormat:@"%.02fm", avgspeed];
    });
}


-(void)updatedGPSAccuracy:(float)acuracy
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ViewController *controller = (ViewController*)self.window.rootViewController;
        controller.accuracyLabel.text = [NSString stringWithFormat:@"%.02fm", acuracy];
    });
}

-(void)updateReportTime
{
    _mTimeFromLastReport++;
    if (_mFirstSend)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ViewController *controller = (ViewController*)self.window.rootViewController;
            controller.reportLabel.text = [NSString stringWithFormat:@"%is", _mTimeFromLastReport];
        });
    }
    
    // Update again after second
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self updateReportTime];
    });
}

@end
