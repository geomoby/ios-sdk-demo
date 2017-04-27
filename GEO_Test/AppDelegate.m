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
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }


    // Last report timer
    _mFirstSend = false;
    [self updateReportTime];


    // Geomoby init
    NSDictionary *tags = @{
                           @"gender" : @"female",
                           @"age" : @"25",
                           @"membership" : @"gold"
                           };
    
    _mGeomoby = [[Geomoby alloc] initWithAppKey:@"XXXXXXXX"];
    [_mGeomoby setDevMode:true];
    [_mGeomoby setUUID:@"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"];
    [_mGeomoby setSilenceWindowStart:23 andStop:5];
    [_mGeomoby setTags:tags];
    [_mGeomoby setDelegate:self];
    
    // Geomoby start
    [_mGeomoby start];
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {}




- (void)applicationDidEnterBackground:(UIApplication *)application {}




- (void)applicationWillEnterForeground:(UIApplication *)application {}




- (void)applicationDidBecomeActive:(UIApplication *)application {}




- (void)applicationWillTerminate:(UIApplication *)application
{
    // Geomoby stop
    [_mGeomoby stop];
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
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Event triggered!"
                                                            message: [NSString stringWithFormat:@"Entered location - %@", name]
                                                           delegate: nil
                                                  cancelButtonTitle: @"Ok"
                                                  otherButtonTitles: nil, nil];
            [alert show];
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
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Event triggered!"
                                                            message: [NSString stringWithFormat:@"Exited location - %@", name]
                                                           delegate: nil
                                                  cancelButtonTitle: @"Ok"
                                                  otherButtonTitles: nil, nil];
            [alert show];
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
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else
        {
	        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Event triggered!"
                                                            message: [NSString stringWithFormat:@"Dwelled in location - %@", name]
                                                           delegate: nil
                                                  cancelButtonTitle: @"Ok"
                                                  otherButtonTitles: nil, nil];
            [alert show];
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
        controller.distanceLabel.text = [NSString stringWithFormat:@"%.02fm (%@)", distance, status];
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
