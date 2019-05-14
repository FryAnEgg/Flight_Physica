//
//  FPh_CopyTableViewController.h
//  Flight Physica
//
//  Created by David Lathrop on 2/1/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MetaData.h"

@interface FPh_CopyTableViewController : UITableViewController <UITextFieldDelegate> {
    
    MetaData * source_fmd;
    NSURL *sourceURL;
    NSNumber *destStart;
    NSNumber *destEnd;
    NSString *nameString;
    NSString * dateString;
    
    
    UIBarButtonItem *writeButton;
    UITextField * nameField;
    
    
    UITableViewCell * fileNameCell;
    UITableViewCell * pilotCell;
    UITableViewCell * planeCell;
    UITableViewCell * dateCell;
    UITableViewCell * durationCell;
    
}

-(IBAction) writeToFile :(id)sender;

@property (nonatomic,retain) MetaData * source_fmd;
@property (nonatomic,retain) NSURL *sourceURL;
@property (nonatomic,retain) NSNumber *destStart;
@property (nonatomic,retain) NSNumber *destEnd;
@property (nonatomic,retain) NSString *nameString;

@property (nonatomic,retain) IBOutlet UIBarButtonItem *writeButton;
@property (nonatomic,retain) IBOutlet UITextField * nameField;
@property (nonatomic,retain) IBOutlet UISwitch * exportRAWswitch;

@property (nonatomic,retain) IBOutlet UITableViewCell * fileNameCell;
@property (nonatomic,retain) IBOutlet UITableViewCell * pilotCell;
@property (nonatomic,retain) IBOutlet UITableViewCell * planeCell;
@property (nonatomic,retain) IBOutlet UITableViewCell * dateCell;
@property (nonatomic,retain) IBOutlet UITableViewCell * durationCell;
@property (nonatomic,retain) IBOutlet UITableViewCell * exportSwitchCell;

@end
