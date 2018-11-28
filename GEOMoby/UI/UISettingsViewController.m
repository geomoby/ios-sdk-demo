//
//  UISettingsViewController.m
//  GEOMoby
//
//  Created by N.D. on 07/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import "UISettingsViewController.h"
#import "NSSettingsManager.h"

@interface UISettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *m_mapSDK;
@property (weak, nonatomic) IBOutlet UISegmentedControl *m_mapMode;

@end

@implementation UISettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    int mapMode = [[NSSettingsManager sharedInstance] getValueInt:@"k_mapMode"];
    [_m_mapMode setSelectedSegmentIndex:mapMode];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSSettingsManager sharedInstance] WriteToFile];
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

- (IBAction)mapModeChange:(id)sender {
    [[NSSettingsManager sharedInstance] setValue:@"k_mapMode" int:(int)_m_mapMode.selectedSegmentIndex];
}

@end
