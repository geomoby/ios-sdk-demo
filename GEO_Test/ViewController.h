//
//  ViewController.h
//  GEO_Test
//
//  Created by admin on 30.01.17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Geomoby/Geomoby.h>

@interface ViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *intervalLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet UILabel *avgSpeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (strong, nonatomic) IBOutlet UILabel *scanLabel;
@property (strong, nonatomic) IBOutlet UILabel *reportLabel;
@property (strong, nonatomic) UILongPressGestureRecognizer *lpgr;

@end

