//
//  AppDelegate.m
//  GEOMoby
//
//  Created by N.D. on 07/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//
#import <UserNotifications/UserNotifications.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "UILeftMenuViewController.h"
#import "NSSettingsManager.h"
#import "GEOMoby.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
 
    // Firebase configure
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;

    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter]; [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                     completionHandler:^(BOOL granted, NSError * _Nullable error) {
                     }];
    }
    
    [[NSSettingsManager sharedInstance] LoadFromFile];
    [[NSSettingsManager sharedInstance] setValue:@"k_mapSDK" int:1];

    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UILeftMenuViewController *leftMenu = (UILeftMenuViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    [[SlideNavigationController sharedInstance] setScreenSize:[UIScreen mainScreen].bounds.size];
    [SlideNavigationController sharedInstance].enableSwipeGesture = NO;
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    
    NSLog(@"token %@", [[FIRInstanceID instanceID] token]);
    [GEOMobyModel sharedInstance];
    [self updateOnSignificantLocation:launchOptions];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max)
    {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        if (@available(iOS 10.0, *)) {
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
    
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {}];
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        }
      
#endif
    }
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
     
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[Geomoby sharedInstance] applicationDidEnterBackground];
//    [self sendNotification];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[Geomoby sharedInstance] applicationWillEnterForeground];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
   
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (notification.userInfo)
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"showOffer" object:nil userInfo:notification.userInfo];
    }
}

// =======================================================================================================================
// =======================================================================================================================
// =======================================================================================================================


// Registered notification
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
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
//    NSLog(@"didReceiveRemoteNotification");
    [self onMessageReceived:userInfo];
}




// Recieve remote notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
 //   NSLog(@"didReceiveRemoteNotification fetchCompletionHandler");
//    https://api.geomoby.com/install/location?install=11901&lat=50.415520&long=30.546416&radius=10000
    [self onMessageReceived:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
//    [[URLSessionBackground2 sharedInstance] setSavedCompletionHandler:^{
//       completionHandler(UIBackgroundFetchResultNewData);
//    }];
}




- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
API_AVAILABLE(ios(10.0)){
//    NSLog(@"didReceiveNotificationResponse");
}



- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)) {
//    NSLog(@"willPresentNotification");
    [self onMessageReceived:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionNone);
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self onMessageReceived:nil];
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
//    NSLog(@"didReceiveMessage");
    [self onMessageReceived:[remoteMessage appData]];
}




// Subscribe to topic
- (void)subscribeToTopic
{
    NSLog(@"Subscribed!");
    [[FIRMessaging messaging] subscribeToTopic:@"/topics/GeomobySync"];
}




// Token refresh
- (void)onTokenRefresh
{
    NSString *token = [[FIRInstanceID instanceID] token];
    [[Geomoby sharedInstance] updateInstanceId:token];
    [self subscribeToTopic];
}

//Significant location updates
- (void)updateOnSignificantLocation: (NSDictionary *) userDict {
    if (userDict) {
        if ([userDict objectForKey: UIApplicationLaunchOptionsLocationKey]) {
            [[Geomoby sharedInstance] getFences];
            [self sendNotification: userDict];
        }
    } else {
        [[Geomoby sharedInstance] updateFences];
    }
}

- (void)sendNotification: (NSDictionary *) dict {
    if (@available(iOS 10.0, *)) {
    UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
        objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"Notification!" arguments:nil];
        objNotificationContent.body = (dict) ? [dict allKeys].description :[NSString localizedUserNotificationStringForKey:@"SLC update!"arguments:nil];
    objNotificationContent.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"ten"
                                                                          content:objNotificationContent trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
    }
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

@end
