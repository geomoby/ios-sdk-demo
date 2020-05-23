//
//  GeomobyActionData.h
//  GEO_Test
//
//  Created by admin on 30.01.17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeomobyActionData : NSObject
{
    NSMutableDictionary *mValues;
}
- (id)initWithData: (NSMutableDictionary *)data;
- (NSString *)getValue: (NSString *)key;
@end