//
//  FPh_ViewController.h
//  Flight Physica
//
//  Created by David Lathrop on 1/5/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FPh_RecorderView.h"

#import "LiveGraphView.h"

#import <GameKit/GameKit.h>
#import <CoreMotion/CMMotionManager.h>
//#import <CoreLocation/CLHeading.h>
#import <Accelerate/Accelerate.h>

#include <AudioToolbox/AudioToolbox.h>

#import "MotionRecorder.h"
#import "FPh_HeadingView.h"
#import "RecordButton.h"

//#import "PDF_Help_VC.h"

@class LiveGraphView;

@interface FPh_ViewController : UIViewController <UIAccelerometerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    
    UINavigationBar * _navBar;
    NSTimer* _gpsTimer;
    
    // camera
    UIImagePickerController *_image_Picker_Controller;
    
	NSString *pendingFileName;
    
	BOOL useAdaptive;
    
    CMDeviceMotion  *lastMotion;
    CMAttitude * referenceAttitude;
    
    MotionRecorder * _motionRecorder;
    
    FPh_RecorderView *recorderView;
    int tabIndex;
    
    LiveGraphView *liveGraph;
    BOOL bLiveGraph;
    UISegmentedControl * liveGraphSegControl;
    UILabel *motionDeltaLabel;
    UILabel *gpsDeltaLabel;
    UILabel *cameraDeltaLabel;
    UILabel *triggerLabel;
    UILabel *fileNameLabel;
    UILabel *pilotLabel;
    UILabel *planeLabel;
    RecordButton *recordButton;
    
    UIBarButtonItem * settingsButton;
    UIBarButtonItem * filesButton;
    
    //UILabel *pairingLabel;
    UILabel *fileLabel;
    
    
    
    float countdownCounter;
    
    NSTimer * _flightTimeUpdateTimer;
    NSTimeInterval _flightTime;
    NSTimeInterval _flightStartTime;
    
    //sound
    NSURL *		soundFileURLRef;
	SystemSoundID	soundFileObject;
    
    // This is for Tips.
    NSInteger      _total_Tips;
    NSInteger      _current_Tip_Index;
    NSMutableArray *_tip_Title_Array;
    NSMutableArray *_tip_Text_Array;
    
}

@property (nonatomic, retain) IBOutlet UINavigationBar * navBar;

@property(nonatomic, retain) NSTimer* gpsTimer;

@property (nonatomic, retain) UIImagePickerController *image_Picker_Controller;



@property(nonatomic, retain) IBOutlet UIBarButtonItem * settingsButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * filesButton;

@property(nonatomic, retain) CMAttitude * referenceAttitude;
@property(nonatomic, retain) CMDeviceMotion  *lastMotion;

@property(nonatomic, retain) MotionRecorder * motionRecorder;

@property(nonatomic, retain) IBOutlet FPh_RecorderView *recorderView;
// these are all subviews of the main view
@property(nonatomic, retain) IBOutlet LiveGraphView *liveGraph;
@property(nonatomic, retain) IBOutlet UISegmentedControl * liveGraphSegControl;
@property(nonatomic, retain) IBOutlet UILabel *fileLabel;
@property(nonatomic, retain) IBOutlet UILabel *motionDeltaLabel;
@property(nonatomic, retain) IBOutlet UILabel *gpsDeltaLabel;
@property(nonatomic, retain) IBOutlet UILabel *cameraDeltaLabel;
@property(nonatomic, retain) IBOutlet UILabel *triggerLabel;
@property(nonatomic, retain) IBOutlet UILabel *fileNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *pilotLabel;
@property(nonatomic, retain) IBOutlet UILabel *planeLabel;
@property(nonatomic, retain) IBOutlet RecordButton *recordButton;


@property (readwrite)	NSURL *		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;

-(void) setSettingsText;

#pragma mark Actions

-(IBAction)startRecording:(id)sender;
-(IBAction)stopRecording:(id)sender;
-(IBAction)clearRecording:(id)sender;
-(IBAction)graphRecording:(id)sender;

-(IBAction)activateHelp:(id)sender;
-(void)display_Next_Tip;

- (IBAction)photoLibraryAction:(id)sender;

// camera
- (IBAction)photoLibraryAction:(id)sender;
- (void)show_Image_Picker:(UIImagePickerControllerSourceType)sourceType;
- (void)setup_Image_Picker:(UIImagePickerControllerSourceType)sourceType;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
- (void)didFinishWithCamera;


@end
