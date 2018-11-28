//
//  UIFenceNotificationView.h
//  GEOMoby
//
//  Created by N.D. on 09/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFenceNotificationView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *fenceDistance;
@property (weak, nonatomic) IBOutlet UILabel *coord;

-(id) init;
-(void) changeWidth:(int) _width;
@end
