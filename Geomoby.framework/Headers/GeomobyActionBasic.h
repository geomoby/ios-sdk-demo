//
//  GeomobyActionBasic.h
//  GEO_Test
//
//  Created by admin on 30.01.17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeomobyActionBasic : NSObject
{
    NSString *mTitle;
    NSString *mBody;
    NSString *mURL;
}
- (id)initWithTitle: (NSString *)title withBody: (NSString *)body withURL: (NSString *)url;
- (NSString *)getTitle;
- (NSString *)getBody;
- (NSString *)getURL;
@end