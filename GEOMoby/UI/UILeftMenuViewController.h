//
//  UILeftMenuViewController.h
//  GEOMoby
//
//  Created by N.D. on 07/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILeftMenuViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

@end
