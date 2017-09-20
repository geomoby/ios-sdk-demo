//
//  ViewController.m
//  GEO_Test
//
//  Created by admin on 30.01.17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

enum TAGS {
    TAGS_SELECTION = 1
};



- (void)viewDidLoad {
    [super viewDidLoad];
    _mapview.delegate = self;
    _mapview.showsUserLocation = YES;
    
    _lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    _lpgr.minimumPressDuration = 1.0f;
    _lpgr.allowableMovement = 100.0f;
    
    [self.view addGestureRecognizer:_lpgr];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




- (IBAction)setMap:(id)sender {
    switch (((UISegmentedControl *)sender).selectedSegmentIndex){
        case 0:
            _mapview.mapType = MKMapTypeStandard;
            break;
            
        case 1:
            _mapview.mapType = MKMapTypeSatellite;
            break;
            
        case 2:
            _mapview.mapType = MKMapTypeHybrid;
            
        default:
            break;
    }
}




-(void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:_lpgr])
    {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Select tags"
                                                                message:@"Select tags from list"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Tags(female, 25, gold)", @"Tags(male, 27, silver)", @"Tags(female, 22, bronze)", nil];
            alertView.tag = TAGS_SELECTION;
            [alertView show];
        }
    }
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TAGS_SELECTION)
    {
        switch (buttonIndex) {
            case 1:
            {
                NSDictionary *tags = @{
                                       @"gender" : @"female",
                                       @"age" : @"25",
                                       @"membership" : @"gold"
                                       };
                [[Geomoby sharedInstance] setTags:tags];
                break;
            }
                
            case 2:
            {
                NSDictionary *tags = @{
                                       @"gender" : @"male",
                                       @"age" : @"27",
                                       @"membership" : @"silver"
                                       };
                [[Geomoby sharedInstance] setTags:tags];
                break;
            }

            case 3:
            {
                NSDictionary *tags = @{
                                       @"gender" : @"female",
                                       @"age" : @"22",
                                       @"membership" : @"bronze"
                                       };
                [[Geomoby sharedInstance] setTags:tags];
                break;
            }
        }
    }
}

@end
