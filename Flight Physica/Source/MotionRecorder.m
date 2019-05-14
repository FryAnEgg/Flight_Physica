//
//  MotionRecorder.m
//  Flight Physica
//
//  Created by David Lathrop on 1/6/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FlightAppConstants.h"

#import "MotionRecorder.h"

#import "DeviceMotionObject.h"
#import "Location.h"
#import "Altitude.h"

@implementation MotionRecorder

@synthesize activeFlightDocument = _activeFlightDocument;

@synthesize headingDataArray;
@synthesize locationDataArray;
@synthesize bCameraOn, cameraInterval, startTrigger, gpsOn, gpsInterval, stopTrigger;

@synthesize motionManager = _motionManager;
@synthesize isRecording = _isRecording;
@synthesize currentHeading = _currentHeading;
@synthesize locationManager = _locationManager;
@synthesize motionInterval = _motionInterval;

@synthesize triggerOptionStrings, flightTimeOptionStrings;

@synthesize motionEndTime;
@synthesize motionStartTime;
@synthesize pointCount;


-(id)init
{
	self = [super init];
	if(self != nil)
	{
		self.isRecording = NO;
        
        self.triggerOptionStrings = [ NSArray arrayWithObjects:  NSLocalizedString(@"Touch Button",@""),
                                     NSLocalizedString(@"10 sec delay",@""),
                                     NSLocalizedString( @"20 sec delay",@""),
                                     NSLocalizedString( @"30 sec delay",@""),
                                     NSLocalizedString( @"60 sec delay",@""),
                                     NSLocalizedString( @"Remote Trigger",@""), nil ];
        
        self.flightTimeOptionStrings = [ NSArray arrayWithObjects:  NSLocalizedString(@"Touch Button",@""),
                                        NSLocalizedString(@"3 minutes",@""),
                                        NSLocalizedString( @"4 minutes",@""),
                                        NSLocalizedString( @"5 minutes",@""),
                                        NSLocalizedString( @"6 minutes",@""),
                                        NSLocalizedString( @"7 minutes",@""),
                                        NSLocalizedString( @"8 minutes",@""),
                                        NSLocalizedString( @"9 minutes",@""),
                                        NSLocalizedString( @"10 minutes",@""),
                                        NSLocalizedString( @"15 minutes",@""),
                                        NSLocalizedString( @"20 minutes",@""),nil ];
        
        
        triggerDelayValueNumbers = [ NSArray arrayWithObjects:  [NSNumber numberWithFloat:0.0],
                                    [NSNumber numberWithFloat:10.0],
                                    [NSNumber numberWithFloat:20.0],
                                    [NSNumber numberWithFloat:30.0],
                                    [NSNumber numberWithFloat:60.0],
                                    [NSNumber numberWithFloat:0.0], nil ];
        
        flightTimeValueNumbers = [ NSArray arrayWithObjects:  [NSNumber numberWithFloat:-1.0],
                                  [NSNumber numberWithFloat:180.0],
                                  [NSNumber numberWithFloat:240.0],
                                  [NSNumber numberWithFloat:300.0],
                                  [NSNumber numberWithFloat:360.0],
                                  [NSNumber numberWithFloat:420.0],
                                  [NSNumber numberWithFloat:480.0],
                                  [NSNumber numberWithFloat:540.0],
                                  [NSNumber numberWithFloat:600.0],
                                  [NSNumber numberWithFloat:900.0],
                                  [NSNumber numberWithFloat:1200.0],nil ];
        
        
        [ self setToDefaultValues ];
        
        self.pointCount = 0;
        
        self.headingDataArray = [ NSMutableArray arrayWithCapacity:20 ];
        self.locationDataArray = [ NSMutableArray arrayWithCapacity:20 ];
        
        // set up motion manager
        self.motionManager = [[CMMotionManager alloc] init];
        
        // check availability
        if (self.motionManager.deviceMotionAvailable == NO){
            NSLog(@"motionManager.deviceMotionAvailable == NO");
            
        }
        if (self.motionManager.gyroAvailable == NO ){
            NSLog(@"motionManager.gyroAvailable == NO");
        }
        
        _motion_opQ = [NSOperationQueue currentQueue];
        
        [ self startDeviceMotionUpdates ];
        
        [ self startLocationEvents ];
        
        [self startAltimeter ];
        
        
	}
	return self;
}

-(id)initAsEmpty
{
	self = [super init];
	if(self != nil)
	{
		self.motionStartTime = 0.0;
        
        [ self setToDefaultValues ];
        
	}
	return self;
}

#pragma mark - startDeviceMotionUpdates

-(void) startDeviceMotionUpdates {
    
    self.motionManager.deviceMotionUpdateInterval = self.motionInterval;
    
    if (self.motionManager.deviceMotionAvailable) {
        
        //referenceAttitude = self.deviceMotion.attitude;
        
        CMDeviceMotionHandler motionHandler = ^(CMDeviceMotion  *motionData, NSError *error) {
            
            if (error) { NSLog(@"CMDeviceMotionHandler ERROR"); return;}
            if (!motionData){ NSLog(@"CMDeviceMotionHandler !motionData"); return;}
            
            [ self motionDataReceived : motionData ];
            
        };
        
        [ self.motionManager startDeviceMotionUpdatesToQueue:_motion_opQ withHandler:motionHandler ];
    
    }
}


-(void) stopMotionUpdates {
    
    if ([self.motionManager isDeviceMotionActive]) {
        [self.motionManager stopDeviceMotionUpdates];
    }
    
    [altimeter stopRelativeAltitudeUpdates];
}

- (void)startLocationEvents {
    
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [self.locationManager requestWhenInUseAuthorization];
        }else{
            [self.locationManager startUpdatingLocation];
        }
        // [self.locationManager allowDeferredLocationUpdatesUntilTraveled:(CLLocationDistance)100000     timeout:(NSTimeInterval)100000];
        
        if( [CLLocationManager deferredLocationUpdatesAvailable]) {
            NSLog(@"self.locationManager.deferredLocationUpdatesAvailable");
        } else {
            NSLog(@"NOT self.locationManager.deferredLocationUpdatesAvailable");
        }
    }
    
    // Start location services to get the true heading.
    //self.locationManager.distanceFilter = 5.0; // 10 meters
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [self.locationManager startUpdatingLocation];
    
    //- (void)startMonitoringSignificantLocationChanges
    // Start heading updates.
    //if ([CLLocationManager headingAvailable]) {
    //self.locationManager.headingFilter = 5;
    //   [self.locationManager startUpdatingHeading];
    //}
    
}

-(void) startAltimeter {
    
    if([CMAltimeter isRelativeAltitudeAvailable]){
        
        altimeter = [[CMAltimeter alloc]init];
        
        [altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
            
            NSString *data = [NSString stringWithFormat:@"Altitude: %f %f", altitudeData.relativeAltitude.floatValue, altitudeData.pressure.floatValue];
            
            NSTimeInterval currentTime = [ [NSDate date] timeIntervalSinceReferenceDate ];
            
            if (self.isRecording) {
                
                NSLog(@"%@ t = %4.2f", data, currentTime);
                //pressure in kilopascals
                // rel alt in meters
                
                [self addAltimeterPoint:altitudeData];
               
            }
        }];
        
    } else {
        NSLog(@"Altimeter not available");
    }
    
}

#pragma mark - CMDeviceMotion

-(void) motionDataReceived : (CMDeviceMotion  *) motionData {
    
    //NSLog(@"ts = %4.2f",motionData.timestamp);
    //The time stamp is the amount of time in seconds since the phone booted.
    
    if (self.isRecording) {
        
        //no magnetometer yet
        //CMCalibratedMagneticField magField = motionData.magneticField;
        //NSLog(@"acc = %d = %d", magField.accuracy, CMMagneticFieldCalibrationAccuracyUncalibrated);
        //NSLog(@"%4.2f %4.2f, %4.2f", magField.field.x, magField.field.y, magField.field.z);
        
        
        [ self addMotionPoint:motionData ];
        
        // use notification ...
        [[NSNotificationCenter defaultCenter] postNotificationName:@"motionDataRecieved_notification" object:motionData userInfo:nil];
        
        
    } else {
        //NSLog(@"!isRecording");
    }
}

-(void) setToDefaultValues {
    
    NSUserDefaults	*application_Defaults;
    application_Defaults = [NSUserDefaults standardUserDefaults];
    
    self.motionInterval = [application_Defaults floatForKey:DEFAULTS_MOTION_DELTA];
    
    self.bCameraOn = [application_Defaults boolForKey:DEFAULTS_CAMERA_ON];
    self.cameraInterval = [application_Defaults floatForKey:DEFAULTS_CAMERA_DELTA];
    
    self.gpsOn = [application_Defaults boolForKey:DEFAULTS_GPS_ON];
    self.gpsInterval = [application_Defaults floatForKey:DEFAULTS_GPS_DELTA];
    
    
    self.startTrigger = [application_Defaults objectForKey:DEFAULTS_TRIGGER_TYPE];
    self.stopTrigger = [application_Defaults objectForKey:DEFAULTS_FLIGHTTIME_TYPE];
    
}


-(void) addMotionPoint:(CMDeviceMotion  *) dataPoint {
    
    NSManagedObjectContext *addingContext = self.activeFlightDocument.managedObjectContext;
    
    [addingContext performBlockAndWait:^() {
        
        DeviceMotionObject * zzd = (DeviceMotionObject *)[NSEntityDescription insertNewObjectForEntityForName:@"Motion" inManagedObjectContext:addingContext];
        
        zzd.timestamp = [NSNumber numberWithDouble: dataPoint.timestamp];
        zzd.attRoll = [NSNumber numberWithDouble: dataPoint.attitude.roll];
        zzd.attPitch = [NSNumber numberWithDouble: dataPoint.attitude.pitch];
        zzd.attYaw = [NSNumber numberWithDouble: dataPoint.attitude.yaw];
        zzd.accx= [NSNumber numberWithDouble: dataPoint.userAcceleration.x];
        zzd.accy= [NSNumber numberWithDouble: dataPoint.userAcceleration.y];
        zzd.accz= [NSNumber numberWithDouble: dataPoint.userAcceleration.z];
        zzd.rotx= [NSNumber numberWithDouble: dataPoint.rotationRate.x];
        zzd.roty= [NSNumber numberWithDouble: dataPoint.rotationRate.y];
        zzd.rotz= [NSNumber numberWithDouble: dataPoint.rotationRate.z];
        zzd.gravx= [NSNumber numberWithDouble: dataPoint.gravity.x];
        zzd.gravy= [NSNumber numberWithDouble: dataPoint.gravity.y];
        zzd.gravz= [NSNumber numberWithDouble: dataPoint.gravity.z];
        
    }];
    
    self.motionEndTime = dataPoint.timestamp;
    if (self.motionStartTime==0.0) {
        self.motionStartTime = dataPoint.timestamp;
    }
    
    self.pointCount++;
    
}

-(void) addLocationPoint:(CLLocation*) dataPoint {
    
    [ self.locationDataArray addObject:dataPoint ];
    
    NSManagedObjectContext *addingContext = self.activeFlightDocument.managedObjectContext;
    
    [addingContext performBlockAndWait:^() {
        
        Location * loc = (Location *)[NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:addingContext];
        
        loc.latitude = [NSNumber numberWithDouble: dataPoint.coordinate.latitude];
        loc.longitude = [NSNumber numberWithDouble: dataPoint.coordinate.longitude];
        loc.speed = [NSNumber numberWithDouble: dataPoint.speed];
        loc.altitude = [NSNumber numberWithDouble: dataPoint.altitude];
        loc.horizaccur = [NSNumber numberWithDouble: dataPoint.horizontalAccuracy];
        loc.vertaccur = [NSNumber numberWithDouble: dataPoint.verticalAccuracy];
        loc.course = [NSNumber numberWithDouble: dataPoint.course];
        loc.timestamp = dataPoint.timestamp;
        
    }];
    
}


-(void) addAltimeterPoint:(CMAltitudeData  *) dataPoint {
    
    NSManagedObjectContext *addingContext = self.activeFlightDocument.managedObjectContext;
    
    [addingContext performBlockAndWait:^() {
        
        Altitude * alt = (Altitude *)[NSEntityDescription insertNewObjectForEntityForName:@"Altitude" inManagedObjectContext:addingContext];
        
        alt.relativeAltitude = dataPoint.relativeAltitude;
        alt.pressure = dataPoint.pressure;
        alt.timestamp = [NSNumber numberWithDouble:dataPoint.timestamp];
        
    }];
    
}



#pragma mark CLLocation delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    if (newHeading.headingAccuracy < 0)
        return;
    
    [ self addHeadingPoint:newHeading ];
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading);
    
    //NSNumber * headingNumber = [ NSNumber numberWithDouble:theHeading ];
    self.currentHeading = theHeading;
    
    //self.headingView.heading = theHeading;
    //[ self.headingView setNeedsDisplay ];
    NSLog(@"didUpdateHeading");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"didUpdateLocations");
    if (self.isRecording && self.gpsOn) {
        CLLocation * location = [locations lastObject];
        [self addLocationPoint:location ];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"CLLocationManager : didFailWithError");
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [self.locationManager startUpdatingLocation];
        }
            break;
    }
}

#pragma mark
-(void) getTimedGPSData {
    NSLog(@"getTimedGPSData");
    // start and stop to force an update
    //NSLog(@"%@",[self.locationManager.location description]);
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
    
}


/////////////////////////////////////////////////
-(void) addHeadingPoint:(CLHeading *) dataPoint {
    
    [ self.headingDataArray addObject:dataPoint ];
    //NSLog(@"heading #%d - date %@", [ self.headingDataArray count ], dataPoint.timestamp.description );
}

-(CLHeading *) lastHeading {
   // NSLog(@"lastHeading [ self.headingDataArray count] %d",[ self.headingDataArray count]);
    if ([self.headingDataArray count] <= 0) {
        NSLog(@"lastHeading==NULL");
        return nil;
    } else {
        return [self.headingDataArray objectAtIndex:[self.headingDataArray count]-1];
    }
    
}

///////////////////////////////
-(void) displayRecordingStats {
    NSLog(@"...displayRecordingStats...");
    
    /* if ( [ self.motionDataArray count ] == 0 ) return;
     
     [ self saveToFile ];
     
     // merge motionData and locationData by time stamps
     ZZDeviceMotion * initialMotionPoint = [ self.motionDataArray objectAtIndex:0 ];
     NSTimeInterval initialMotionStamp = [initialMotionPoint.timestamp  doubleValue];
     NSNumber * initialMotionStampNumber = [NSNumber numberWithDouble:initialMotionStamp ];
     NSLog(@"initialMotionStampNumber %f", [initialMotionStampNumber floatValue] );
     NSDate * calcDate = [ NSDate dateWithTimeIntervalSinceReferenceDate:initialMotionStamp ];
     NSLog(@"initialMotionDate %@", calcDate.description);
     
     if ( [ self.headingDataArray count ] > 0 ) {
     CLHeading * initialHeadingPoint =  [ self.headingDataArray objectAtIndex:0 ];
     NSLog(@"heading at: %@", initialHeadingPoint.timestamp.description);//NSDate
     }
     
     double rotationSum = 0.0;
     ZZDeviceMotion * origMotionPoint = [ self.motionDataArray objectAtIndex: 0 ];
     NSTimeInterval lastStamp = [origMotionPoint.timestamp doubleValue];
     
     for ( int i = 1; i < [ self.motionDataArray count ]; i++ ) {
     
     ZZDeviceMotion * motionPoint = [ self.motionDataArray objectAtIndex: i ];
     
     NSTimeInterval stamp = [motionPoint.timestamp doubleValue];
     NSNumber * stampNumber = [NSNumber numberWithDouble:stamp ];
     
     double deltat = stamp - lastStamp;
     NSNumber * deltaTNumber = [NSNumber numberWithDouble:deltat ];
     
     rotationSum += [motionPoint.rotz doubleValue] * deltat;
     NSNumber * rotSumNumber = [NSNumber numberWithDouble:rotationSum ];
     
     NSNumber *yawNum = [ NSNumber numberWithDouble:( [motionPoint.attYaw doubleValue] - [initialMotionPoint.attYaw doubleValue] ) ];
     
     lastStamp = stamp;
     
     NSTimeInterval tTime;
     if (i==0) {
     tTime = [stampNumber floatValue];
     }
     
     NSNumber *rdiff = [ NSNumber numberWithDouble:( [motionPoint.attRoll doubleValue] )];
     NSNumber *pdiff = [ NSNumber numberWithDouble:( [motionPoint.attPitch doubleValue] ) ];
     NSNumber *ydiff = [ NSNumber numberWithDouble:( [motionPoint.attYaw doubleValue] ) ];
     
     NSNumber *ax = [ NSNumber numberWithDouble:( [motionPoint.accx doubleValue] ) ];
     NSNumber *ay = [ NSNumber numberWithDouble:( [motionPoint.accy doubleValue] ) ];
     NSNumber *az = [ NSNumber numberWithDouble:( [motionPoint.accz doubleValue] ) ];
     
     NSNumber *rotxNum = [ NSNumber numberWithDouble:[motionPoint.rotx doubleValue] ];
     NSNumber *rotyNum = [ NSNumber numberWithDouble:[motionPoint.roty doubleValue] ];
     NSNumber *rotzNum = [ NSNumber numberWithDouble:[motionPoint.rotz doubleValue] ];
     
     }*/
}

#pragma mark - time delay values

-(float) startDelayValue {
    int startIndex = [ self.startTrigger intValue ];
    NSNumber * startNumber = [ triggerDelayValueNumbers objectAtIndex:startIndex ];
    return ( [startNumber floatValue ] );
}

-(float) flightLengthValue {
    int stopIndex = [ self.stopTrigger intValue ];
    NSNumber * stopNumber = [ flightTimeValueNumbers objectAtIndex:stopIndex ];
    return ( [stopNumber floatValue ] );
}

-(void) addMetaDataToDocument {
    
    if (self.activeFlightDocument.managedObjectContext != nil) {
        
        // add and set metadata object
        NSManagedObjectContext *addingContext = self.activeFlightDocument.managedObjectContext;
        
        [addingContext performBlockAndWait:^() {
            
            NSUserDefaults	*application_Defaults = [NSUserDefaults standardUserDefaults];
            NSString * pilotString = [application_Defaults stringForKey:DEFAULTS_PILOT_NAME];
            NSString * planeString = [application_Defaults stringForKey:DEFAULTS_PLANE_NAME];
            
            MetaData * fmd = (MetaData *)[NSEntityDescription insertNewObjectForEntityForName:@"MetaData" inManagedObjectContext:addingContext];
            
            fmd.stopTime = [NSNumber numberWithDouble:self.motionEndTime];
            fmd.startTime = [NSNumber numberWithDouble:self.motionStartTime];
            fmd.pilot = pilotString;
            fmd.plane = planeString;
            fmd.date = [ NSDate date ];
            
            fmd.motionInterval = [NSNumber numberWithDouble:self.motionInterval];
            fmd.gpsInterval = [NSNumber numberWithDouble:self.gpsInterval];
            fmd.pictureInterval = [NSNumber numberWithDouble:self.cameraInterval];
            
            fmd.location = @"locationDescription";
            
        }];
    }
}

#pragma mark NSCoder

- (void)encodeWithCoder:(NSCoder *)coder {
    
    //[ coder encodeObject:self.motionDataArray forKey:@"MotionData"];
    [ coder encodeObject:self.headingDataArray forKey:@"HeadingData"];
    [ coder encodeObject:self.locationDataArray forKey:@"LocationData"];
    
    [ coder encodeDouble:self.motionInterval forKey:@"MotionInterval" ];
    
    [ coder encodeBool:bCameraOn forKey:@"CameraOn" ];
    [ coder encodeDouble:cameraInterval forKey:@"CameraInterval" ];
    
    [ coder encodeInt:[startTrigger intValue] forKey:@"StartTrigger" ];
    [ coder encodeInt:[stopTrigger intValue] forKey:@"StopTrigger" ];
    
    [ coder encodeBool:gpsOn forKey:@"gpsOn" ];
    [ coder encodeDouble:gpsInterval forKey:@"gpsInterval" ];
    
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	if (self != nil) {
        
        //self.motionDataArray = [coder decodeObjectForKey:@"MotionData"];
        self.headingDataArray = [coder decodeObjectForKey:@"HeadingData"];
        self.locationDataArray = [coder decodeObjectForKey:@"LocationData"];
        
        self.motionInterval = [ coder decodeDoubleForKey:@"MotionInterval" ];
        self.bCameraOn = [ coder decodeBoolForKey:@"CameraOn" ];
        self.cameraInterval = [ coder decodeDoubleForKey:@"CameraInterval" ];
        self.startTrigger = [NSNumber numberWithInt:[ coder decodeIntForKey:@"StartTrigger" ]];
        self.stopTrigger = [NSNumber numberWithInt:[ coder decodeIntForKey:@"StopTrigger" ]];
        self.gpsOn = [ coder decodeBoolForKey:@"gpsOn" ];
        self.gpsInterval = [ coder decodeDoubleForKey:@"gpsInterval" ];
		
	}
	return self;
}

-(void) saveToFile { // obs?
    NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSString * flightsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Flights"];
    NSString * flight1Path = [ [paths objectAtIndex:0] stringByAppendingPathComponent:@"Flight1"];
    
    BOOL fileExists = [ fileManager fileExistsAtPath:flight1Path ];
    if (!fileExists) {
        //NSURL * flightURL = [ NSURL fileURLWithPath:flight1Path ];
        BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:flight1Path ];
        //NSLog(@"saving flight file");
        //if (success) {
            //NSLog(@"saving flight file YES");
        //} else {
            //NSLog(@"saving flight file NO");
        //}
    } else {
        NSLog(@"flight file already exists");
        
    }
}

@end
