//
//  FPh_AppDelegate.m
//  Flight Physica
//
//  Created by David Lathrop on 1/5/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_AppDelegate.h"
#import "FlightAppConstants.h"

@interface FPh_AppDelegate()

//@property (readonly, nonatomic, getter = isCloudEnabled) BOOL cloudEnabled;

@property (strong, nonatomic) NSMutableArray* notifications;

- (FlightManagedDocument*)createDocument:(NSString*)fileName;

@end

@implementation FPh_AppDelegate

@synthesize activeDocumentURL = _activeDocumentURL;

@synthesize fileData = _fileData;

@synthesize notifications = _notifications;

@synthesize window = _window;

@synthesize motionRecorder = _motionRecorder;

@synthesize flightData = _flightData;

//=********************************************************************=//
// +initialize is invoked before the class receives any other messages, so it
// is a good place to set up application defaults
+ (void)initialize
{
    if ([self class] == [FPh_AppDelegate class]) {
        
        NSNumber    *default_Tips_On = [NSNumber numberWithBool:YES];
        
        NSNumber	*default_MotionDelta =  [NSNumber numberWithFloat:0.02];
        NSNumber	*default_CameraOn =  [NSNumber numberWithBool:NO];
        NSNumber	*default_CameraDelta =  [NSNumber numberWithFloat:1.0];
        NSNumber	*default_GPSOn =  [NSNumber numberWithBool:NO];
        NSNumber	*default_GPSDelta =  [NSNumber numberWithFloat:1.0];
        NSNumber	*default_TriggerType =  [NSNumber numberWithInt:0];
        NSNumber	*default_FlightTimeType = [NSNumber numberWithInt:0];
        NSNumber    *default_RecorderGraphViewType = [NSNumber numberWithInt:1];//attitude
        NSNumber	*default_FetchPageSize = [NSNumber numberWithInt:8000];
        
		NSNumber	*default_LegendShowAccelerationX =  [NSNumber numberWithBool:NO];
        NSNumber	*default_LegendShowAccelerationY =  [NSNumber numberWithBool:NO];
        NSNumber	*default_LegendShowAccelerationZ =  [NSNumber numberWithBool:NO];
        NSNumber	*default_LegendShowAttitudeRoll =   [NSNumber numberWithBool:YES];
        NSNumber	*default_LegendShowAttitudePitch =  [NSNumber numberWithBool:YES];
        NSNumber	*default_LegendShowAttitudeYaw =    [NSNumber numberWithBool:NO];
        NSNumber	*default_LegendShowRotationX =      [NSNumber numberWithBool:NO];
        NSNumber	*default_LegendShowRotationY =      [NSNumber numberWithBool:NO];
        NSNumber	*default_LegendShowRotationZ =      [NSNumber numberWithBool:NO];
        NSNumber	*default_LegendShowHeading =        [NSNumber numberWithBool:NO];
        NSNumber	*default_LegendShowGravityX =       [NSNumber numberWithBool:NO];
        NSNumber	*default_LegendShowGravityY =       [NSNumber numberWithBool:NO];
        NSNumber	*default_LegendShowGravityZ =       [NSNumber numberWithBool:NO];
        NSNumber	*default_RemotelyTriggered =        [NSNumber numberWithBool:YES];
        NSNumber	*default_CloudOn =                  [NSNumber numberWithBool:NO];
        NSNumber    *default_LiveGraphOn =              [NSNumber numberWithBool:YES];
        
        NSNumber    *default_GraphSizeWidth =           [NSNumber numberWithFloat:1800.0];
        NSNumber    *default_GraphSizeHeight =           [NSNumber numberWithFloat:1200.0];
        
        NSString    *default_FileNameRoot = NSLocalizedString(@"Flight_", @"");
        NSString    *default_PilotName = NSLocalizedString(@"a pilot", @"");
        NSString    *default_PlaneName = NSLocalizedString(@"a plane", @"");
        
        NSNumber	*default_FlightCount =  [NSNumber numberWithInt:0];
        
        NSDictionary * defaultFilesDictionary = [ NSDictionary dictionary ];
        
		NSDictionary *defaults_Dictonary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            default_LegendShowAccelerationX, DEFAULTS_LEGEND_SHOW_ACC_X
                                            , default_LegendShowAccelerationY, DEFAULTS_LEGEND_SHOW_ACC_Y
                                            , default_LegendShowAccelerationZ, DEFAULTS_LEGEND_SHOW_ACC_Z
                                            , default_LegendShowAttitudeRoll, DEFAULTS_LEGEND_SHOW_ATT_ROLL
                                            , default_LegendShowAttitudePitch, DEFAULTS_LEGEND_SHOW_ATT_PITCH
                                            , default_LegendShowAttitudeYaw, DEFAULTS_LEGEND_SHOW_ATT_YAW
                                            , default_LegendShowRotationX, DEFAULTS_LEGEND_SHOW_ROT_X
                                            , default_LegendShowRotationY, DEFAULTS_LEGEND_SHOW_ROT_Y
                                            , default_LegendShowRotationZ, DEFAULTS_LEGEND_SHOW_ROT_Z
                                            , default_LegendShowHeading, DEFAULTS_LEGEND_SHOW_HEADING
                                            , default_LegendShowGravityX, DEFAULTS_LEGEND_SHOW_GRAV_X
                                            , default_LegendShowGravityY, DEFAULTS_LEGEND_SHOW_GRAV_Y
                                            , default_LegendShowGravityZ, DEFAULTS_LEGEND_SHOW_GRAV_Z
                                            , default_FetchPageSize, DEFAULTS_FETCH_PAGE_SIZE
                                            
                                            , default_MotionDelta, DEFAULTS_MOTION_DELTA
                                            , default_CameraOn, DEFAULTS_CAMERA_ON
                                            , default_CameraDelta, DEFAULTS_CAMERA_DELTA
                                            , default_GPSOn, DEFAULTS_GPS_ON
                                            , default_GPSDelta, DEFAULTS_GPS_DELTA
                                            , default_CloudOn, DEFAULTS_CLOUD_ON
                                            , default_TriggerType, DEFAULTS_TRIGGER_TYPE
                                            , default_FlightTimeType, DEFAULTS_FLIGHTTIME_TYPE
                                            , default_LiveGraphOn, DEFAULTS_LIVE_GRAPH_ON
                                            ,default_RecorderGraphViewType, DEFAULTS_REC_GRAPH_TYPE_SETTING
                                            ,default_FlightCount, DEFAULTS_FLIGHT_COUNT
                                            ,defaultFilesDictionary, DEFAULTS_FILES_DICT
                                            ,default_RemotelyTriggered ,DEFAULTS_REMOTELY_TRIGGERED
                                            ,default_GraphSizeWidth , DEFAULTS_GRAPH_SIZE_WIDTH
                                            ,default_GraphSizeHeight ,DEFAULTS_GRAPH_SIZE_HEIGHT
                                            ,default_FileNameRoot, DEFAULTS_FILE_NAME_ROOT
                                            ,default_PilotName, DEFAULTS_PILOT_NAME
                                            ,default_PlaneName, DEFAULTS_PLANE_NAME
                                            ,default_Tips_On, DEFAULTS_TIPS_ON
                                            , nil];
        
		[[NSUserDefaults standardUserDefaults] registerDefaults:defaults_Dictonary];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
    }
} // + (void)initialize

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.motionRecorder = [[ MotionRecorder alloc ] init ];
    
    self.flightData = [[ FPh_FlightData alloc ] init ];
    
    [self setUpFileFolders];
    //BOOL motionAvailable = self.motionRecorder.motionManager.deviceMotionAvailable;
    //BOOL gyroAvailable = self.motionRecorder.motionManager.gyroAvailable;
    //BOOL locationAvailable = self.motionRecorder.locationManager.locationServicesEnabled;
    //BOOL headingAvailable = [self.motionRecorder.locationManager headingAvailable];
    
    // load the file information
    NSDictionary * dict = [[ NSUserDefaults standardUserDefaults ] dictionaryForKey:DEFAULTS_FILES_DICT ];
    self.fileData = [ NSMutableDictionary dictionaryWithDictionary:dict ];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if(self.motionRecorder.isRecording) {
        
        UIInterfaceOrientation iOrientation = [UIApplication sharedApplication].statusBarOrientation;
        
        switch (iOrientation) {
            case UIInterfaceOrientationPortrait:
                return UIInterfaceOrientationMaskPortrait;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                return UIInterfaceOrientationMaskPortraitUpsideDown;
                break;
            case UIInterfaceOrientationLandscapeRight:
                return UIInterfaceOrientationMaskLandscapeRight;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                return UIInterfaceOrientationMaskLandscapeLeft;
                break;
            case UIInterfaceOrientationUnknown:
                return UIInterfaceOrientationMaskAll;
                break;
        };
    }
    return UIInterfaceOrientationMaskAll;
}



// calculateNextFileIndex
//////////////////////////
- (NSUInteger)calculateNextFileIndex :(BOOL)updateIndex {
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger next = [application_Defaults integerForKey:DEFAULTS_FLIGHT_COUNT];
    
    next++;
    
    if (updateIndex) {
        [application_Defaults setInteger:next forKey:DEFAULTS_FLIGHT_COUNT];
    }
    
    return next;
    
    /*
     NSUInteger max = 0;
     for (NSURL* url in self.listOfFiles) {
     NSString* name = [url lastPathComponent];
     NSRange range = [ name rangeOfString:BaseFileName ];
     if (range.location != NSNotFound) {
     NSString* number =  [name substringFromIndex:[BaseFileName length]];
     NSUInteger value = [number integerValue];
     if (value > max) {
     max = value;
     }
     }
     }
     return max + 1;
     */
}

-(NSString *) nextDefaultFileName :(BOOL)updateIndex {
    
    NSInteger index = [self calculateNextFileIndex :updateIndex];
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    
    //NSInteger index = [application_Defaults integerForKey:DEFAULTS_FLIGHT_COUNT];
    
    // get from app defaults
    NSString* BaseFileName = [application_Defaults objectForKey:DEFAULTS_FILE_NAME_ROOT];
    
    NSString * flightNumberString = [[NSNumber numberWithInteger:index] stringValue];
    NSString * zeroString=@"0";
    
    for (unsigned long i=flightNumberString.length; i<4; i++) {
        flightNumberString = [NSString stringWithFormat:@"%@%@", zeroString, flightNumberString ];
    }
    
    NSString* fileName = [NSString stringWithFormat:@"%@%@", BaseFileName, flightNumberString];
    
    return fileName;
    
}

#pragma mark - FlightManagedDocument

- (FlightManagedDocument*)createDocument:(NSString*)fileName {
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES],
               NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
               NSInferMappingModelAutomaticallyOption, nil];
    
    self.activeDocumentURL = [[self localURL] URLByAppendingPathComponent:fileName];
    
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:self.activeDocumentURL.path ];
    if(exists) {
        
        NSLog(@"file already exists, what it do?");
        return nil;
        
    }
    
    // Now Create our document
    FlightManagedDocument* document =  [[FlightManagedDocument alloc] initWithFileURL:self.activeDocumentURL];
    
    if (document == nil) {
        NSLog(@"document == nil");
    }
    
    //document.undoManager = nil; // no undo
    
    document.persistentStoreOptions = options;
    
    return document;
}

-(void) createManagedDocument :(NSString*) filename {
    
    // create document
    self.motionRecorder.activeFlightDocument = [self createDocument:filename];
    
    if(!self.motionRecorder.activeFlightDocument) {
        NSLog(@"self.motionRecorder.activeFlightDocument == nil, returning");
        return;
    }
    
    // save document
    [ self.motionRecorder.activeFlightDocument  saveToURL:self.activeDocumentURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        
        if (success == NO) {
            // error handling here
            NSLog(@"removeItemAtURL here");
            // delete any partially saved data
            [[NSFileManager defaultManager] removeItemAtURL:self.activeDocumentURL error:nil];
            // and just exit
            return;
        }
        
        // save file metadata ...
        [ self.fileData setObject:@"active" forKey:filename ];
        [[ NSUserDefaults standardUserDefaults ] setObject:self.fileData forKey:DEFAULTS_FILES_DICT ];
        
    }];
    
}

- (NSURL*)containerURL {
    
    static NSURL* url = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        url = [[NSFileManager defaultManager]
               URLForUbiquityContainerIdentifier:nil];
    });
    
    return url;
}

- (NSURL*)localURL {
    
    static NSURL* url = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        url = [[NSFileManager defaultManager]
               URLForDirectory:NSDocumentDirectory
               inDomain:NSUserDomainMask
               appropriateForURL:nil
               create:NO
               error:nil];
    });
    
    return url;
}

- (void)saveContext: (FlightManagedDocument *) document
{
    
     NSError *error = nil;
    
    if (document.managedObjectContext != nil) //self.activeFlightDocument
    {
        //if ([document.managedObjectContext hasChanges] ) {
        //    NSLog(@"hasChanges");
        //} else {
        //    NSLog(@"!hasChanges");
        //}
        
        if (![document.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved save error %@, %@", error, [error userInfo]);
            [ self.fileData setObject:@"error" forKey:document.localizedName ];
        } else {
            //NSLog(@"saveContext success");
            //NSUserDefaults	*application_Defaults = [NSUserDefaults standardUserDefaults];
            //NSString * pilotString = [application_Defaults stringForKey:DEFAULTS_PILOT_NAME];
            //NSString * planeString = [application_Defaults stringForKey:DEFAULTS_PLANE_NAME];
            
            /*if(document.metaData) {
             NSLog(@"we have document.metaData");
             //document.metaData.pilot;
             //document.metaData.plane;
             
             NSNumber * flightLength = [NSNumber numberWithDouble:[document.metaData.stopTime doubleValue] - [document.metaData.startTime  doubleValue]];
             
             [ self.fileData setObject:[NSString stringWithFormat:@"%@ %@ %6.2f",pilotString, planeString, [flightLength floatValue]] forKey:document.localizedName ];
             }
             else {
             NSLog(@"no document.metaData desc-%@", document.description);
             NSNumber * flightLength = [NSNumber numberWithDouble:self.motionRecorder.motionEndTime - self.motionRecorder.motionStartTime ];
             [ self.fileData setObject:[NSString stringWithFormat:@"%@ %@ %6.2f",pilotString, planeString, [flightLength floatValue]] forKey:document.localizedName ];
             }*/
            
            // this is ok for current recording
            //
            // how to for copied document ...
            
            //NSString * string = [ self.fileData objectForKey:document.localizedName ];
            //NSLog(@"string - %@",string);
        }
        
        //NSLog(@"saveContext pre setObject");
        //[[ NSUserDefaults standardUserDefaults ] setObject:self.fileData forKey:DEFAULTS_FILES_DICT ];
        
        
        //[ self.flightDocsController.tableView reloadData ];
    }
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"reload_ tableview_notification" object:nil userInfo:nil];
}

-(void) addMetaData {
    
    [self.motionRecorder addMetaDataToDocument];
    
    //NSUserDefaults	*application_Defaults = [NSUserDefaults standardUserDefaults];
    //NSString * pilotString = [application_Defaults stringForKey:DEFAULTS_PILOT_NAME];
    //NSString * planeString = [application_Defaults stringForKey:DEFAULTS_PLANE_NAME];
    
    NSNumber *stopN = [NSNumber numberWithDouble:self.motionRecorder.motionEndTime];
    NSNumber *startN = [NSNumber numberWithDouble:self.motionRecorder.motionStartTime];
    
    //self.motionRecorder;
    
    if(self.motionRecorder.activeFlightDocument.localizedName){
        
        //[ self.fileData setObject:[NSString stringWithFormat:@"%@ %@ %6.2f",pilotString, planeString, [stopN floatValue]-[startN floatValue]] forKey:self.motionRecorder.activeFlightDocument.localizedName ];
        
        //NSDateFormatterMediumStyle
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [ self.fileData setObject:[NSString stringWithFormat:@"%@ %6.2f sec.", [dateFormatter stringFromDate:[NSDate date]], [stopN floatValue]-[startN floatValue]]forKey:self.motionRecorder.activeFlightDocument.localizedName ];
    }
    [[ NSUserDefaults standardUserDefaults ] setObject:self.fileData forKey:DEFAULTS_FILES_DICT ];
    [[ NSUserDefaults standardUserDefaults ] synchronize ];
    
}

#pragma mark - RAW files

-(void) setUpFileFolders {
    
    //set up file vault
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * flightsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"RAW Files"];
    
    //NSString * gamesDBPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"MDocs"];
    
    NSError * error;
    if ([fileManager fileExistsAtPath:flightsPath] == NO) {
        if (! [fileManager createDirectoryAtPath:flightsPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            //(@"createDirectoryAtPath error: stills");
        }
    }
}

-(void) iterateGames {
    
    //NSFileManager *fileManager = [[NSFileManager alloc] init];
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString * gamesPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Games"];
    // get files
    
    //NSError * error;
    
    //NSArray * fileArray = [ fileManager contentsOfDirectoryAtPath:gamesPath error:&error ];
    
    //fileDicts = [NSMutableArray array];
    
    //for (int fileIndex = 0; fileIndex < fileArray.count; fileIndex++ ) {
        
        //NSString * nextFileName = [ fileArray objectAtIndex:fileIndex ];
        
        //NSString * gamePath = [gamesPath stringByAppendingPathComponent:nextFileName];
        
        //NSURL * gameURL = [ NSURL fileURLWithPath:gamePath ];
        
        //NSDictionary * gameD = [ NSKeyedUnarchiver unarchiveObjectWithFile: [ gameURL path ] ];
        
        //NSLog(@"%@", gameD);
        
        //[fileDicts addObject:gameD];
        
        //    NSError * error;
        //   [fileManager removeItemAtURL:gameURL error:&error];
        
        // [gameD setObject:blueCommandName forKey:@"bluename"];
        // [gameD setObject:redCommandName forKey:@"redname"];
        
    //}
}

#pragma mark - iCloud Container URL Methods

//-(NSURL*) expCloudURL {
//    return [self containerURL];
//}
-(NSURL*) expLocalURL{
    return [self localURL];
}

@end
