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
#import "UIMainViewController.h"
#import "SlideNavigationController.h"
#import <BackgroundTasks/BackgroundTasks.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
 
    //[[Geomoby alloc] initWithAppKey: @"46WKUL6S"];
    [GEOMobyModel sharedInstance];
    
    [self updateOnSignificantLocation:launchOptions];

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
    
    if (@available(iOS 13.0, *)) {
        [[BGTaskScheduler sharedScheduler] registerForTaskWithIdentifier:@"com.demoapp.updateFences"
                                                              usingQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                                           launchHandler:^(BGTask *task) {
            [self handleAppRefresh: task];
        }];
    }
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[Geomoby sharedInstance] applicationDidEnterBackground];
    [[Geomoby sharedInstance] updateFences];
    
    if (@available(iOS 13.0, *)) {
        [self scheduleBackgroundUpdateFences];
    }
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




// Receive remote notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self onMessageReceived:userInfo];
}




// Receive remote notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    [self onMessageReceived:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}




- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
API_AVAILABLE(ios(10.0)){
    
    [self onMessageReceived: response.notification.request.content.userInfo];
    NSInteger identifier = [response.notification.request.content.userInfo valueForKey:@"id"];
    SlideNavigationController *menu = self.window.rootViewController;
    UIMainViewController *controller = menu.topViewController;
    [controller newAction:3];
    
    NSLog(@"didReceiveNotificationResponse");
}



- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)) {
//    NSLog(@"willPresentNotification");
    [self onMessageReceived:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionNone);
}

// Background Task Scheduler
// iOS <13
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    [[Geomoby sharedInstance] updateFences];
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS >= 13
- (void)handleAppRefresh: (BGTask *) task  API_AVAILABLE(ios(13.0)) {
    [[Geomoby sharedInstance] updateFences];
    [task setTaskCompletedWithSuccess:YES];
    [self scheduleBackgroundUpdateFences];
}

- (void)scheduleBackgroundUpdateFences API_AVAILABLE(ios(13.0)) {
    NSLog(@"scheduleBackgroundUpdateFences");
    
    BGAppRefreshTaskRequest *request = [[BGAppRefreshTaskRequest alloc] initWithIdentifier:@"com.demoapp.updateFences"];
    // Fetch no earlier than 30 minutes from now
    request.earliestBeginDate = [[NSDate alloc] initWithTimeIntervalSinceNow: 10 * 60];
    NSError *error = NULL;
    BOOL success = [[BGTaskScheduler sharedScheduler] submitTaskRequest:request error: &error];
    if (!success) {
        NSLog(@"Failed to submit request: %@",error);
    }
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

// Significant location updates
- (void)updateOnSignificantLocation: (NSDictionary *) userDict {
    if (userDict) {
        if (userDict && [userDict objectForKey: UIApplicationLaunchOptionsLocationKey]) {
    
            //[self sendNotification: userDict]; // FOR TESTING PURPOSES ONLY

            [[Geomoby sharedInstance] updateFences];
            //[[Geomoby sharedInstance] applicationDidEnterBackground];
        }
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
