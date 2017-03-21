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




- (void)viewDidLoad {
    [super viewDidLoad];
    _mapview.delegate = self;
    _mapview.showsUserLocation = YES;
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

@end
