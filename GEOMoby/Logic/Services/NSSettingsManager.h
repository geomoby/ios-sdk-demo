//
//  NSSettingsManger.h
//  GEOMoby
//
//  Created by N.D. on 08/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSettingsManager : NSObject

+ (id)sharedInstance;
-(void) setValue:(NSString*) _key string:(NSString*)_value;
-(void) setValue:(NSString*) _key    int:(int)      _value;
-(void) setValue:(NSString*) _key  float:(float)    _value;
-(void) setValue:(NSString*) _key   bool:(BOOL)     _value;

-(NSString*) getValueString:(NSString*) _key;
-(int)       getValueInt:(NSString*) _key;
-(float)     getValueFloat:(NSString*) _key;
-(BOOL)      getValueBool:(NSString*) _key;

-(BOOL) WriteToFile:(NSString*) _path;
-(BOOL) LoadFromFile:(NSString*) _path;
-(BOOL) WriteToFile;
-(BOOL) LoadFromFile;
@end
