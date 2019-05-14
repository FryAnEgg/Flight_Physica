//
//  FPh_GraphSettingsViewController.m
//  Flight Physica
//
//  Created by David Lathrop on 1/26/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_GraphSettingsViewController.h"

#import "GraphAttributesTableViewController.h"

#import "GraphLayer.h"

@interface FPh_GraphSettingsViewController ()

@end

@implementation FPh_GraphSettingsViewController

@synthesize graphLayers;

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
    
    self.title = NSLocalizedString(@"Graph Settings", @"");
    
	/*UIBarButtonItem *clearAllButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(cancel_Action:)];
    
	self.navigationItem.leftBarButtonItem = clearAllButton;
    
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"")
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(done_Action:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    */
    
    CGRect rect = CGRectMake(0.,0., 10., 10.);
    
    graphLineView = [[GraphLineAttributeView alloc ]initWithFrame:rect];
    
    NSNotificationCenter * noteCen = [ NSNotificationCenter defaultCenter ];
    
    [ noteCen addObserver:self  selector:@selector(graphAttributeChanged:)name:@"GraphAttributesChangedNote" object:nil];
    
    [ noteCen addObserver:self  selector:@selector(updateLegendSelection:)name:@"update_selectedLayers_note" object:nil];
    
    //self.tableView.separatorStyle = UITableViewStyleGrouped;
    //UITableViewStyleGrouped
    //UITableViewStylePlain
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; //(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowGraphLegendTable"]) {
        
    } else if ([segue.identifier isEqualToString:@"OpenGraphAttributesTable"]) {
    
        // set color slider
        GraphAttributesTableViewController *gaController = (GraphAttributesTableViewController *) segue.destinationViewController;
        
        gaController.graphLayer = selectedGraphLayer;
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kGraph_Last;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kGraphSize:
            return 1;
            break;
        case kGraphLines:
            return (1 + self.graphLayers.count);
            break;
        case kFetchSettings:
            return 1;
            break;
            
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSUInteger lastCellIndex = self.graphLayers.count;
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * width = [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_WIDTH];
    NSNumber *  height= [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_HEIGHT];
    
    switch (indexPath.section) {
        case kGraphSize:
            
            cell.textLabel.text = NSLocalizedString(@"Graph Size", @"");
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld x %ld", (long)[width integerValue], (long)[height integerValue]];
            //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            break;
        case kGraphLines:
            
            if (indexPath.row == lastCellIndex) {
                cell.textLabel.text = NSLocalizedString(@"Edit List", @"");
                cell.textLabel.textColor = [ UIColor redColor];
                cell.detailTextLabel.text = NSLocalizedString(@"", @"");
                //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            } else {
                
                GraphLayer * pgl = [self.graphLayers objectAtIndex:indexPath.row ];
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"GraphLayerCell"];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GraphLayerCell"];
                    
                    cell.textLabel.textColor = [ UIColor blackColor]; // pgl.lineColor; //
                    
                    // can I make a UIImage like that...
                    
                    graphLineView.lineColor = pgl.lineColor;
                    graphLineView.lineWidth = pgl.lineWidth;
                    [graphLineView setNeedsDisplay];
                    //cell.accessoryView = graphLineView;
                    
                    
                }
                //cell.textLabel.text=[NSString stringWithFormat:@"R:%4.4f",self.r_slider.value];
                //cell.textLabel.textColor=[UIColor redColor];
                //cell.accessoryView = self.r_slider;
                //cell.imageView.image = [UIImage imageNamed:@"fs_clock"];
                //break;
                
                // this should be its own cell, but one for all lines in common
                //pgl.lineColor
                //pgl.legendValue;
                
                cell.textLabel.text = pgl.longString;
                cell.detailTextLabel.textColor = pgl.lineColor;
                cell.detailTextLabel.text = NSLocalizedString(@"-----", @"");
                
            }
            break;
            
        case kFetchSettings:
            if (indexPath.row == 0) {
                int graphFetchLimit = [[[ NSUserDefaults standardUserDefaults ] objectForKey:DEFAULTS_FETCH_PAGE_SIZE ] intValue ];
                NSString * tString = NSLocalizedString (@"Fetch Size",@"");
                cell.textLabel.textColor = [ UIColor blackColor];
                cell.textLabel.text = [ NSString stringWithFormat:@"%@ : %d", tString, graphFetchLimit ];
                //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                //} else {
                //    cell.textLabel.text = NSLocalizedString (@"Show Degrees",@"");
                //    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            }
            break;
    }
    
    //cell.imageView.image = [UIImage imageNamed:@"Icon"];
    
    return cell;
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    NSArray * array = [ NSArray arrayWithObjects:@"Size", @"Visible", nil ];
//    return array;
//}

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
/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 NSLog(@"didSelectRowAtIndexPath");
 }
 */

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int lastCellIndex = self.graphLayers.count;
    
    switch (indexPath.section) {
            
        case kGraphSize:
            
            [self openGraphSizeActionSheet];
            
            break;
            
        case kGraphLines:
            
            if (indexPath.row == lastCellIndex) {
                
                [ self performSegueWithIdentifier:@"ShowGraphLegendTable" sender:self ];
                
            } else {
                
                selectedGraphLayer = [self.graphLayers objectAtIndex:indexPath.row ];
                
                [ self performSegueWithIdentifier:@"OpenGraphAttributesTable" sender:self ];
                
                //if(!self.graphAttributesTableViewController) {
                //    self.graphAttributesTableViewController = [[GraphAttributesTableViewController alloc] initWithNibName:@"GraphAttributesTableViewController" bundle:nil];
                //}
                
                //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.graphAttributesTableViewController];
                
                //[self presentViewController:navigationController animated:YES completion: nil];
                
                // set color slider
                //GraphLayer * pgl = [self.graphLayers objectAtIndex:indexPath.row ];
                
                //self.graphAttributesTableViewController.graphLayer = pgl;
                
            }
            break;
        case kFetchSettings:
            NSLog(@"accessoryButtonTappedForRowWithIndexPath : kFetchSettings");
            if (indexPath.row == 0) {  // fetch size
                // bring up size options???
                [self openFetchSizeActionSheet];
            } else if (indexPath.row == 1) {
                // degrees for now
            }
            
            break;
    };
    
}

#pragma mark - UIActionSheet

-(void) openGraphSizeActionSheet {
    
    graphSizeActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Select Size", @"") delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle: nil
                                             otherButtonTitles:NSLocalizedString(@"800 x 1200", @""),
                            NSLocalizedString(@"1200 x 800", @""),
                            NSLocalizedString(@"1200 x 1800", @""),
                            NSLocalizedString(@"1800 x 1200", @""),nil];
    [graphSizeActionSheet showInView:self.tableView];
    
}

-(void) openFetchSizeActionSheet {
    
    //int graphFetchLimit = [[[ NSUserDefaults standardUserDefaults ] objectForKey:DEFAULTS_FETCH_PAGE_SIZE ] intValue ];
    
    fetchSizeActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Select Fetch Size", @"") delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle: nil
                                             otherButtonTitles:NSLocalizedString(@"1000 points", @""),
                            NSLocalizedString(@"2000 points", @""),
                            NSLocalizedString(@"4000 points", @""),
                            NSLocalizedString(@"8000 points", @""),nil];
    [fetchSizeActionSheet showInView:self.tableView];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet==graphSizeActionSheet){
        
        NSNumber * objectNumber = [ NSNumber numberWithLong:buttonIndex];
        
        NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
        //NSNumber * oldWidth = [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_WIDTH];
        //NSNumber * oldHeight= [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_HEIGHT];
        
        NSNumber * newWidth;
        NSNumber * newHeight;
        
        switch (buttonIndex) {
            case k800x1200:
                newWidth = [NSNumber numberWithFloat:800.0];
                newHeight = [NSNumber numberWithFloat:1200.0];
                break;
            case k1200x800:
                newWidth = [NSNumber numberWithFloat:1200.0];
                newHeight = [NSNumber numberWithFloat:800.0];
                break;
            case k1200x1800:
                newWidth = [NSNumber numberWithFloat:1200.0];
                newHeight = [NSNumber numberWithFloat:1800.0];
                break;
            case k1800x1200:
                newWidth = [NSNumber numberWithFloat:1800.0];
                newHeight = [NSNumber numberWithFloat:1200.0];
                break;
                
            default:
                break;
        }
        
        if (newWidth && newHeight){
            [application_Defaults setObject:newWidth forKey:DEFAULTS_GRAPH_SIZE_WIDTH];
            [application_Defaults setObject:newHeight forKey:DEFAULTS_GRAPH_SIZE_HEIGHT];
            [application_Defaults synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"change_graph_size_note" object:objectNumber userInfo:nil];
            
            NSIndexPath * indexPath = [ NSIndexPath indexPathForRow:0 inSection:kGraphSize];
            UITableViewCell * cell = [ self.tableView cellForRowAtIndexPath:indexPath ];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld x %ld", (long)[newWidth integerValue], (long)[newHeight integerValue]];
            [ cell setNeedsDisplay ];
        }
    }
    else if (actionSheet==fetchSizeActionSheet){
        NSNumber * newSize; // = [ NSNumber numberWithInt:100];
        BOOL isChangedValue = NO;
        switch (buttonIndex) {
            case 0:
                newSize = [ NSNumber numberWithInt:1000];
                isChangedValue = YES;
                break;
            case 1:
                newSize = [ NSNumber numberWithInt:2000];
                isChangedValue = YES;
                break;
            case 2:
                newSize = [ NSNumber numberWithInt:4000];
                isChangedValue = YES;
                break;
            case 3:
                newSize = [ NSNumber numberWithInt:8000];
                isChangedValue = YES;
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"change_graph_size_note" object:objectNumber userInfo:nil];
                break;
            default:
                //newSize = [ NSNumber numberWithInt:123];
                break;
        }
        if(isChangedValue) {
            
            [[NSUserDefaults standardUserDefaults] setObject:newSize forKey:DEFAULTS_FETCH_PAGE_SIZE];
            NSIndexPath * indexPath = [ NSIndexPath indexPathForRow:0 inSection:kFetchSettings];
            UITableViewCell * cell = [ self.tableView cellForRowAtIndexPath:indexPath ];
            NSString * tString = NSLocalizedString (@"Fetch Size",@"");
            cell.textLabel.text = [ NSString stringWithFormat:@"%@ : %d", tString, [newSize intValue]];
            //int graphFetchLimit = [[[ NSUserDefaults standardUserDefaults ] objectForKey:DEFAULTS_FETCH_PAGE_SIZE ] intValue ];
            [ cell setNeedsDisplay ];
            
        }
    }
}

#pragma mark - actions

-(void) graphAttributeChanged:(NSNotification*) notif {
    
    [self.tableView reloadData];
    
    //selectedGraphLayer;
    // we need to redraw the color in the cell
    //the cell we sent it off on ...
    
}

-(void) updateLegendSelection :(NSNotification*) notif {
    [self.tableView reloadData];
}

-(IBAction)done_Action:(id)sender {
    //dismiss this view...
    [ self dismissViewControllerAnimated:YES completion:nil ];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss_legend_notification" object:nil userInfo:nil];
}

-(IBAction)cancel_Action:(id)sender {
    //dismiss this view...
    [ self dismissViewControllerAnimated:YES completion:nil ];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss_legend_notification" object:nil userInfo:nil];
}

@end
