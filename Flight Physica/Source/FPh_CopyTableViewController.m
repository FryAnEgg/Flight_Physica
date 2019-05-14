//
//  FPh_CopyTableViewController.m
//  Flight Physica
//
//  Created by David Lathrop on 2/1/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_CopyTableViewController.h"

@interface FPh_CopyTableViewController ()

@end

@implementation FPh_CopyTableViewController

@synthesize source_fmd, sourceURL;
@synthesize nameString, destStart;
@synthesize destEnd;

@synthesize fileNameCell, pilotCell;
@synthesize planeCell, dateCell;
@synthesize durationCell, exportSwitchCell;

@synthesize nameField, exportRAWswitch;
@synthesize writeButton;


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
    
    NSURL *newURL = [ self.sourceURL URLByAppendingPathComponent:self.nameString ];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[newURL path]]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }

    
    //NSDateFormatterMediumStyle
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    dateString = [dateFormatter stringFromDate:self.source_fmd.date];
    
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

#pragma mark - actions

-(IBAction) writeToFile :(id)sender {
    
    if(exportRAWswitch.on == NO) {
        NSLog(@"exportRAWswitch.state == NO");
    }
    // include this in dict as userInfo tbi
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"do_copy_notification" object:self.nameField.text userInfo:nil];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"reload_ tableview_notification" object:nil userInfo:nil];
    
    //close this
    [self.navigationController popViewControllerAnimated:YES ];
    
}

-(IBAction) exportSwitched :(id)sender {
    
    NSLog(@"exportSwitched");
    //exportRAWswitch setOn ==
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = self.fileNameCell;
            self.nameField.text = self.nameString;
            //cell.detailTextLabel.text
            break;
        case 1:
            cell = self.pilotCell;
            cell.detailTextLabel.text = self.source_fmd.pilot;
            break;
        case 2:
            cell = self.planeCell;
            cell.detailTextLabel.text = self.source_fmd.plane;
            break;
        case 3:
            cell = self.dateCell;
            cell.detailTextLabel.text = dateString; //[self.source_fmd.date description];
            break;
        case 4:
            cell = self.durationCell;
            //float duration = [self.source_fmd.stopTime floatValue]-[self.source_fmd.startTime floatValue];
            float newDuration = [self.destEnd floatValue] - [self.destStart floatValue] ;
            cell.detailTextLabel.text =  [NSString stringWithFormat:@"%4.2f seconds", newDuration];
            break;
        case 5:
            cell = self.exportSwitchCell;
            [self.exportRAWswitch setOn:NO];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

/*#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
}*/

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //NSLog(@"textFieldShouldBeginEditing");
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //NSLog(@"textFieldDidBeginEditing");
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    /*if (textField==self.textEditField){
        NSString *string = self.textEditField.text;
        // validate self.textEditField.text
        // look if file exists
        //write to prefs ...
        //[application_Defaults setObject: self.textEditField.text forKey:DEFAULTS_FILE_NAME_ROOT];
        
    } else if (textField==self.pilotEditField) {
        
    } else if (textField==self.planeEditField) {
        
    }*/
    //NSLog(@"textFieldShouldEndEditing");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    /*NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    
    if (textField==self.textEditField){
        // set dirty
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    } else if (textField==self.pilotEditField){
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    } else if (textField==self.planeEditField){
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }*/
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * tString = textField.text;
    
    self.nameString = [ tString stringByReplacingCharactersInRange:range withString:string];
    
    NSURL *newURL = [ self.sourceURL URLByAppendingPathComponent:self.nameString ];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[newURL path]]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
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

@end
