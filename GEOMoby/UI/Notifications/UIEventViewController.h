//
//  UIEventViewController.h
//  GEOMoby
//
//  Created by N.D. on 09/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    EventBackFonCayn,
    EventBackFonBlue,
    EventBackFonGreen,
    EventBackFonPurple,
} BackFonImageColor;

@interface UIEventViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backFonImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *textLable;

-(void)setBackFon:(BackFonImageColor)_color;

@end
