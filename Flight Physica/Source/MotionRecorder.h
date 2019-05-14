//
//  MotionRecorder.h
//  Flight Physica
//
//  Created by David Lathrop on 1/6/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CMMotionManager.h>

#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CLHeading.h>
#import <CoreMotion/CMAltimeter.h>

#import "FlightManagedDocument.h"

@interface MotionRecorder : NSObject <NSCoding, CLLocationManagerDelegate> {
    
    NSInteger       pointCount;
    NSTimeInterval  _motionInterval;
    
    BOOL bCameraOn;
    NSTimeInterval cameraInterval;
    
    BOOL gpsOn;
    NSTimeInterval gpsInterval;
    
    NSNumber * startTrigger;
    NSNumber * stopTrigger;
    
    NSMutableArray *headingDataArray;
    NSMutableArray *locationDataArray;
    
    NSOperationQueue *_motion_opQ;
    
    CLLocationDirection _currentHeading;
    CMAltimeter *altimeter;
    
    NSArray * triggerDelayValueNumbers;
    NSArray * flightTimeValueNumbers;
    
}

-(id)initAsEmpty;

-(float) startDelayValue;
-(float) flightLengthValue;

-(void) startDeviceMotionUpdates;
-(void) stopMotionUpdates;
-(void) motionDataReceived : (CMDeviceMotion  *) motionData;

-(void)startLocationEvents;

-(CLHeading *) lastHeading;

@property (nonatomic, strong) FlightManagedDocument* activeFlightDocument;

@property(nonatomic,assign) NSTimeInterval motionStartTime;
@property(nonatomic,assign) NSTimeInterval motionEndTime;

@property(nonatomic,strong) NSArray * triggerOptionStrings;
@property(nonatomic,strong) NSArray * flightTimeOptionStrings;

@property(nonatomic,assign) BOOL isRecording;

-(void) setToDefaultValues;

-(void)displayRecordingStats;

-(void) saveToFile;

-(void) addMetaDataToDocument;


@property (nonatomic, assign) NSInteger      pointCount;

@property(nonatomic, retain) CMMotionManager * motionManager;

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, assign) CLLocationDirection currentHeading;

@property (nonatomic,retain) NSMutableArray *headingDataArray;
@property (nonatomic,retain) NSMutableArray *locationDataArray;

@property (nonatomic,assign) NSTimeInterval motionInterval;
@property (nonatomic,assign) BOOL bCameraOn;
@property (nonatomic,assign) NSTimeInterval cameraInterval;

@property (nonatomic,assign) BOOL gpsOn;
@property (nonatomic,assign) NSTimeInterval gpsInterval;

@property (nonatomic,retain) NSNumber * startTrigger;
@property (nonatomic,retain) NSNumber * stopTrigger;
@end
