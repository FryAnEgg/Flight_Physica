//
//  FPh_RecSettingsViewController.h
//  Flight Physica
//
//  Created by David Lathrop on 1/12/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MotionRecorder.h"

typedef enum {
    kSettingsFlightDataSection,
    
	kSettingsMotionSection,
	//kSettingsGPSSection,
	//kSettingsCameraSection,
    kSettingsTipsSection,
    kSettingsComingSection,
    
    kDisplayTriggerTimeSettings,
    //kSettingsCloudSection,
	//kSettingsPilotSection,
	//kSettingsPlaneSection,
    kSettingsLastSection
} settingTableSections;

@interface FPh_RecSettingsViewController : UITableViewController <UITextFieldDelegate> {
    
    MotionRecorder * _motionRecorder;
    
    UILabel * sectionHeaderView;
    
    UILabel * naLabel;
    UISwitch * uiMotionSwitch;
    UISwitch * uiGPSSwitch;
    UISwitch * uiCameraSwitch;
    UISwitch * uiTipsSwitch;
    
    UISlider *motionIntervalSlider;
    //TimeDisplayLayer * _motionIntervalOverLayer;
    BOOL _motionIntervaSettingNewValuePending;
    BOOL _motionIntervaSettingTimerLive;
    
    UISlider *gpsIntervalSlider;
    UISlider *photoIntervalSlider;
    
    UISwitch *cloudSwitch;
    
    BOOL bSampleRateHasChanged;
    
    UITextField * textEditField;
    UITextField * pilotEditField;
    UITextField * planeEditField;
    
    UISwitch * liveGraphingSwitch;
    UIPickerView * triggerPicker;
}

@property(nonatomic, retain) MotionRecorder * motionRecorder;

@property(nonatomic,retain)IBOutlet UILabel * sectionHeaderView;

@property(nonatomic,retain)IBOutlet UISwitch * uiMotionSwitch;
@property(nonatomic,retain)IBOutlet UISwitch * uiGPSSwitch;
@property(nonatomic,retain)IBOutlet UISwitch * uiCameraSwitch;
@property(nonatomic,retain)IBOutlet UISwitch * uiTipsSwitch;
@property(nonatomic,retain)IBOutlet UILabel * naLabel;

@property(nonatomic,retain)IBOutlet UISlider *motionIntervalSlider;
@property(nonatomic,retain)IBOutlet UISlider *gpsIntervalSlider;
@property(nonatomic,retain)IBOutlet UISlider *photoIntervalSlider;

@property(nonatomic,retain)IBOutlet UISwitch *cloudSwitch;

@property(nonatomic,retain)IBOutlet UITextField * textEditField;
@property(nonatomic,retain)IBOutlet UITextField * pilotEditField;
@property(nonatomic,retain)IBOutlet UITextField * planeEditField;

@property(nonatomic,retain)IBOutlet UISwitch * liveGraphingSwitch;
@property(nonatomic,retain)IBOutlet UIPickerView * triggerPicker;

-(IBAction)defaultSettings:(id)sender;
-(IBAction)closeSettings:(id)sender;

-(IBAction)tipsSwitchSetting:(id)sender;

-(IBAction)motionSwitchSetting:(id)sender;
-(IBAction)motionIntervalSetting:(id)sender;

-(IBAction)photoSwitchSetting:(id)sender;
-(IBAction)photoIntervalSetting:(id)sender;

-(IBAction)gpsSwitchSetting:(id)sender;
-(IBAction)gpsIntervalSetting:(id)sender;

-(IBAction)liveGraphingSwitched:(id)sender;

@end
