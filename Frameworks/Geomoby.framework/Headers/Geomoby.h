//
//  Geomoby.h
//  Geomoby
//
//  Created by admin on 30.01.17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "GeomobyActionBasic.h"
#import "GeomobyActionData.h"


//! Project version number for Geomoby.
FOUNDATION_EXPORT double GeomobyVersionNumber;

//! Project version string for Geomoby.
FOUNDATION_EXPORT const unsigned char GeomobyVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Geomoby/PublicHeader.h>


// Geomoby delegate protocol
@protocol GeomobyDelegate <NSObject>
@optional
-(void)actionBasicCallback:(GeomobyActionBasic *)message;
-(void)actionDataCallback:(GeomobyActionData *)data;
-(void)eventEnterCallback:(NSString *)name;
-(void)eventExitCallback:(NSString *)name;
-(void)eventDwellCallback:(NSString *)name;
-(void)eventCrossCallback:(NSString *)name;

-(void)updatedInitLocation:(CLLocation *)location;
-(void)updatedInterval:(int)interval;
-(void)updatedDistanceToNearestFence:(double)distance inside:(int)flag;
-(void)reportSent;
-(void)updatedBeaconScan:(bool)flag;
-(void)updatedSpeed:(float)speed;
-(void)updatedAvgSpeed:(float)avgspeed;
-(void)updatedGPSAccuracy:(float)acuracy;
@end




// Geomoby interface
@interface Geomoby : NSObject <CLLocationManagerDelegate>

extern NSString* const URL;
extern int const GEO_RADIUS;
extern int const OUT_ZONE_RADIUS;
extern int const RETRY_INTERVAL;
extern int const MIN_INTERVAL;
extern int const MAX_INTERVAL;
extern int const BEACON_SCAN_INTERVAL;
extern int const BEACON_SCAN_PERIOD;
extern int const BEACON_SCAN_RADIUS;
extern float const INITIAL_SPEED;
extern float const MIN_SPEED;
extern float const SPEED_EPSILON;
extern double const EARTH_RADIUS;
extern int const MIN_ACCURACY;
extern NSString* const VERSION;

@property NSString *mAppKey;
@property NSString *mUUID;
@property NSDictionary *mTags;
@property int mSilenceStart;
@property int mSilenceStop;
@property (strong, nonatomic) CLLocationManager *mLocationManager;
@property (nonatomic, weak) id <GeomobyDelegate> mDelegate;

@property long mInstallId;
@property bool mUpdatingLocation;
@property bool mLocationUpdated;
@property bool mBeaconEnabled;
@property bool mBeaconScanning;
@property bool mBeaconFirstScan;
@property double mMinDist;
@property float mAverageSpeed;
@property float mSpeed;
@property bool mLineCrossed;
@property int mInterval;
@property CLBeaconRegion *mBeaconRegion;
@property CLLocation *mInitLocation;
@property CLLocation *mCurrentLocation;
@property CLLocation *mPreviousLocation;
@property NSMutableArray *mFences;
@property NSMutableArray *mBeacons;
@property NSMutableArray *mCurrentBeacons;
@property NSTimer *mDwellTimer;
@property dispatch_source_t mDispatchTimer;

+(Geomoby *)sharedInstance;

-(id)initWithAppKey:(NSString*)appKey;
-(void)setUUID:(NSString*)uuid;
-(void)setDevMode:(bool)devmode;
-(void)setTags:(NSDictionary*)tags;
-(void)setSilenceWindowStart:(int)start andStop: (int)stop;
-(void)setDelegate:(id<GeomobyDelegate>)delegate;

-(void)start;
-(void)stop;
-(void)getInstallID;
-(void)getFences;
-(void)sendObservation;
-(void)sendException:(NSString *)reason WithCallStack:(NSArray *)callstack WithVariables:(NSArray *)variables;
-(void)handleFences;
-(void)calculateIntervalAndAccuracy;
-(bool)crossingLine:(NSString *)line1 With:(NSString *)line2;
-(double)calculateDistanceFrom:(NSString *)location1 To:(NSString *)location2;
-(void)confirmEventFor:(long)eid withType:(NSString *)etype;
-(void)confirmEventFor:(long)eid withType:(NSString *)etype withProximity:(NSString *)proximity;
-(void)confirmEventType:(id)fence withType:(NSString *)etype;
-(int)getTimeBeforeDwell;
-(int)getTimeBeforeCooldownPass;
-(void)startDwellTimer;
-(void)stopDwellTimer;
-(void)updateFenceEvents:(NSTimer *)timer;
-(bool)checkSilenceTime;
-(bool)proximityLessOrEquals:(NSString*)proximity1 to:(NSString*)proximity2;
@end
