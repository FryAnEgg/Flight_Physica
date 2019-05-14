//
//  FPh_ViewController.m
//  Flight Physica
//
//  Created by David Lathrop on 1/5/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_ViewController.h"
#import "FlightAppConstants.h"
#import "FPh_AppDelegate.h"

#import "FPh_RecorderView.h"

@interface FPh_ViewController ()

@end

@implementation FPh_ViewController

@synthesize recorderView, liveGraphSegControl;
@synthesize navBar = _navBar;

@synthesize motionRecorder = _motionRecorder;
@synthesize gpsTimer = _gpsTimer;

@synthesize  lastMotion,referenceAttitude;

@synthesize  fileLabel,motionDeltaLabel, gpsDeltaLabel, cameraDeltaLabel, triggerLabel, fileNameLabel, pilotLabel, planeLabel;

@synthesize liveGraph,recordButton, settingsButton, filesButton;

@synthesize image_Picker_Controller = _image_Picker_Controller;

@synthesize soundFileURLRef;
@synthesize soundFileObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter * noteCen = [ NSNotificationCenter defaultCenter ];
    
    [ noteCen addObserver:self  selector:@selector(settingsAppliedNote:)name:@"rec_set_appl_note"  object:nil];
    [ noteCen addObserver:self  selector:@selector(addMotionDataPointToLiveGraphNote:)name:@"motionDataRecieved_notification"  object:nil];
    [ noteCen addObserver:self  selector:@selector(restartMotionManager:)name:@"restartMotionManager_notification"  object:nil];
    [ noteCen addObserver:self  selector:@selector(remoteTriggerNoted:)name:@"remoteTriggerNoted_notification"  object:nil];
    [ noteCen addObserver:self  selector:@selector(liveGraphingSwitchedNoted:)name:@"LiveGraphingSwitched_note"  object:nil];
    [ noteCen addObserver:self  selector:@selector(displayNextTipNote:)name:@"DisplayNextTip_note"  object:nil];
    
    FPh_AppDelegate * appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    self.motionRecorder = appDelegate.motionRecorder;
    
    NSNumber * number = [ NSNumber numberWithDouble: self.motionRecorder.motionInterval ];
    NSString * displayString = [NSString stringWithFormat:@"%4.2f Hz.", 1.0/[number floatValue] ];
    motionDeltaLabel.text = displayString;
    
	useAdaptive = NO;
    
    [liveGraph clearGraph ];
	[liveGraph setIsAccessibilityElement:YES];
	[liveGraph setAccessibilityLabel:NSLocalizedString(@"liveGraph", @"")];
    
    NSUserDefaults	*application_Defaults;
    application_Defaults = [NSUserDefaults standardUserDefaults];
    
    tabIndex = [application_Defaults floatForKey:DEFAULTS_REC_GRAPH_TYPE_SETTING];
    
    self.motionRecorder.startTrigger = [application_Defaults objectForKey:DEFAULTS_TRIGGER_TYPE];
    self.motionRecorder.stopTrigger = [application_Defaults objectForKey:DEFAULTS_FLIGHTTIME_TYPE];
    
    [liveGraphSegControl setSelectedSegmentIndex:tabIndex];
    
    // a little redundant...
    bLiveGraph = [application_Defaults boolForKey:DEFAULTS_LIVE_GRAPH_ON];
    switch (tabIndex) {
        case 0: //acceleration
            self.liveGraph.graphTextView.stringA = @"X";
            self.liveGraph.graphTextView.stringB = @"Y";
            self.liveGraph.graphTextView.stringC = @"Z";
            break;
        case 1: // attitude
            self.liveGraph.graphTextView.stringA = @"R";
            self.liveGraph.graphTextView.stringB = @"P";
            self.liveGraph.graphTextView.stringC = @"Y";
            break;
        case 2: //rotation
            self.liveGraph.graphTextView.stringA = @"X";
            self.liveGraph.graphTextView.stringB = @"Y";
            self.liveGraph.graphTextView.stringC = @"Z";
            break;
        case 3: // heading
            break;
        case 4: //gravity
            break;
        default:
            NSLog(@"unexpected tab selection %d", tabIndex);
            break;
    }
    
    if (!bLiveGraph) { // a little redundant
        [self.liveGraph clearGraph];
        [self.liveGraph.graphTextView removeFromSuperview];
    }
    
    self.fileNameLabel.textColor = [ UIColor whiteColor];
    self.pilotLabel.textColor = [ UIColor whiteColor];
    self.planeLabel.textColor = [ UIColor whiteColor];
    self.motionDeltaLabel.textColor = [ UIColor whiteColor];
    
    self.fileLabel.textColor = [ UIColor greenColor];
    
    [ self setSettingsText ];
    
    
    _total_Tips = 15;
    
    _tip_Title_Array = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Graphing Tip", @"")
                            , NSLocalizedString(@"Graphing Tip", @"")
                            , NSLocalizedString(@"Graphing Tip", @"")
                            , NSLocalizedString(@"Graphing Tip", @"")
                        
                            , NSLocalizedString(@"Graphing Tip", @"")
                            , NSLocalizedString(@"Graphing Tip", @"")
                            , NSLocalizedString(@"Graphing Tip", @"")
                            , NSLocalizedString(@"Graphing Tip", @"")
                            , NSLocalizedString(@"Graphing Tip", @"")
                        
                            , NSLocalizedString(@"Recording Tip", @"")
                        
                            , NSLocalizedString(@"Settings Tip", @"")
                            , NSLocalizedString(@"Settings Tip", @"")
                            , NSLocalizedString(@"Settings Tip", @"")
                        
                            , NSLocalizedString(@"Coming Soon", @"")
                            , NSLocalizedString(@"Coming Soon", @"")
                        
                            , NSLocalizedString(@"It's a Fact", @"")
                            , NSLocalizedString(@"It's a Fact", @"")
                            , nil];
    
    
    _tip_Text_Array = [[NSMutableArray alloc] initWithObjects:
                       
            NSLocalizedString(@"While graphing, a one finger touch creates a draggable cursor.", @"")
            , NSLocalizedString(@"While graphing, a two finger touch creates an adjustable crop zone.", @"")
            , NSLocalizedString(@"While graphing, a pinch gesture will zoom, and a swipe gesture will pan.", @"")
            , NSLocalizedString(@"While graphing, a single tap will select the top most sub-graph.", @"")
                       
            , NSLocalizedString(@"Press the crop tab button to crop data to the visible crop zone.", @"")
            , NSLocalizedString(@"Press the copy tab button to copy cropped data as new file.", @"")
            , NSLocalizedString(@"Press the Marker tab button to set a marker at the current cursor location.", @"")
            , NSLocalizedString(@"Press the Camera tab button to create an image of the current graph onto your Camera Roll.", @"")
            , NSLocalizedString(@"The y-scale of a selected sub-graph can be changed with a pinch gesture.", @"")
             
            , NSLocalizedString(@"The live recording display can display Accelleration values (x, y, z,), Attitude values (r, p, y), or Rotation speed values (x, y, z).", @"")
                       
            , NSLocalizedString(@"Pilot and plane names may be changed on the Settings screen and should be set before recording.", @"")
            , NSLocalizedString(@"The file name is the Root File Name from the Settings page, appended with an incrementing integer.", @"")
            , NSLocalizedString(@"The frequency of motion readings can be set on the Settings page.", @"")
                       
            , NSLocalizedString(@"GPS recording is not yet available with Flight Physica.", @"")
            , NSLocalizedString(@"Camera recording is not yet available with Flight Physica.", @"")
                       
            , NSLocalizedString(@"Flight Physica stores data using the CoreData framework.", @"")
            , NSLocalizedString(@"Flight Physica files are compatible with iCloud, although currently not implemented.", @"")
                       
            , nil];
    
    if ([application_Defaults boolForKey:DEFAULTS_TIPS_ON]) {
        
        [self display_Next_Tip];
        
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [liveGraph clearGraph ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - orientations

- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate");
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    //NSLog(@"supportedInterfaceOrientations");
    //UIInterfaceOrientationMaskPortrait
    //UIInterfaceOrientationMaskLandscapeLeft
    //UIInterfaceOrientationMaskLandscapeRight
    //UIInterfaceOrientationMaskPortraitUpsideDown
    //UIInterfaceOrientationMaskLandscape
    //UIInterfaceOrientationMaskAll
    //UIInterfaceOrientationMaskAllButUpsideDown
    //NSLog(@"supportedInterfaceOrientations!");
    return UIInterfaceOrientationMaskAll;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    NSLog(@"shouldAutorotateToInterfaceOrientation");
//    return YES;
//}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    //NSLog(@"didRotateFromInterfaceOrientation");
    [self.liveGraph clearGraph];
    
    //NSLog(@"didRotateFromInterfaceOrientation! %d", liveGraph.segments.count);
    //for (int i=0; i<self.liveGraph.segments.count; i++) {
    //    GraphViewSegment * segment = [ self.liveGraph.segments objectAtIndex:i ];
    //    segment.layer;
    //}
    
    //liveGraph.segments
    //resize layers for GraphView *liveGraph;
    //NSArray *liveGraph.segments
    //GraphTextView * liveGraph.text
}

#pragma mark - Tips

-(void)display_Next_Tip
{
    
#define ALERT_BUTTON_NEXT_TIP_INDEX			1
#define ALERT_BUTTON_CANCEL_INDEX			2
#define ALERT_BUTTON_NEVER_SHOW_AGAIN_INDEX	0
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString([_tip_Title_Array objectAtIndex:_current_Tip_Index], @"")
                                                        message:NSLocalizedString([_tip_Text_Array objectAtIndex:_current_Tip_Index], @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Don't Show Tips", @"")
                                              otherButtonTitles:NSLocalizedString(@"Next Tip", @""), NSLocalizedString(@"Close", @""), nil];
    
    alertView.cancelButtonIndex = ALERT_BUTTON_CANCEL_INDEX;
    [alertView show];
    
    _current_Tip_Index++;
    if (_current_Tip_Index >= _total_Tips) {
        _current_Tip_Index = 0;
    }
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // END VAR
    //#define ALERT_BUTTON_NEXT_TIP_INDEX			1
    //#define ALERT_BUTTON_CANCEL_INDEX			2
    //#define ALERT_BUTTON_NEVER_SHOW_AGAIN_INDEX	0
	// 1 = Next Tip
	// 2 = Cancel
	// 0 = Never show again
    
    switch (buttonIndex) {
        case ALERT_BUTTON_NEXT_TIP_INDEX:
            [self display_Next_Tip];
            break;
            
        case ALERT_BUTTON_CANCEL_INDEX:
            break;
            
        case ALERT_BUTTON_NEVER_SHOW_AGAIN_INDEX: {
            NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
			[application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_TIPS_ON];
			[application_Defaults synchronize];
            //self.sc_Main_Tips_Switch.on = NO;
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
}

#pragma mark - actions

-(void) updateFlightTimer:(NSTimer*) timer {
    
    if (self.motionRecorder.isRecording==YES) {
        
        NSDate * currentDate = [NSDate date];
        NSTimeInterval currentTime = [ currentDate timeIntervalSinceReferenceDate ];
        
        _flightTime = currentTime - _flightStartTime;
        
        NSNumber * flightTimeNumber = [ NSNumber numberWithDouble:_flightTime ];
        
        fileLabel.text = [NSString stringWithFormat:@"%4.0f seconds", [ flightTimeNumber floatValue ]];
        //fileLabel.text = [NSString stringWithFormat:@"%@ : %4.0fsec", NSLocalizedString(@"Recording",""), [ flightTimeNumber floatValue ]];
        fileLabel.textColor = [UIColor whiteColor];
        
        float flightLength = [self.motionRecorder flightLengthValue];
        if ( flightLength > 0. && [ flightTimeNumber floatValue ] > flightLength ) {
            NSLog(@" flight length reached ...");
            [self startRecording:nil]; // will stop recording
        }
        //NSNumber *listNumber = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_FLIGHTTIME_TYPE];
        //float flightLength = [self.motionRecorder flightLengthValue];
        
        
        
    } else {
        [timer invalidate];
    }
    
}

-(void) startRecordingAfterDelay {
    
    // play start sound
   // NSBundle * mainbundel = [NSBundle mainBundle];
   // NSURL *startSound   = [ mainbundel URLForResource: @"alarm2" withExtension: @"aif" ];//
   // AudioServicesCreateSystemSoundID ( (__bridge_retained CFURLRef) startSound, &soundFileObject );
   // AudioServicesPlayAlertSound (soundFileObject);
    
    if (self.motionRecorder.isRecording==NO) {
        
        self.motionRecorder.isRecording = YES;
        settingsButton.enabled = NO;
        filesButton.enabled = NO;
        self.recordButton.enabled = YES;
        
        [self.recordButton startRecordingAnimation];
        self.recordButton.buttonMode = RB_MODE_RECORDING;
        //[self.recordButton setNeedsDisplay];
                
        fileLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"Recording","")];
        fileLabel.textColor = [UIColor whiteColor];
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];// only when recording
        
        //NSTimer * _flightTimeUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateFlightTimer:) userInfo:nil repeats:YES];
        
        NSDate * currentDate = [NSDate date];
        _flightStartTime = [ currentDate timeIntervalSinceReferenceDate ];
        
    }
}

-(void) countdownTimerFire {
    countdownCounter--;
    if (countdownCounter > 0.0 && !self.motionRecorder.isRecording) {
        fileLabel.textColor = [UIColor blackColor];
        fileLabel.text = [ NSString stringWithFormat: @"T - %4.2f",countdownCounter ];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdownTimerFire) userInfo:nil repeats:NO];
    }
}

-(IBAction)startRecording:(id)sender {
    // this handles recordButton press
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    
    switch (self.recordButton.buttonMode) {
        case RB_MODE_RECORDING:
            // isRecording
            [ self stopRecording:nil ];
            [self.recordButton stopRecordingAnimation];
            break;
        case RB_MODE_READY:
            if(!self.motionRecorder.isRecording) {
                
                [ liveGraph clearGraph ];
                
                pendingFileName = [ appDelegate nextDefaultFileName : YES];
                
                [appDelegate createManagedDocument:pendingFileName];
                
                if (countdownCounter > 0.0) { // countdown in progress
                    return;
                }
                
                [ self.gpsTimer invalidate ];
                if(self.motionRecorder.gpsOn){
                    self.gpsTimer = [NSTimer scheduledTimerWithTimeInterval:self.motionRecorder.gpsInterval target:self selector:@selector(getTimedGPSData) userInfo:nil repeats:YES];
                }
                
                self.motionRecorder.startTrigger = [application_Defaults objectForKey:DEFAULTS_TRIGGER_TYPE];
                self.motionRecorder.stopTrigger = [application_Defaults objectForKey:DEFAULTS_FLIGHTTIME_TYPE];
                
                float startDelay = [self.motionRecorder startDelayValue];
                //float flightLength = [self.motionRecorder flightLengthValue];
                
                // delay, if neccesary
                [NSTimer scheduledTimerWithTimeInterval: startDelay target:self selector:@selector(startRecordingAfterDelay) userInfo:nil repeats:NO];
                
                if (startDelay > 1.0 ) {
                    countdownCounter = startDelay;
                    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdownTimerFire) userInfo:nil repeats:NO];
                    // deactivate record button
                    self.recordButton.enabled = NO;
                }
            }
            break;
        case RB_MODE_CLEAR:
            [ self clearRecording:self];
            break;
       
    } 
    
}

-(IBAction)stopRecording:(id)sender {
    
    self.motionRecorder.isRecording = NO;
    settingsButton.enabled = YES;
    filesButton.enabled = YES;
    
    self.recordButton.buttonMode = RB_MODE_CLEAR;
    [self.recordButton setNeedsDisplay];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];// turn sleep back on
    
    [self.gpsTimer invalidate];
    fileLabel.textColor = [UIColor whiteColor];
    if ( self.motionRecorder && self.motionRecorder.pointCount>0 ) {
        fileLabel.text = [ NSString stringWithFormat:@"Data: %d Points",self.motionRecorder.pointCount];
    } else {
        fileLabel.text = @"Ready";
        fileLabel.textColor = [ UIColor greenColor];
    }
    
    
    FPh_AppDelegate * appDel = (FPh_AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [ appDel addMetaData ];
    
    [ appDel saveContext : appDel.motionRecorder.activeFlightDocument ];
    
    // [ appDel.flightDocsController listLocalFiles];

}

-(IBAction)clearRecording:(id)sender {
    
    [ self.motionRecorder.headingDataArray removeAllObjects ];
    [ self.motionRecorder.locationDataArray removeAllObjects ];
    
    self.motionRecorder.pointCount = 0;
    self.motionRecorder.motionStartTime = 0.0;
    
    self.recordButton.enabled = YES;
    
    [liveGraph clearGraph];
    
    [liveGraph setNeedsDisplay];
    
    //fileLabel.textColor = [UIColor blackColor];
    fileLabel.textColor = [ UIColor greenColor];
    fileLabel.text = @"Ready";
    
    self.recordButton.buttonMode = RB_MODE_READY;
    [self.recordButton setNeedsDisplay];
    // [appDelegate.flightDocsController listLocalFiles];
    
    [self setSettingsText];
    
}

-(IBAction)graphRecording:(id)sender { // we can maybe use this, inactive for now
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"open_graphing_notification" object:nil userInfo:nil];
}

-(IBAction)filterSelect:(id)sender
{
   
    tabIndex = [sender selectedSegmentIndex];
    
    [ self.liveGraph selectFilter:tabIndex];
    
    switch (tabIndex) {
     case 0: //acceleration
     self.liveGraph.graphTextView.stringA = @"X";
     self.liveGraph.graphTextView.stringB = @"Y";
     self.liveGraph.graphTextView.stringC = @"Z";
     break;
     case 1: // attitude
     self.liveGraph.graphTextView.stringA = @"R";
     self.liveGraph.graphTextView.stringB = @"P";
     self.liveGraph.graphTextView.stringC = @"Y";
     break;
     case 2: //rotation
     self.liveGraph.graphTextView.stringA = @"X";
     self.liveGraph.graphTextView.stringB = @"Y";
     self.liveGraph.graphTextView.stringC = @"Z";
     break;
     case 3: // heading
     
     break;
     case 4: //gravity
     
     break;
     default:
     NSLog(@"unexpected tab selection %d", tabIndex);
     break;
     }
     
     [self.liveGraph.graphTextView setNeedsDisplay];
     
     NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
     [application_Defaults setObject:[NSNumber numberWithInt:tabIndex] forKey:DEFAULTS_REC_GRAPH_TYPE_SETTING];
     [application_Defaults synchronize];
     //default_RecorderGraphViewType,
     //[self.view layoutSubviews ];
     // Inform accessibility clients that the filter has changed.
     //UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
     
}

-(void) setSettingsText {
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*) [UIApplication sharedApplication].delegate;
    NSUserDefaults	*application_Defaults = [NSUserDefaults standardUserDefaults];
    
    pendingFileName = [ appDelegate nextDefaultFileName : NO ];
    
    self.fileNameLabel.text = pendingFileName;
    
    
    
    //NSString *str1 = NSLocalizedString(@"pilot:", @"");
    //NSString *str2 = NSLocalizedString(@"plane:", @"");
    
    NSString * piStr = [application_Defaults stringForKey:DEFAULTS_PILOT_NAME];
    NSString * plStr = [application_Defaults stringForKey:DEFAULTS_PLANE_NAME];
    
    //NSString *ppString = [NSString stringWithFormat:@"%@ %@ %@ %@",str1, piStr, str2, plStr];
    
    self.pilotLabel.text = piStr;
    self.planeLabel.text = plStr;
    
    /*NSLog(@"setSettingsText");
    
    //use instrumentation availability
    BOOL deviceMotionAvailable = self.motionRecorder.motionManager.deviceMotionAvailable;
    BOOL gyroAvailable = self.motionRecorder.motionManager.gyroAvailable;
    BOOL locationServicesEnabled = self.motionRecorder.locationManager.locationServicesEnabled;
    
    if (deviceMotionAvailable) {
        motionDeltaLabel.text = [ NSString stringWithFormat:@"%4.2f sec", self.motionRecorder.motionInterval ];
        
        float delayTime =  [self.motionRecorder startDelayValue];
        if (delayTime == 0.0) {
            triggerLabel.text = NSLocalizedString(@"Touch Button",@"");
        } else {
            triggerLabel.text = [NSString stringWithFormat:@"delay: %4.0f secs.",delayTime];
        }
        
        // we need to get arraystrings currently in SettingsTableController
        //if (self.motionRecorder.startTrigger == 0) {
        
        //}else {
        //    triggerLabel.text = @"10 second trigger";
        //}
    } else {
        motionDeltaLabel.text = NSLocalizedString(@"unavailable", @"") ;
        triggerLabel.text = NSLocalizedString( @"N. A.", @"") ;
    }
    
    if (self.motionRecorder.bCameraOn) {
        cameraDeltaLabel.text = [NSString stringWithFormat:@"camera: %4.2f secs.",self.motionRecorder.cameraInterval];
    } else {
        cameraDeltaLabel.text = NSLocalizedString(@"Camera: off", @"");
    }
    
    if (self.motionRecorder.gpsOn) {
        gpsDeltaLabel.text = [NSString stringWithFormat:@"GPS: %4.2f secs.",self.motionRecorder.gpsInterval];
    } else {
        gpsDeltaLabel.text = NSLocalizedString(@"GPS: Off", @"");
    }
    
    ///////////////
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    pendingFileName = [ appDelegate nextDefaultFileName : NO ];
    
    self.navBar.topItem.title = pendingFileName;
    */
}

-(IBAction)activateHelp:(id)sender {
    NSLog(@"activateHelp");
    // later ...
    /*    if(!helpController) {
     helpController = [[PDF_Help_VC alloc] initWithNibName:@"PDF_Help_VC" bundle:nil];
     
     }
     UINavigationController * navcon = [[UINavigationController alloc] initWithRootViewController:helpController];
     [ self presentViewController:navcon animated:YES completion: nil];
     
     */
}

# pragma mark - notifications

-(void) restartMotionManager:(NSNotification*) notif {
    
    NSNumber * number = [ NSNumber numberWithDouble: self.motionRecorder.motionInterval ];
    NSString * displayString = [NSString stringWithFormat:@"%4.2f Hz.", 1.0/[number floatValue] ];
    motionDeltaLabel.text = displayString;
    
    if ([self.motionRecorder.motionManager isDeviceMotionActive]) {
        [self.motionRecorder.motionManager stopDeviceMotionUpdates];
        [self.motionRecorder startDeviceMotionUpdates ];
    }
}

-(void) displayNextTipNote :(NSNotification*) notif {
    [ self display_Next_Tip ];
}

-(void) settingsAppliedNote :(NSNotification*) notif {
    
    [ self setSettingsText ];
    
    
    
}

-(void) addMotionDataPointToLiveGraphNote :(NSNotification*) notif {
    
    if (!bLiveGraph) return;
    
    CMDeviceMotion * motionData = notif.object;
    //NSTimeInterval stamp = motionData.timestamp;
    
    CMAttitude * attitood = motionData.attitude;
    CMAcceleration grav = motionData.gravity;
    CMRotationRate rotRate = motionData.rotationRate;
    CMAcceleration accel = motionData.userAcceleration;
    
    // put it in graph view
    switch (tabIndex) {
        case 0: //acceleration
            //[ filter addAcceleration:accel ];
            [ liveGraph addX:accel.x y:accel.y z:accel.z ];
            break;
        case 1: // attitude
            //[ filter addAttitude:attitood ];
            [ liveGraph addX:attitood.roll/2.0 y:attitood.pitch z:attitood.yaw/2. ];
            break;
        case 2: //rotation
            //[ filter addRotationSpeed:rotRate ];
            [ liveGraph addX:rotRate.x/8. y:rotRate.y/8. z:rotRate.z/8. ];
            break;
        case 3: // heading
            [ liveGraph addX:self.motionRecorder.currentHeading/100.0 y:self.motionRecorder.currentHeading/200.0 z:self.motionRecorder.currentHeading/400.0 ];
            //
            break;
        case 4: //gravity
            //[ filter addGravity:grav ];
            [ liveGraph addX:grav.x y:grav.y z:grav.z ];
            break;
        default:
            NSLog(@"unexpected tab selection %d", tabIndex);
            break;
    };
}

-(void) remoteTriggerNoted:(NSNotification*) notif {
    NSLog(@"remoteTriggerNoted");
    [ self startRecording:nil ];
}

-(void) liveGraphingSwitchedNoted:(NSNotification*) notif {
    NSNumber * switched = notif.object;
    bLiveGraph = [switched boolValue];
    if(bLiveGraph) {
        
        [self.liveGraph addSubview:self.liveGraph.graphTextView];
        
    } else {
        
        [self.liveGraph clearGraph];
        
        [self.liveGraph.graphTextView removeFromSuperview];
    }
}


#pragma mark - photo camera

////////////////////////////////
- (IBAction)photoLibraryAction:(id)sender
{
	NSLog(@"photoLibraryAction");
    [self show_Image_Picker:UIImagePickerControllerSourceTypeCamera ];
    //UIImagePickerControllerSourceTypePhotoLibrary];
}

//=********************************************************************=//
- (void)show_Image_Picker:(UIImagePickerControllerSourceType)sourceType
{
    // set up imagepicker
    //self.captured_Images = [NSMutableArray array];
	self.image_Picker_Controller = [[UIImagePickerController alloc] init];
	self.image_Picker_Controller.delegate = self;
    
    //if ( self.captured_Images.count > 0 )
    //    [ self.captured_Images removeAllObjects ];
    
    if ( [ UIImagePickerController isSourceTypeAvailable:sourceType ] )
    {
        [ self setup_Image_Picker:sourceType ];
        [ self presentModalViewController:self.image_Picker_Controller animated:NO ];
    }
}

//=********************************************************************=//
//	setupImagePicker
////////////////////////////////
- (void)setup_Image_Picker:(UIImagePickerControllerSourceType)sourceType
{
	//NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    
    
	//float transparency = [application_Defaults floatForKey:DEFAULTS_MAIN_TRANSPARENCY];
    // END VAR
    
    
    self.image_Picker_Controller.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /* // user wants to use the camera interface
         //
         self.image_Picker_Controller.showsCameraControls = NO;
         if ([application_Defaults boolForKey:DEFAULTS_VIDEO_LIMIT_RECORDING] == NO) {
         self.image_Picker_Controller.videoMaximumDuration = 600;
         }
         else {
         self.image_Picker_Controller.videoMaximumDuration = [application_Defaults integerForKey:DEFAULTS_VIDEO_RECORD_LENGTH] * 60;
         }
         
         self.image_Picker_Controller.videoQuality = [self get_Video_Quality];
         self.image_Picker_Controller.cameraFlashMode = [self get_Flash_Mode];
         
         if ([application_Defaults integerForKey:DEFAULTS_MAIN_CAMERA] == CAMERA_FRONT) {
         self.image_Picker_Controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
         }
         else {
         self.image_Picker_Controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
         }
         
         if (self.image_Picker_Controller.cameraOverlayView != self.view)
         {
         // setup our custom overlay view for the camera
         CGRect overlayViewFrame = self.image_Picker_Controller.cameraOverlayView.frame;
         CGRect newFrame = CGRectMake(0.0,
         CGRectGetHeight(overlayViewFrame) -
         self.view.frame.size.height - 9.0,
         CGRectGetWidth(overlayViewFrame),
         self.view.frame.size.height + 9.0);
         self.view.frame = newFrame;
         
         [self adjust_For_New_Settings];
         }
         */
    }
}

//=********************************************************************=//
#pragma mark -
#pragma mark UIImagePickerControllerDelegate
//=********************************************************************=//


//=********************************************************************=//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //=--------------------------------------------------------------------=//
    // this get called when an image has been chosen from the library or taken from the camera
    //=--------------------------------------------------------------------=//
/*	NSString * mediaType = [ info objectForKey: @"UIImagePickerControllerMediaType" ];
	if (mediaType) {
		if ( [ mediaType compare:(NSString *)kUTTypeMovie ] == NSOrderedSame ) { // its a movie
			NSURL * url = [ info objectForKey:@"UIImagePickerControllerMediaURL" ];
			if ( url ) {
				// save to camera roll here
				//if ( UIVideoAtPathIsCompatibleWithSavedPhotosAlbum ( [ url relativePath ] ) ) {
				//	UISaveVideoAtPathToSavedPhotosAlbum ( [ url relativePath ],  NULL, NULL,NULL  );
				//}
			}
			//[ self didFinishWithCamera ];
		} else if ( [ mediaType compare:(NSString *)kUTTypeImage ] == NSOrderedSame )  {
			UIImage *image = [ info valueForKey:UIImagePickerControllerOriginalImage ];
			
            ///////[ self.captured_Images addObject:image ];
            
			// this is pre 4.0 non meta data form
			//UIImageWriteToSavedPhotosAlbum ( image, NULL, NULL, NULL );
			
			//////if (_max_Pictures != 0) {
			//////	if ( _pictures_Taken >= _max_Pictures ) {
			//////		_dismiss_On_End = YES;
			//////	}
			//////}
			
		}
	}
	
	//this gives all the keys in the dictionary
	//NSArray * keys = [ info allKeys ];
	//for (int i=0; i<[ keys count ]; i++ ) {
	//	NSString * key = [ keys objectAtIndex:i ];
	//	(@"key = %@", key );
	//}
	
	//To save a still image to the user’s Camera Roll album, call the UIImageWriteToSavedPhotosAlbum function from within the body of the imagePickerController:didFinishPickingMediaWithInfo: method.
	//To save a movie to the user’s Camera Roll album, instead call the UISaveVideoAtPathToSavedPhotosAlbum function.
	//These functions, described in UIKit Function Reference, save the image or movie only; they do not save metadata.
	//Starting in iOS 4.0, you can save still-image metadata, along with a still image, to the Camera Roll.
	//To do this, use the writeImageToSavedPhotosAlbum:metadata:completionBlock: method of the Assets Library framework. See the description for the UIImagePickerControllerMediaMetadata key.
    
	//self.sc_Number_Of_Vibrates = 2;
	//_is_Recording = NO;
	[self dismissModalViewControllerAnimated:NO];
	
	//[NSTimer scheduledTimerWithTimeInterval:1.0
	//	target:self
	//	selector:@selector(end_Video_Capture_Phase_1_Timer:)
	//	userInfo:nil
	//	repeats:NO];
	*/
    
} // - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//=********************************************************************=//


//=********************************************************************=//
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self didFinishWithCamera];    // tell our delegate we are finished with the picker
}
//=********************************************************************=//

//=********************************************************************=//
// as a delegate we are told to finish with the camera
- (void)didFinishWithCamera
{
	[self dismissModalViewControllerAnimated:NO];
    
	//[ NSTimer scheduledTimerWithTimeInterval:1.0   target:self
	//										  selector:@selector(dismiss_Phase_2_Timer:) userInfo: [ NSNumber numberWithInt:5 ]
	//										   repeats:NO ];
}


@end
