//
//  UIMainViewController.h
//  GEOMoby
//
//  Created by N.D. on 07/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SlideNavigationController.h"
#import "MainContract.h"

@interface UIMainViewController : UIViewController<SlideNavigationControllerDelegate,MainViewDelegate,UIAlertViewDelegate>

@end
