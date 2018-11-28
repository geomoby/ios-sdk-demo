//
//  GeomobyFenceView.h
//  Geomoby
//
//  Created by N.D. on 13/08/2018.
//  Copyright © 2018 Geomoby. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface GeomobyGeometryItem:NSObject
@property int geometry_id;
@property (nonatomic) NSMutableArray* points;
@end

@interface GeomobyFenceView : NSObject

@property NSString *name;
@property NSString *type;
@property float radius;
@property (nonatomic) NSArray* geometries;
@end
