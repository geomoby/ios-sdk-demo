//
//  UIEventViewController.m
//  GEOMoby
//
//  Created by N.D. on 09/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import "UIEventViewController.h"

@interface UIEventViewController ()

@end

@implementation UIEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBackFon:(BackFonImageColor)_color
{
    switch (_color) {
        case EventBackFonBlue:
            self.backFonImage.image = [UIImage imageNamed:@"EventBackFonBlue"];
            break;
        case EventBackFonCayn:
            self.backFonImage.image = [UIImage imageNamed:@"EventBackFonCayn"];
            break;
        case EventBackFonGreen:
            self.backFonImage.image = [UIImage imageNamed:@"EventBackFonGreen"];
            break;
        case EventBackFonPurple:
            self.backFonImage.image = [UIImage imageNamed:@"EventBackFonPurple"];
            break;
        default:
             self.backFonImage.image = [UIImage imageNamed:@"EventBackFonBlue"];
            break;
    }
}

@end
