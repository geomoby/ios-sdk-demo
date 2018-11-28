//
//  UIMainViewController.m
//  GEOMoby
//
//  Created by N.D. on 07/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import "UIMainViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "UIObjectsMapKit.h"
#import "NSSettingsManager.h"
#import "MockData.h"
#import "GEOMoby.h"
#import "UIFenceNotificationView.h"
#import "UIEventViewController.h"



@interface UIMainViewController ()
{
   CLLocationManager        *m_locationManager;
   CLLocation               *m_currentLocation;
    UIObjectsMapKit        *m_mapKit;
    UIEventViewController   *m_eventNotificator;
       MainPresenter        *m_presenter;
    __weak IBOutlet UIFenceNotificationView *m_fanceView;
    __weak IBOutlet UIView *m_ibeaconview;
    __weak IBOutlet UILabel *m_ibeaconLabel;
    
}

@end

@implementation UIMainViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    m_presenter = [[MainPresenter alloc] init:self :[GEOMobyModel sharedInstance]];   
    m_ibeaconview.layer.cornerRadius = 5;
    m_ibeaconview.layer.masksToBounds = true;
    m_eventNotificator = NULL;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [self performSelectorOnMainThread:@selector(BuildMapViews) withObject:nil waitUntilDone:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOffer:) name:UIApplicationDidFinishLaunchingNotification object:nil];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOffer:)name:@"showOffer"  object:nil];
 }

-(void)showOffer:(NSNotification*)notification{
     if (notification.userInfo[@"id"])
     {
         dispatch_async(dispatch_get_main_queue(), ^{
         [self newAction:[notification.userInfo[@"id"] intValue]];
         });
     }
}



-(void) BuildMapViews
{
    int mapSDK = [[NSSettingsManager sharedInstance] getValueInt:@"k_mapSDK"];
    switch (mapSDK) {
        case 1:
            [self BuildGoogleKit];
            break;
        default:
            [self BuildMAPKit];
            break;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
  dispatch_async(dispatch_get_main_queue(), ^{
        int mapSDK = [[NSSettingsManager sharedInstance] getValueInt:@"k_mapSDK"];
        int mapMode = [[NSSettingsManager sharedInstance] getValueInt:@"k_mapMode"];
        
        if (mapSDK == 0)
            if ([self->m_mapKit getMapKitMode] != UIMapKitModeAppleMaps)
            {
                [self->m_mapKit RemoveAllConstraints];
                [self->m_mapKit setMapKitMode:UIMapKitModeAppleMaps];
                [self.view addSubview:[self->m_mapKit view]];
                [self.view sendSubviewToBack:[self->m_mapKit view]];
                [self->m_mapKit SetConstraints:self.view];
            }
        
        if (mapSDK == 1)
            if ([self->m_mapKit getMapKitMode] != UIMapKitModeGoogleMaps)
            {
                [self->m_mapKit RemoveAllConstraints];
                [self->m_mapKit setMapKitMode:UIMapKitModeGoogleMaps];
                [self.view addSubview:[self->m_mapKit view]];
                [self.view sendSubviewToBack:[self->m_mapKit view]];
                [self->m_mapKit SetConstraints:self.view];
             }
        

        
        CLLocation *curLoc = [self->m_presenter getLastCurrentLocation];
        if (curLoc)
        {
            [self updateCurrentLoction:curLoc];
        }
        [self->m_mapKit setMapShowMode:mapMode];
  });
}


-(void) BuildMAPKit
{
    m_mapKit = [[UIObjectsMapKit alloc] initAppleMapKit];
    [self.view addSubview:[m_mapKit view]];
    [self.view sendSubviewToBack:[m_mapKit view]];
    [m_mapKit SetConstraints:self.view];
    CLLocation *curLoc = [m_presenter getLastCurrentLocation];
    if (curLoc)
    {
        [self updateCurrentLoction:curLoc];
    }
}

-(void) BuildGoogleKit
{
    m_mapKit = [[UIObjectsMapKit alloc] initGoogleMapKit];
    [self.view addSubview:[m_mapKit view]];
    [self.view sendSubviewToBack:[m_mapKit view]];
    [m_mapKit SetConstraints:self.view];
    CLLocation *curLoc = [m_presenter getLastCurrentLocation];
    if (curLoc)
    {
         [self updateCurrentLoction:curLoc];
    }
    
    [[m_mapKit view] addObserver:self forKeyPath:@"myLocation.coordinate" options:0 context:NULL];
}

-(void) dealloc
{
    [[m_mapKit view] removeObserver:self forKeyPath:@"myLocation.coordinate"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"myLocation.coordinate"]) {
        CLLocation *_location = [m_mapKit  getCurrentLocation];
        dispatch_async(dispatch_get_main_queue(), ^{
         [self->m_fanceView.coord setText:[NSString stringWithFormat:@"%f - %f",_location.coordinate.latitude,_location.coordinate.longitude]];
        });
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (UITraitCollection *)traitCollection {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return super.traitCollection;
    } else {
        if (!UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
        {
            return [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassCompact];
        }
        else
        {
            return [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];
        }
    }
}

-(void) showNotification:(NSString*)_text
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0f];
    notification.alertBody = _text;
    notification.alertAction = @"Ok";
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


-(void) showNotificationWithKey:(NSString*)_text :(int) _id
{

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0f];
    notification.alertBody = _text;
    notification.alertAction = @"Ok";
    notification.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_id], @"id",nil];
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void) showAlert:(NSString*)_title :(NSString*)_message :(int)_id
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: _title
                                                    message: _message
                                                   delegate: self
                                          cancelButtonTitle: @"Ok"
                                          otherButtonTitles: nil, nil];
    alert.tag = _id;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (alertView.tag!=0)
        {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self newAction:alertView.tag];
                });
        }
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - MainContract Methods -
-(void) updateCurrentLoction:(CLLocation *) _location
{
         [m_mapKit SetCurrentLocation:_location];
}

-(void) updateDistanceToFence:(double) _distance;
{
         [m_fanceView.fenceDistance setText:[NSString stringWithFormat:@"%d m",(int)_distance]];

}

-(void) updateBeaconScane:(bool) _state
{
        if (_state)
        {
            [m_ibeaconLabel setText:@"Beacons scanning"];
        }
        else
        {
             [m_ibeaconLabel setText:@"No beacons scanning"];
        }
}

-(void) newActionArrived:(GeomobyActionBasic*) _action
{

   
}

-(void) newAction:(int) _mode;
{
    @synchronized(self)
    {
       
        if ([SlideNavigationController sharedInstance].topViewController == m_eventNotificator)
         {
             [self.navigationController popToViewController:self animated:NO];
         }
        
        
        m_eventNotificator = [UIEventViewController new];
        [[NSBundle mainBundle] loadNibNamed:@"UIEventViewController" owner:m_eventNotificator options:nil];
        
        switch (_mode) {
            case 1:
                [m_eventNotificator setBackFon:EventBackFonCayn];
                m_eventNotificator.mainImage.image = [UIImage imageNamed:@"EventHotel"];
                m_eventNotificator.textLable.numberOfLines = 2;
                m_eventNotificator.textLable.text = @"Welcome to\nour venue";
                break;
            case 2:
                [m_eventNotificator setBackFon:EventBackFonGreen];
                m_eventNotificator.mainImage.image = [UIImage imageNamed:@"EventHand"];
                m_eventNotificator.textLable.numberOfLines = 2;
                m_eventNotificator.textLable.text = @"Good Bye and see\nyou again soon";
                break;
            case 3:
                [m_eventNotificator setBackFon:EventBackFonPurple];
                m_eventNotificator.mainImage.image = [UIImage imageNamed:@"EventDrink"];
                m_eventNotificator.textLable.numberOfLines = 2;
                m_eventNotificator.textLable.text = @"Get one drink\nfor only 5$";
                break;
            case 4:
                [m_eventNotificator setBackFon:EventBackFonBlue];
                m_eventNotificator.mainImage.image = [UIImage imageNamed:@"EventOffer"];
                m_eventNotificator.textLable.numberOfLines = 2;
                m_eventNotificator.textLable.text = @"Today's Special\noffer";
                break;
            default:
                break;
        }
       
        
        m_eventNotificator.view.frame = self.view.bounds;
        m_eventNotificator.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [m_eventNotificator.view setAlpha:0];
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->m_eventNotificator.view.transform = CGAffineTransformMakeScale(1, 1);
            [self->m_eventNotificator.view setAlpha:1];
        } completion:^ (BOOL completed) {}
        ];
        
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:m_eventNotificator
                                                                 withSlideOutAnimation:YES
                                                                         andCompletion:nil];
    }
}

int g_PolygoneGlobalIndex;
-(void) clearRegions
{
    g_PolygoneGlobalIndex = 0;
    [m_mapKit ClearObjects:YES];
}

-(void) generatePolygoneOnMap
{
    [m_mapKit GenerateObjects];
}

-(void) addRegion:(GeomobyFenceView*) _fenceView
{
    if ([_fenceView.type compare:@"polygon"] == NSOrderedSame)
    {
        for (GeomobyGeometryItem *geomentry in [_fenceView.geometries objectEnumerator]) {
            [m_mapKit AddObject:UIObjectsMapKitPolygon: g_PolygoneGlobalIndex];
            [m_mapKit SetColor:g_PolygoneGlobalIndex :[UIColor colorWithRed:0 green:0.72 blue:0.85 alpha:1] :[UIColor colorWithRed:0 green:0.72 blue:0.85 alpha:0.5]];
            [m_mapKit SetTitle:g_PolygoneGlobalIndex :_fenceView.name];
            for (CLLocation *loc in [geomentry.points objectEnumerator])
                [m_mapKit AddPoint:g_PolygoneGlobalIndex :loc];
             g_PolygoneGlobalIndex ++;
        }
    }
    
    if ([_fenceView.type compare:@"point"] == NSOrderedSame)
    {
        for (GeomobyGeometryItem *geomentry in [_fenceView.geometries objectEnumerator]) {
            [m_mapKit AddObject:UIObjectsMapKitCircle: g_PolygoneGlobalIndex];
            [m_mapKit SetColor:g_PolygoneGlobalIndex :[UIColor colorWithRed:0 green:0.72 blue:0.85 alpha:1] :[UIColor colorWithRed:0 green:0.72 blue:0.85 alpha:0.5]];
            [m_mapKit SetTitle:g_PolygoneGlobalIndex :_fenceView.name];
            [m_mapKit SetRadius:g_PolygoneGlobalIndex :_fenceView.radius];
            for (CLLocation *loc in [geomentry.points objectEnumerator])
                [m_mapKit AddPoint:g_PolygoneGlobalIndex :loc];
            g_PolygoneGlobalIndex ++;
        }
    }
   
    if ([_fenceView.type compare:@"beacon"] == NSOrderedSame)
    {
        for (GeomobyGeometryItem *geomentry in [_fenceView.geometries objectEnumerator]) {
            [m_mapKit AddObject:UIObjectsMapKitBeacon: g_PolygoneGlobalIndex];
            [m_mapKit SetColor:g_PolygoneGlobalIndex :[UIColor colorWithRed:0 green:0.72 blue:0.85 alpha:0]:[UIColor colorWithRed:0 green:0.62 blue:0.95 alpha:0.06]];
            [m_mapKit SetTitle:g_PolygoneGlobalIndex :_fenceView.name];
            [m_mapKit SetRadius:g_PolygoneGlobalIndex :_fenceView.radius];
            for (CLLocation *loc in [geomentry.points objectEnumerator])
                [m_mapKit AddPoint:g_PolygoneGlobalIndex :loc];
            g_PolygoneGlobalIndex ++;
        }
    }
    if ([_fenceView.type compare:@"line"] == NSOrderedSame)
    {
        for (GeomobyGeometryItem *geomentry in [_fenceView.geometries objectEnumerator]) {
            [m_mapKit AddObject:UIObjectsMapKitLine: g_PolygoneGlobalIndex];
            [m_mapKit SetColor:g_PolygoneGlobalIndex :[UIColor colorWithRed:0 green:0.72 blue:0.85 alpha:1]:[UIColor colorWithRed:0 green:0.62 blue:0.95 alpha:0]];
            [m_mapKit SetTitle:g_PolygoneGlobalIndex :_fenceView.name];
            for (CLLocation *loc in [geomentry.points objectEnumerator])
                [m_mapKit AddPoint:g_PolygoneGlobalIndex :loc];
            g_PolygoneGlobalIndex ++;
        }
    }
}
@end
