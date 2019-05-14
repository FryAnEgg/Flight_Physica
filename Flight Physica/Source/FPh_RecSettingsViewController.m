//
//  FPh_RecSettingsViewController.m
//  Flight Physica
//
//  Created by David Lathrop on 1/12/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_RecSettingsViewController.h"

#import "FlightAppConstants.h"
#import "FPh_AppDelegate.h"

@interface FPh_RecSettingsViewController ()

@end

@implementation FPh_RecSettingsViewController

@synthesize motionIntervalSlider, uiMotionSwitch, uiCameraSwitch, uiTipsSwitch, textEditField;
@synthesize pilotEditField, gpsIntervalSlider, liveGraphingSwitch, cloudSwitch;
@synthesize planeEditField, naLabel, uiGPSSwitch, triggerPicker,sectionHeaderView;
@synthesize photoIntervalSlider;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Apply", @"")
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(apply_Action:)];
    
    applyButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = applyButton;
    
    
	_motionIntervaSettingNewValuePending = NO;
    _motionIntervaSettingTimerLive = NO;
    
    //_motionIntervalOverLayer = [[TimeDisplayLayer alloc] init];
    //_motionIntervalOverLayer.theFont =  [ UIFont fontWithName:@"Helvetica" size:18.0 ];
    //_motionIntervalOverLayer.theColor = [ UIColor redColor ];
    //_motionIntervalOverLayer.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    /*UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done")
     style:UIBarButtonItemStyleBordered
     target:self
     action:@selector(closeSettings:)];
     
     self.navigationItem.rightBarButtonItem = doneButton;
     
     UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
     style:UIBarButtonItemStyleBordered
     target:self
     action:@selector(cancelSettings:)];
     
     self.navigationItem.leftBarButtonItem = cancelButton;
     */
    
    bSampleRateHasChanged = NO;
    // Set up default values.
    //self.tableView.sectionHeaderHeight = 21.0;
    
    NSNotificationCenter * noteCen = [ NSNotificationCenter defaultCenter ];
    
    [ noteCen addObserver:self  selector:@selector(updateTriggerValue:)name:@"update_trigger_value"  object:nil];
    [ noteCen addObserver:self  selector:@selector(updateFlightTimeValue:)name:@"update_flight_time_value"  object:nil];
    
    NSUserDefaults	*application_Defaults = [NSUserDefaults standardUserDefaults];
    
    self.textEditField.text = [application_Defaults stringForKey:DEFAULTS_FILE_NAME_ROOT];
    self.pilotEditField.text = [application_Defaults stringForKey:DEFAULTS_PILOT_NAME];
    self.planeEditField.text =[application_Defaults stringForKey:DEFAULTS_PLANE_NAME];
    
    self.uiTipsSwitch.on = [application_Defaults boolForKey:DEFAULTS_TIPS_ON];
    //self.uiMotionSwitch.on = YES;//[application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_X];
    
    FPh_AppDelegate * appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    self.motionRecorder = appDelegate.motionRecorder;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPicker notifications

-(void) updateTriggerValue :(NSNotification*) notif {
    
    NSNumber * number = notif.object;
    
    self.motionRecorder.startTrigger = number;
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:number forKey:DEFAULTS_TRIGGER_TYPE];
	[application_Defaults synchronize];
    //[self.tableView reloadData];
    
}

-(void) updateFlightTimeValue :(NSNotification*) notif {
    
    NSNumber * number = notif.object;
    
    self.motionRecorder.stopTrigger = number;
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:number forKey:DEFAULTS_FLIGHTTIME_TYPE];
	[application_Defaults synchronize];
    //[self.tableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSettingsLastSection - 1; //eliminates last section for now
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retValue = 1;
    
    switch (section) {
        case kSettingsFlightDataSection:
            retValue = 3;
            break;
        case kSettingsMotionSection:
            retValue = 2;
            break;
        //case kSettingsGPSSection:
        //    if(self.motionRecorder.gpsOn) {
        //        retValue = 2;
        //    }
        //    break;
        //case kSettingsCameraSection:
        //    if(self.motionRecorder.bCameraOn) {
        //        retValue = 2;
        //    }
        //    break;
        case kSettingsTipsSection:
            retValue = 1;
            break;
        case kSettingsComingSection:
            retValue = 4;
            break;
        case kDisplayTriggerTimeSettings:
            //case kTriggerSettings:
            //case kSettingsCloudSection:
            retValue = 3;
            break;
    }
    
    return retValue;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSUserDefaults	*application_Defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * listNumber;
    //if (cell == nil) {
    //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //}
    
    //if (indexPath.row%2 == 0) {
    //   UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
    //   cell.backgroundColor = altCellColor;
    //}
    
    switch (indexPath.section) {
        case kSettingsFlightDataSection:
            switch (indexPath.row) {
                case 0:
                    //cell = self.textEditCell;
                    //cell.textLabel.text = NSLocalizedString(@"File Name Here", @"");
                    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    //cell.imageView.image = [UIImage imageNamed:@"fs_files"];
                    //if (cell.selected) {
                    //    self.textEditField.hidden = NO;
                    //}
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsFileNameCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsFileNameCell"];
                        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                        cell.textLabel.text = NSLocalizedString(@"Root Name:", @"");
                        cell.accessoryView = self.textEditField;
                        cell.imageView.image = [UIImage imageNamed:@"fs_files"];
                    }
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"PilotCell"];
                    
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PilotCell"];
                        cell.accessoryView = self.pilotEditField;
                        cell.imageView.image = [UIImage imageNamed:@"fs_user"];
                        cell.textLabel.text = NSLocalizedString(@"Pilot:", @"");
                        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    }
                    break;
                case 2:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaneCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlaneCell"];
                        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                        cell.accessoryView = self.planeEditField;
                        cell.imageView.image = [UIImage imageNamed:@"fs_plane"];
                        cell.textLabel.text = NSLocalizedString(@"Plane:", @"");
                    }
                    break;
                    
            };
            break;
        case kSettingsMotionSection:
            switch (indexPath.row) {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"MotionSwitchCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MotionSwitchCell"];
                        cell.textLabel.text = NSLocalizedString(@"Motion", @"");
                        cell.accessoryView = self.uiMotionSwitch;
                        self.uiMotionSwitch.on = YES;//[application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_X];
                        cell.imageView.image = [UIImage imageNamed:@"fs_motion"];
                    }
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"MotionIntervalCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MotionIntervalCell"];
                        cell.accessoryView = self.motionIntervalSlider;
                        self.motionIntervalSlider.value = 1./self.motionRecorder.motionInterval;
                        cell.imageView.image = [UIImage imageNamed:@"fs_clock"];
                        
                        //_motionIntervalOverLayer.layer.bounds = CGRectMake(0.0, 0.0, 120.0, cell.bounds.size.height - 10.0);
                        //CGPoint layerPoint = CGPointMake(110.0, cell.bounds.size.height/2.0);
                        //_motionIntervalOverLayer.layer.position = layerPoint;
                        //_motionIntervalOverLayer.layer.opacity = 0.0;
                        //[cell.layer addSublayer:_motionIntervalOverLayer.layer];
                        
                        //[_motionIntervalOverLayer.layer setNeedsDisplay];
                        
                    }
                    
                    NSString * string = NSLocalizedString(@"Freq", @"");
                    NSString * displayString = [NSString stringWithFormat:@"%@: %4.2f Hz.", string, self.motionIntervalSlider.value ];
                    cell.textLabel.text = displayString;
                    //_motionIntervalOverLayer.timeString = displayString;
                    break;
            }
            
            
            break;
            
        case kSettingsTipsSection:
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TipsSettingCell"];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TipsSettingCell"];
                cell.accessoryView = self.uiTipsSwitch;
                //self.photoIntervalSlider.value = self.motionRecorder.cameraInterval;//[application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_X];
                cell.imageView.image = [UIImage imageNamed:@"fs_tipstar"];
            }
            
            //NSString * string = [NSString stringWithFormat:@"%2.0f secs.", self.motionRecorder.cameraInterval];
            cell.textLabel.text = @"Tips";//[NSString stringWithFormat:@"%2.0f secs.", self.motionRecorder.cameraInterval];
            
            break;
            
        case kSettingsComingSection:
            
            switch (indexPath.row) {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"GPSSwitchCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GPSSwitchCell"];
                        cell.textLabel.text = NSLocalizedString(@"GPS", @"");
                        
                        if ([CLLocationManager locationServicesEnabled]) {
                            cell.detailTextLabel.text = NSLocalizedString(@"Coming Soon", @"");
                        } else {
                            cell.detailTextLabel.text = NSLocalizedString(@"Not Available", @"");
                        }
                        //cell.accessoryView = self.uiGPSSwitch;
                        cell.accessoryView = self.naLabel;
                        self.uiGPSSwitch.on = self.motionRecorder.gpsOn;
                        cell.imageView.image = [UIImage imageNamed:@"fs_map"];
                    }
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"CameraSwitchCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CameraSwitchCell"];
                        cell.textLabel.text = NSLocalizedString(@"Camera", @"");
                        cell.detailTextLabel.text = NSLocalizedString(@"Coming Soon", @"");
                        //cell.accessoryView = self.uiCameraSwitch;
                        //cell.accessoryView = self.naLabel;
                        self.uiCameraSwitch.on = self.motionRecorder.bCameraOn;
                        cell.imageView.image = [UIImage imageNamed:@"fs_camera"];
                    }
                    break;
                case 2:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"AnalysisCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AnalysisCell"];
                        cell.textLabel.text = NSLocalizedString(@"Analysis", @"");
                        cell.detailTextLabel.text = NSLocalizedString(@"Coming Soon", @"");
                        //cell.accessoryView = self.uiCameraSwitch;
                        //cell.accessoryView = self.naLabel;
                        //self.uiCameraSwitch.on = self.motionRecorder.bCameraOn;
                        cell.imageView.image = [UIImage imageNamed:@"fs_analysis"];
                    }
                    break;
                case 3:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"TriggerCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TriggerCell"];
                        cell.textLabel.text = NSLocalizedString(@"Triggers", @"");
                        cell.detailTextLabel.text = NSLocalizedString(@"Coming Soon", @"");
                        //cell.accessoryView = self.uiCameraSwitch;
                        //cell.accessoryView = self.naLabel;
                        //self.uiCameraSwitch.on = self.motionRecorder.bCameraOn;
                        cell.imageView.image = [UIImage imageNamed:@"fs_tipstar"];
                    }
                    break;
            }
            break;
        /*case kSettingsGPSSection:
            
            switch (indexPath.row) {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"GPSSwitchCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GPSSwitchCell"];
                        cell.textLabel.text = NSLocalizedString(@"GPS", @"");
                        
                        if ([CLLocationManager locationServicesEnabled]) {
                            cell.detailTextLabel.text = NSLocalizedString(@"Coming Soon", @"");
                        } else {
                            cell.detailTextLabel.text = NSLocalizedString(@"Not Available", @"");
                        }
                        //cell.accessoryView = self.uiGPSSwitch;
                        cell.accessoryView = self.naLabel;
                        self.uiGPSSwitch.on = self.motionRecorder.gpsOn;
                        cell.imageView.image = [UIImage imageNamed:@"fs_map"];
                    }
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"GPSIntervalCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GPSIntervalCell"];
                        cell.accessoryView = self.gpsIntervalSlider;
                        self.gpsIntervalSlider.value = self.motionRecorder.gpsInterval;
                        cell.imageView.image = [UIImage imageNamed:@"fs_clock"];
                    }
                    NSString * string = [NSString stringWithFormat:@"%2.0f secs.", self.motionRecorder.gpsInterval];
                    cell.textLabel.text = string;
                    break;
            }
            
            
            
            break;
        //case kSettingsCameraSection:
            
            switch (indexPath.row) {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"CameraSwitchCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CameraSwitchCell"];
                        cell.textLabel.text = NSLocalizedString(@"Camera", @"");
                        cell.detailTextLabel.text = NSLocalizedString(@"Coming Soon", @"");
                        //cell.accessoryView = self.uiCameraSwitch;
                        //cell.accessoryView = self.naLabel;
                        self.uiCameraSwitch.on = self.motionRecorder.bCameraOn;
                        cell.imageView.image = [UIImage imageNamed:@"fs_camera"];
                    }
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoIntervalCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PhotoIntervalCell"];
                        cell.accessoryView = self.photoIntervalSlider;
                        self.photoIntervalSlider.value = self.motionRecorder.cameraInterval;//[application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_X];
                        cell.imageView.image = [UIImage imageNamed:@"fs_clock"];
                    }
                    NSString * string = [NSString stringWithFormat:@"%2.0f secs.", self.motionRecorder.cameraInterval];
                    cell.textLabel.text = string;
                    break;
            };
            
            break;
            
         */
            
#define kTriggerCellIndex 1
#define kFlightLengthCellIndex 2
            
        case kDisplayTriggerTimeSettings:
            
            switch (indexPath.row) {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"DisplayOptionCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DisplayOptionCell"];
                        cell.textLabel.text = NSLocalizedString(@"Live Graphing", @"");
                        cell.accessoryView = self.liveGraphingSwitch;
                        self.liveGraphingSwitch.on = [application_Defaults boolForKey:DEFAULTS_LIVE_GRAPH_ON]; // get from prefs
                        //cell.imageView.image = [UIImage imageNamed:@"fs_camera"];
                    }
                    break;
                case kTriggerCellIndex:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"TriggerOptionsCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TriggerOptionsCell"];
                        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                        //cell.accessoryView = self.uiCameraSwitch;
                        //self.uiCameraSwitch.on = self.motionRecorder.bCameraOn;
                        //cell.imageView.image = [UIImage imageNamed:@"fs_camera"];
                    }
                    
                    listNumber = [application_Defaults objectForKey:DEFAULTS_TRIGGER_TYPE];
                    cell.textLabel.text = @"Trig opt";
                    //cell.textLabel.text = [self.motionRecorder.triggerOptionStrings objectAtIndex:[listNumber intValue]];// NSLocalizedString(@"Trigger", @"");
                    
                    break;
                case kFlightLengthCellIndex:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"FlightLengthCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlightLengthCell"];
                        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                        //cell.accessoryView = self.uiCameraSwitch;
                        //self.uiCameraSwitch.on = self.motionRecorder.bCameraOn;
                        //cell.imageView.image = [UIImage imageNamed:@"fs_camera"];
                    }
                    listNumber = [application_Defaults objectForKey:DEFAULTS_FLIGHTTIME_TYPE];
                    cell.textLabel.text = @"Flight Time";
                    //cell.textLabel.text = [self.motionRecorder.flightTimeOptionStrings objectAtIndex:[listNumber intValue]]; //NSLocalizedString(@"Flight Length", @"");
                    break;
            }
            break;
            /*
             case kSettingsCloudSection:
             cell = [tableView dequeueReusableCellWithIdentifier:@"CloudCell"];
             if (cell == nil)
             {
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CloudCell"];
             cell.textLabel.text = @"Cloud";
             cell.accessoryView = self.cloudSwitch;
             self.cloudSwitch.on = [application_Defaults boolForKey:DEFAULTS_CLOUD_ON];
             cell.imageView.image = [UIImage imageNamed:@"fs_user"];
             
             cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
             }
             break;
             */
    }
    
    return cell;
}

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
 NSString * retString = @"";
 
 switch (section) {
 //case kSettingsFlightDataSection:
 //    retString = NSLocalizedString(@"File", @"");
 //    break;
 case kSettingsMotionSection:
 retString = NSLocalizedString(@"Motion", @"");
 break;
 case kSettingsGPSSection:
 retString = NSLocalizedString(@"GPS", @"");
 break;
 case kSettingsCameraSection:
 retString = NSLocalizedString(@"Camera", @"");
 break;
 }
 
 return retString;
 }
 */

//-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
//self.sectionHeaderView.text = @"sextion";
//return self.sectionHeaderView;

//    UILabel * label = [ UILabel
/*
 Create the section header views lazily.
 
 SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
 if (!sectionInfo.headerView) {
 NSString *playName = sectionInfo.play.name;
 sectionInfo.headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:playName section:section delegate:self];
 }
 
 return sectionInfo.headerView;
 */

//}


//-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {

//SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
//return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
// Alternatively, return rowHeight.
//}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == kSettingsFlightDataSection ) {
        return YES;
    }
    
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"willSelectRowAtIndexPath");
    //return indexPath;
    return nil;
}

// Override to support editing the table view.

/*- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willBeginEditingRowAtIndexPath");
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didEndEditingRowAtIndexPath");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertView clickedButtonAtIndex buttonIndex = %ld", (long)buttonIndex);
    //if (self.connectionAlert == alertView) {
    //    if (buttonIndex == 0) {         // End Connection
    //        if(self.gkSession != nil)	{
    //             [self invalidateSession:self.gkSession];
    //            self.gkSession = nil;
    //        }
    // go back to start mode
    ////        self.gk_State = kStateStartApp;
    //       self.gkPeerId = nil;
    //    }
    //}
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //NSLog(@"textFieldShouldBeginEditing");
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing");
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField==self.textEditField){
        //NSString *string = self.textEditField.text;
        // validate self.textEditField.text
        // look if file exists
        //write to prefs ...
        //[application_Defaults setObject: self.textEditField.text forKey:DEFAULTS_FILE_NAME_ROOT];
        
    } else if (textField==self.pilotEditField) {
        
    } else if (textField==self.planeEditField) {
        
    }
    NSLog(@"textFieldShouldEndEditing");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
     
    if (textField==self.textEditField){
        // set dirty
        self.navigationItem.rightBarButtonItem.enabled = YES;
     
     } else if (textField==self.pilotEditField){
         
         self.navigationItem.rightBarButtonItem.enabled = YES;
         
     } else if (textField==self.planeEditField){
         
        self.navigationItem.rightBarButtonItem.enabled = YES;
     }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"shouldChangeCharactersInRange");
    if (textField==self.textEditField){
        // set dirty
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    } else if (textField==self.pilotEditField){
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    } else if (textField==self.planeEditField){
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [ textField resignFirstResponder ];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //NSLog(@"textFieldShouldClear");
    return YES;
}

#pragma mark - actions

-(IBAction)defaultSettings:(id)sender{ // unused
    
    [self.motionRecorder setToDefaultValues];
    
}


-(IBAction)apply_Action:(id)sender {
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    
    if (bSampleRateHasChanged) {
        
        self.motionRecorder.motionInterval = 1./self.motionIntervalSlider.value;
        [application_Defaults setObject:[NSNumber numberWithFloat:self.motionRecorder.motionInterval] forKey:DEFAULTS_MOTION_DELTA];
        [application_Defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"restartMotionManager_notification" object:nil userInfo:nil];
    }
    
    NSString * oldString = [application_Defaults stringForKey:DEFAULTS_FILE_NAME_ROOT];
    if ( [oldString compare:self.textEditField.text]!= NSOrderedSame ) {
        [application_Defaults setObject: self.textEditField.text forKey:DEFAULTS_FILE_NAME_ROOT];
    }
    
    oldString = [application_Defaults stringForKey:DEFAULTS_PILOT_NAME];
    if ( [oldString compare:self.pilotEditField.text]!= NSOrderedSame ) {
        [application_Defaults setObject: self.pilotEditField.text forKey:DEFAULTS_PILOT_NAME];
    }
    
    oldString = [application_Defaults stringForKey:DEFAULTS_PLANE_NAME];
    if ( [oldString compare:self.planeEditField.text]!= NSOrderedSame ) {
        [application_Defaults setObject: self.planeEditField.text forKey:DEFAULTS_PLANE_NAME];
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rec_set_appl_note" object:nil userInfo:nil];
}

-(IBAction)tipsSwitchSetting:(id)sender {
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:self.uiTipsSwitch.on] forKey:DEFAULTS_TIPS_ON];
	[application_Defaults synchronize];
    
    //if on, show tips
    if(self.uiTipsSwitch.on) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayNextTip_note" object:nil userInfo:nil];
    }
}

#pragma mark motion section

-(IBAction)motionSwitchSetting:(id)sender{
    
    NSLog(@"motionSwitchSetting");
    
    //[self.tableView reloadData];
}


/*-(void) motionIntervaSettingTimerFired:(NSTimer*)timer {
    
    _motionIntervaSettingTimerLive = NO;
    
    if (_motionIntervaSettingNewValuePending) {
        //NSLog(@"motionIntervaSettingTimerFired refire:");
        // refire fadeTimer
        _motionIntervaSettingTimerLive = YES;
        _motionIntervaSettingNewValuePending = NO;
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(motionIntervaSettingTimerFired:) userInfo:nil repeats:NO];
    } else { // update prefs
        //NSLog(@"updating prefs %f",self.motionIntervalSlider.value);
        //[self.motionIntervalSlider resignFirstResponder];
        //_motionIntervalOverLayer.layer.opacity = 0.0;
        bSampleRateHasChanged = YES;
        self.motionRecorder.motionInterval = self.motionIntervalSlider.value;
        NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
        [application_Defaults setObject:[NSNumber numberWithFloat:self.motionRecorder.motionInterval] forKey:DEFAULTS_MOTION_DELTA];
        [application_Defaults synchronize];
        
        NSIndexPath * indexPath = [ NSIndexPath indexPathForRow:1 inSection:kSettingsMotionSection ];
        //UITableViewCell * cell = [ self.tableView cellForRowAtIndexPath:indexPath ];
        NSString * string = NSLocalizedString(@"Freq", @"");
        NSString * displayString = [NSString stringWithFormat:@"%@: %4.2f sec.", string, self.motionRecorder.motionInterval];
        //cell.textLabel.text = displayString;
        //[ cell setNeedsDisplay ];
        //[self.tableView reloadData];
        //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        //}
        
    }
}*/

-(IBAction)motionIntervalSetting:(id)sender {
    
    bSampleRateHasChanged = YES;
    
    NSString * string = NSLocalizedString(@"Freq", @"");
    NSString * displayString = [NSString stringWithFormat:@"%@: %4.2f Hz.", string, self.motionIntervalSlider.value];
    
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:1 inSection:kSettingsMotionSection];
    UITableViewCell * cell = [ self.tableView cellForRowAtIndexPath:indexPath ];
    cell.textLabel.text=displayString;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    //_motionIntervalOverLayer.timeString = displayString;
    //[_motionIntervalOverLayer.layer setNeedsDisplay ];
    //_motionIntervalOverLayer.layer.opacity = 1.0;
    
    /*if(_motionIntervaSettingTimerLive) {
        _motionIntervaSettingNewValuePending = YES;
    } else {
        // fire fadeTimer
        _motionIntervaSettingTimerLive = YES;
        _motionIntervaSettingNewValuePending = NO;
        NSTimer *fadeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(motionIntervaSettingTimerFired:) userInfo:nil repeats:NO];
    }*/
    
    
}


-(IBAction)photoSwitchSetting:(id)sender{
    
    self.motionRecorder.bCameraOn = uiCameraSwitch.on;
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:self.motionRecorder.bCameraOn] forKey:DEFAULTS_CAMERA_ON];
	[application_Defaults synchronize];
    //[self.tableView reloadData];
}


-(IBAction)photoIntervalSetting:(id)sender{
    self.motionRecorder.cameraInterval = self.photoIntervalSlider.value;
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithFloat:self.motionRecorder.cameraInterval] forKey:DEFAULTS_CAMERA_DELTA];
	[application_Defaults synchronize];
    //[self.tableView reloadData];
}


#pragma mark - gps
-(IBAction)gpsSwitchSetting:(id)sender {
    self.motionRecorder.gpsOn = uiGPSSwitch.on;
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:self.motionRecorder.gpsOn] forKey:DEFAULTS_GPS_ON];
	[application_Defaults synchronize];
    //[self.tableView reloadData];
}


-(IBAction)gpsIntervalSetting:(id)sender {
    self.motionRecorder.gpsInterval = self.gpsIntervalSlider.value;
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithFloat:self.motionRecorder.gpsInterval] forKey:DEFAULTS_GPS_DELTA];
	[application_Defaults synchronize];
    //[self.tableView reloadData];
}

#pragma mark - cloud

-(IBAction)cloudSwitchSetting:(id)sender {
    
    // if we save locally this option is not needed
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:self.cloudSwitch.on] forKey:DEFAULTS_CLOUD_ON];
	[application_Defaults synchronize];
    //[self.tableView reloadData];
}

-(IBAction)liveGraphingSwitched:(id)sender {
    //[application_Defaults boolForKey:DEFAULTS_LIVE_GRAPH_ON];
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * switched = [NSNumber numberWithBool:self.liveGraphingSwitch.on];
	[application_Defaults setObject:switched forKey:DEFAULTS_LIVE_GRAPH_ON];
	[application_Defaults synchronize];
    //[self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LiveGraphingSwitched_note" object:switched userInfo:nil];
}

@end
