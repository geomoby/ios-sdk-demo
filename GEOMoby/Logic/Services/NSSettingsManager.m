//
//  NSSettingsManger.m
//  GEOMoby
//
//  Created by N.D. on 08/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//

#import "NSSettingsManager.h"

@interface NSSettingsManager()
{
    NSMutableDictionary *m_array;
}

@end

@implementation NSSettingsManager


#pragma mark Singleton Methods

-(id) init
{
    if (self = [super init])
    {
        self->m_array = [NSMutableDictionary new];
    }
    return  self;
}

+ (id)sharedInstance {
    static NSSettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

-(void) setValue:(NSString*) _key string:(NSString*)_value
{
    m_array[_key] = _value;
}

-(void) setValue:(NSString*) _key    int:(int)      _value
{
    m_array[_key] = [NSNumber numberWithInt:_value];
    
}
-(void) setValue:(NSString*) _key  float:(float)    _value
{
    m_array[_key] = [NSNumber numberWithFloat:_value];
}

-(void) setValue:(NSString*) _key  bool:(BOOL)     _value
{
    m_array[_key] = [NSNumber numberWithBool:_value];
}

-(NSString*) getValueString:(NSString*) _key
{
    if(m_array[_key])
    {
        return (NSString*)m_array[_key];
    }
    else
        return  NULL;
}

-(int)       getValueInt:(NSString*) _key
{
    if(m_array[_key])
    {
        return (int)[(NSNumber*)m_array[_key] integerValue];
    }
    else
        return  0;
}

-(float)     getValueFloat:(NSString*) _key
{
    if(m_array[_key])
    {
        return [(NSNumber*)m_array[_key] floatValue];
    }
    else
        return  0;
}
-(BOOL)      getValueBool:(NSString*) _key
{
    if(m_array[_key])
    {
        return [(NSNumber*)m_array[_key] boolValue];
    }
    else
        return  NO;
}

-(BOOL) WriteToFile:(NSString*) _path
{
    if (m_array)
    {
        return [m_array writeToFile:_path atomically:YES];
    }
    return  NO;
    
}

-(BOOL) LoadFromFile:(NSString*) _path;
{
    NSMutableDictionary *array = [[NSMutableDictionary alloc] initWithContentsOfFile:_path];
    if (array)
    {
        m_array = array;
        return YES;
    }
    return  NO;
}

-(BOOL) WriteToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"NSSettingsManger.setting"];
    return  [self WriteToFile:path];
}

-(BOOL) LoadFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"NSSettingsManger.setting"];
    return [self LoadFromFile:path];
}

@end
