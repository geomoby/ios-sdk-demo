//
//  UIMapKit+UIMapKitPolygones.h
//  GEOMoby
//
//  Created by N.D. on 08/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import "UIMapKit.h"


typedef  enum{
    UIObjectsMapKitPolygon = 0,
    UIObjectsMapKitCircle = 1,
    UIObjectsMapKitBeacon = 2,
    UIObjectsMapKitLine = 3
}UIObjectsMapKitType;

@interface UIObjectsMapKit :UIMapKit


-(BOOL) AddObject:(UIObjectsMapKitType)_type :(int) _index;
-(BOOL) IsContainObject:(int) _index;
-(BOOL) SetColor:(int) _index :(UIColor*) _borderColor :(UIColor*) _fillColor;
-(BOOL) SetTitle:(int) _index :(NSString*) _title;
-(BOOL) SetRadius:(int) _index :(float) _radius;
-(BOOL) AddPoint:(int) _index :(CLLocation*) _location;
-(BOOL) ClearPoints:(int) _index;
-(void) ClearObjects:(BOOL) _withMap;
-(void) SetDrawObjects:(BOOL) _mode;
-(BOOL) GetDrawObjects;
-(void) GenerateObjects;
@end
