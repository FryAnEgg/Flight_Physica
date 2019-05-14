//
//  FPh_GraphLegendViewController.m
//  Flight Physica
//
//  Created by David Lathrop on 1/26/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_GraphLegendViewController.h"

//#import "FR_AppDelegate.h"
#import "LegendTableViewCell.h"

@interface FPh_GraphLegendViewController ()

@end

@implementation FPh_GraphLegendViewController

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

-(IBAction)clearAll_Action:(id)sender {
    
    NSLog(@"clearAll_Action");
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    
    // clear all of the
    BOOL isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_X];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_ACC_X]; }
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_Y];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_ACC_Y]; }
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_Z];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_ACC_Z]; }
    
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ATT_ROLL];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_ATT_ROLL]; }
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ATT_PITCH];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_ATT_PITCH]; }
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ATT_YAW];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_ATT_YAW]; }
    
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ROT_X];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_ROT_X]; }
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ROT_Y];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_ROT_Y]; }
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ROT_Z];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_ROT_Z]; }
    
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_GRAV_X];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_GRAV_X]; }
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_GRAV_Y];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_GRAV_Y]; }
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_GRAV_Z];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_GRAV_Z]; }
    
    isOn = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_HEADING];
    if (isOn) { [application_Defaults setObject:[NSNumber numberWithBool:NO] forKey:DEFAULTS_LEGEND_SHOW_HEADING]; }//
    
    [application_Defaults synchronize];
    
    [ self.tableView reloadData ];
    
}


-(IBAction)toggleShow_Accell_X:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_ACC_X];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Accell_Y:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_ACC_Y];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Accell_Z:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_ACC_Z];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Attitude_Roll:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_ATT_ROLL];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Attitude_Pitch:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_ATT_PITCH];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Attitude_Yaw:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_ATT_YAW];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Rotation_X:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_ROT_X];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Rotation_Y:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_ROT_Y];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Rotation_Z:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_ROT_Z];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Heading:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_HEADING];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Gravity_X:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_GRAV_X];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Gravity_Y:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_GRAV_Y];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(IBAction)toggleShow_Gravity_Z:(id)sender {
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithBool:[sender isOn]] forKey:DEFAULTS_LEGEND_SHOW_GRAV_Z];
	[application_Defaults synchronize];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(IBAction)apply_Action:(id)sender {
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_selectedLayers_note" object:nil userInfo:nil];
   
    //close this
    [self.navigationController popViewControllerAnimated:YES ];
}



#pragma mark - UITableView datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LegendTableViewCell *cell = nil;
    //UISwitch * uiswitch;
    NSUserDefaults	*application_Defaults;
    application_Defaults = [NSUserDefaults standardUserDefaults];
    
    switch (indexPath.row)
    {
        case kLegend_Accel_x:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Accel_x"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Accel_x"];
                cell.textLabel.text = NSLocalizedString(@"Acceleration x", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Acceleration x", @"")];
                
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Accell_X:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_X];
            break;
            
        case kLegend_Accel_y:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Accel_y"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Accel_y"];
                cell.textLabel.text = NSLocalizedString(@"Acceleration y", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Acceleration y", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Accell_Y:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_Y];
            break;
            
        case kLegend_Accel_z:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Accel_z"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Accel_z"];
                cell.textLabel.text = NSLocalizedString(@"Acceleration z", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Acceleration z", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Accell_Z:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_Z];
            break;
            
        case kLegend_Attitude_Roll:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Attitude_Roll"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Attitude_Roll"];
                cell.textLabel.text = NSLocalizedString(@"Attitude Roll", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Attitude Roll", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Attitude_Roll:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ATT_ROLL];
            break;
        case kLegend_Attitude_Pitch:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Attitude_Pitch"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Attitude_Pitch"];
                cell.textLabel.text = NSLocalizedString(@"Attitude Pitch", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Attitude Pitch", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Attitude_Pitch:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ATT_PITCH];
            break;
            
        case kLegend_Attitude_Yaw:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Attitude_Yaw"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Attitude_Yaw"];
                cell.textLabel.text = NSLocalizedString(@"Attitude Yaw", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Attitude Yaw", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Attitude_Yaw:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ATT_YAW];
            break;
            
        case kLegend_Rotation_x:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Rotation_x"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Rotation_x"];
                cell.textLabel.text = NSLocalizedString(@"Rotation X", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Rotation X", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Rotation_X:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ROT_X];
            break;
            
        case kLegend_Rotation_y:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Rotation_y"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Rotation_y"];
                cell.textLabel.text = NSLocalizedString(@"Rotation Y", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Rotation Y", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Rotation_Y:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ROT_Y];
            break;
            
        case kLegend_Rotation_z:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Rotation_z"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Rotation_z"];
                cell.textLabel.text = NSLocalizedString(@"Rotation Z", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Rotation Z", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Rotation_Z:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ROT_Z];
            break;
            
        case kLegend_Heading:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Heading"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Heading"];
                cell.textLabel.text = NSLocalizedString(@"Heading", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Heading", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Heading:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_HEADING];
            break;
            
        case kLegend_Gravity_x:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Gravity_x"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Gravity_x"];
                cell.textLabel.text = NSLocalizedString(@"Gravity X", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Gravity X", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Gravity_X:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_GRAV_X];
            break;
            
        case kLegend_Gravity_y:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Gravity_y"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Gravity_y"];
                cell.textLabel.text = NSLocalizedString(@"Gravity Y", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Gravity Y", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Gravity_Y:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_GRAV_Y];
            break;
            
        case kLegend_Gravity_z:
            cell = [tableView dequeueReusableCellWithIdentifier:@"kLegend_Gravity_z"];
            if (cell == nil)
            {
                cell = [[LegendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kLegend_Gravity_z"];
                cell.textLabel.text = NSLocalizedString(@"Gravity Z", @"");
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(197, 8, 94, 27)];
                }
                else {
                    cell.uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(567, 8, 94, 27)];
                }
                [cell.uiswitch setAccessibilityLabel:NSLocalizedString(@"Gravity Z", @"")];
                [cell.uiswitch addTarget:self action:@selector(toggleShow_Gravity_Z:) forControlEvents:UIControlEventValueChanged];
                cell.uiswitch.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cell.uiswitch];
            }
            cell.uiswitch.on = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_GRAV_Z];
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kLegend_Last;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"willSelectRowAtIndexPath");
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // show line editor: color, width
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willDeselectRowAtIndexPath");
    return nil;
}


@end
