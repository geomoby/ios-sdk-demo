//
//  UIFenceNotificationView.m
//  GEOMoby
//
//  Created by N.D. on 09/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import "UIFenceNotificationView.h"

@implementation UIFenceNotificationView

-(id) init
{
    if (self = [super init])
    {
        [self InitXIB];
    }
    return  self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self InitXIB];
    }
    return  self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {

    }
    return  self;
}

-(void) InitXIB
{
    [[NSBundle mainBundle] loadNibNamed:@"UIFenceNotification" owner:self options:nil];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.contentView];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                  attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                              attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                              attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                              attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    [self addConstraint:constraint];
    
   // self.contentView.frame = self.bounds;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = true;
}


-(void) changeWidth:(int) _width
{
    self.frame = CGRectMake(20, 80, _width - 40, self.frame.size.height);
    self.contentView.frame = self.bounds;
}
@end
