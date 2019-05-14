//
//  GraphAttributesTableViewController.m
//  Flight Physica
//
//  Created by David Lathrop on 1/26/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "GraphAttributesTableViewController.h"

enum GraphAttributeSections
{
	kColorAttribute = 0,
    //kLineStyle,
    kAnnotations,
    kGraphAttribute_Last
};

@interface GraphAttributesTableViewController ()

@end

@implementation GraphAttributesTableViewController

@synthesize r_slider, g_slider, b_slider, a_slider, graphLineView;//annoLabelView,
@synthesize graphLayer = _graphLayer;

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

-(void) setGraphLayer:(GraphLayer *)graphLayer {
    
    NSUInteger oldAnnoCount = 0;
    BOOL firstLoad = NO;
    if (self.graphLayer) {
        oldAnnoCount = self.graphLayer.subAnnotations.count;
        firstLoad = YES;
    }
    
    _graphLayer = graphLayer;
    
    CGFloat r,g,b,a;
    BOOL gotit = [self.graphLayer.lineColor getRed:&r green:&g blue:&b alpha:&a];
    
    [self.r_slider setValue: r ];
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:0 inSection:kColorAttribute];
    UITableViewCell * cell = [ self.tableView cellForRowAtIndexPath:indexPath ];
    cell.textLabel.text=[NSString stringWithFormat:@"R:%4.4f",r];
    
    [self.g_slider setValue: g ];
    indexPath = [ NSIndexPath indexPathForRow:1 inSection:kColorAttribute];
    cell = [ self.tableView cellForRowAtIndexPath:indexPath ];
    cell.textLabel.text=[NSString stringWithFormat:@"G:%4.4f",g];
    
    [self.b_slider setValue: b ];
    indexPath = [ NSIndexPath indexPathForRow:2 inSection:kColorAttribute];
    cell = [ self.tableView cellForRowAtIndexPath:indexPath ];
    cell.textLabel.text=[NSString stringWithFormat:@"B:%4.4f",b];
    
    [self.a_slider setValue: a ];
    indexPath = [ NSIndexPath indexPathForRow:3 inSection:kColorAttribute];
    cell = [ self.tableView cellForRowAtIndexPath:indexPath ];
    cell.textLabel.text=[NSString stringWithFormat:@"A:%4.4f",a];
    
    self.graphLineView.lineColor = self.graphLayer.lineColor;
    self.graphLineView.lineWidth = self.graphLayer.lineWidth;
    // can dashed lines be implemented?
    [self.graphLineView setNeedsDisplay];
    
    self.title = graphLayer.longString;
    
    // TextAnnotationLayer * tLayer
    sortedMarkers = [graphLayer.subAnnotations sortedArrayUsingComparator: ^(TextAnnotationLayer* obj1, TextAnnotationLayer* obj2) {
        if (obj1.timeStamp > obj2.timeStamp) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (obj1.timeStamp < obj2.timeStamp) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [self.tableView reloadData];
    /*
     if(!firstLoad){
     if (oldAnnoCount > self.graphLayer.subAnnotations.count) {
     // remove extra rows
     NSUInteger remCount = oldAnnoCount-self.graphLayer.subAnnotations.count;
     NSMutableArray * array = [ NSMutableArray arrayWithCapacity:remCount];
     for (int i=0; i<remCount; i++) {
     [array addObject:[NSIndexPath indexPathForRow:oldAnnoCount-i-1 inSection:kAnnotations]];
     }
     [self.tableView beginUpdates];
     //[tv insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
     [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
     [self.tableView endUpdates];
     } else if (oldAnnoCount < self.graphLayer.subAnnotations.count){
     NSUInteger addCount = self.graphLayer.subAnnotations.count-oldAnnoCount;
     NSMutableArray * array = [ NSMutableArray arrayWithCapacity:addCount];
     for (int i=0; i<addCount; i++) {
     [array addObject:[NSIndexPath indexPathForRow:oldAnnoCount+i inSection:kAnnotations]];
     }
     [self.tableView beginUpdates];
     [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
     [self.tableView endUpdates];
     }
     }
     
     NSIndexSet * sections = [ NSIndexSet indexSetWithIndex:kLineStyle];
     [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
     
     sections = [ NSIndexSet indexSetWithIndex:kAnnotations];
     [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kGraphAttribute_Last;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kColorAttribute:
            return 4;
            break;
            //case kLineStyle:
            //    return 1;
            //    break;
        case kAnnotations:
            //NSLog(@"kAnnotations = %d",self.graphLayer.subAnnotations.count);
            return self.graphLayer.subAnnotations.count;
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //kColorAttribute = 0,
    //kGraphAttribute_Last
    
    //static NSString *CellIdentifier = @"GraphAttributeCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
    //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //}
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case kColorAttribute:
            
            switch (indexPath.row) {
                case 0: //red
                    cell = [tableView dequeueReusableCellWithIdentifier:@"RedColorAttributeCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RedColorAttributeCell"];
                    }
                    cell.textLabel.text=[NSString stringWithFormat:@"R : %4.4f",self.r_slider.value];
                    cell.textLabel.textColor=[UIColor redColor];
                    cell.accessoryView = self.r_slider;
                    //cell.imageView.image = [UIImage imageNamed:@"fs_clock"];
                    break;
                case 1: //green
                    cell = [tableView dequeueReusableCellWithIdentifier:@"GreenColorAttributeCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GreenColorAttributeCell"];
                        
                    }
                    cell.textLabel.text=[NSString stringWithFormat:@"G : %4.4f",self.g_slider.value];
                    cell.textLabel.textColor=[UIColor greenColor];
                    cell.accessoryView = self.g_slider;
                    //cell.imageView.image = [UIImage imageNamed:@"fs_clock"];
                    break;
                case 2: //blue
                    cell = [tableView dequeueReusableCellWithIdentifier:@"BlueColorAttributeCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BlueColorAttributeCell"];
                    }
                    cell.textLabel.text=[NSString stringWithFormat:@"B : %4.4f",self.b_slider.value];
                    cell.accessoryView = self.b_slider;
                    cell.textLabel.textColor=[UIColor blueColor];
                    //cell.imageView.image = [UIImage imageNamed:@"fs_clock"];
                    break;
                case 3: //alpha
                    cell = [tableView dequeueReusableCellWithIdentifier:@"AlphaColorAttributeCell"];
                    if (cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlphaColorAttributeCell"];
                    }
                    cell.textLabel.text=[NSString stringWithFormat:@"A : %4.4f",self.a_slider.value];
                    cell.accessoryView = self.a_slider;
                    cell.textLabel.textColor=[UIColor blackColor];
                    //cell.imageView.image = [UIImage imageNamed:@"fs_clock"];
                    break;
            };
            
            break;
            
            /*case kLineStyle:
             cell = [tableView dequeueReusableCellWithIdentifier:@"LineStyleCell"];
             if (cell == nil)
             {
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LineStyleCell"];
             }
             cell.textLabel.text = NSLocalizedString(@"Style:", @"");
             cell.imageView.image = [UIImage imageNamed:@"fs_clock"];
             break;*/
        case kAnnotations:
            cell = [tableView dequeueReusableCellWithIdentifier:@"AnnotationCell"];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AnnotationCell"];
                
                //cell.accessoryView = self.annoLabelView;
            }
            
            TextAnnotationLayer * tLayer = [sortedMarkers objectAtIndex:indexPath.row];
            
            // wont be a motionvalue for loaded data...
            //FPh_GraphData * data = tLayer.motionValue;
           
            NSTimeInterval time =  tLayer.timeStamp;//data.timestamp;
            
            NSNumber * startTime = self.graphLayer.graphMinTime;
            
            NSNumber *delta = [NSNumber numberWithDouble: (time-[startTime doubleValue])];
            
            //NSLog(@"tLayer.valueString = %@",tLayer.valueString);
            //NSLog(@"tLayer.annotationString = %@",tLayer.annotationString);
            
            // if (tLayer.titleString) {
            // cell.textLabel.text = tLayer.titleString;
    
                
            //cell.textLabel.text = [NSString stringWithFormat:@"%@ #%d", NSLocalizedString(@"Point", @""), indexPath.row+1];
            cell.textLabel.text = [NSString stringWithFormat:@"%6.3f%@", tLayer.yValue, [self.graphLayer unitString] ];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%6.3f secs.", [ delta floatValue]];
            //}
            
            cell.imageView.image = [UIImage imageNamed:@"fs_pin"];
            
            //self.annoLabelView.text = @"woo";
            
            break;
            
    }
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }
 


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
    // Navigation logic may go here. Create and push another view controller.
    //UIAlertView
    //UIA
    //if(indexPath.section == kLineStyle){
    //    [self openLineStyleActionSheet];
    //}
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //if(section == kColorAttribute){
    //    return self.graphLineView; // can we use the default and make this a subview???
    //}
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == kColorAttribute){
        return 44.0;
    }
    return 32.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kColorAttribute:
            return NSLocalizedString(@"Color (rgba)", @"");
            break;
            //case kLineStyle:
            //    return NSLocalizedString(@"Line Style", @"");
            //break;
        case kAnnotations:
            return NSLocalizedString(@"Markers", @"");
            break;
    }
    return @"";
}

#pragma mark - actions

-(IBAction)apply_Action:(id)sender {
    
    if (bDirtyColor) {
        
        bDirtyColor = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        UIColor * newColor = [ UIColor colorWithRed:self.r_slider.value green:self.g_slider.value blue:self.b_slider.value alpha:self.a_slider.value];
        
        self.graphLayer.lineColor = newColor;
        
        [self.graphLayer.layer setNeedsDisplay];
        
        // can we update the cell for this in the settings table
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GraphAttributesChangedNote" object:nil userInfo:nil];
        
    }
}

-(IBAction)sliderDidSlide:(id)sender {
    
    NSInteger index = 0;
    NSString * string;
    float newValue = 0.;
    
    if ( sender == self.r_slider ) {
        index = 0;
        string = @"R";
        newValue = self.r_slider.value;
    } else if ( sender == self.g_slider ) {
        string = @"G";
        index = 1;
        newValue = self.g_slider.value;
    } else if ( sender == self.b_slider ) {
        string = @"B";
        index = 2;
        newValue = self.b_slider.value;
    } else if ( sender == self.a_slider ) {
        string = @"A";
        index = 3;
        newValue = self.a_slider.value;
    }
    
    // update the color display
    UIColor * newColor = [ UIColor colorWithRed:self.r_slider.value green:self.g_slider.value blue:self.b_slider.value alpha:self.a_slider.value];
    self.graphLineView.lineColor = newColor;
    [self.graphLineView setNeedsDisplay];
    
    NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:index inSection:kColorAttribute];
    UITableViewCell * cell = [ self.tableView cellForRowAtIndexPath:indexPath ];
    cell.textLabel.text=[NSString stringWithFormat:@"%@:%4.4f",string, newValue];
    
    bDirtyColor = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

-(IBAction)lineSizeStepped:(id)sender {
    NSLog(@"lineSizeStepped");
}

#pragma mark - UIActionSheet

/*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
 [self.navigationController pushViewController:self.drafts_Controller animated:YES];
 //[self presentModalViewController: mediaUI animated: YES];
 }
 else {
 self.drafts_Popup_VC = [[UIPopoverController alloc] initWithContentViewController:self.drafts_Controller];
 self.drafts_Popup_VC.popoverContentSize = CGSizeMake(320., 700.);
 self.drafts_Popup_VC.delegate = self;
 
 [self.drafts_Popup_VC presentPopoverFromRect:CGRectMake(572.0,29.0,145.0,145.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
 }*/

/*-(void) openLineStyleActionSheet {
 
 UIActionSheet *lineStyleActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Line Style", @"") delegate:self
 cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle: nil
 otherButtonTitles:NSLocalizedString(@"Solid", @""),
 NSLocalizedString(@"Dash (4,4)", @""),
 NSLocalizedString(@"Dash (4,2)", @""),
 NSLocalizedString(@"Dash (2,4)", @""),nil];
 
 [lineStyleActionSheet showInView:self.tableView];
 
 }
 */

-(void) openFetchSizeActionSheet {
    
    /*    //int graphFetchLimit = [[[ NSUserDefaults standardUserDefaults ] objectForKey:DEFAULTS_FETCH_PAGE_SIZE ] intValue ];
     
     fetchSizeActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Select Fetch Size", @"") delegate:self
     cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle: nil
     otherButtonTitles:NSLocalizedString(@"100 points", @""),
     NSLocalizedString(@"500 points", @""),
     NSLocalizedString(@"1000 points", @""),
     NSLocalizedString(@"2000 points", @""),nil];
     [fetchSizeActionSheet showInView:self.tableView];
     */
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    /* if (actionSheet==graphSizeActionSheet){
     
     NSNumber * objectNumber = [ NSNumber numberWithInt:buttonIndex ];;
     switch (buttonIndex) {
     case k800x1200:
     case k1200x800:
     case k1200x1800:
     case k1800x1200:
     [[NSNotificationCenter defaultCenter] postNotificationName:@"change_graph_size_note" object:objectNumber userInfo:nil];
     break;
     
     default:
     break;
     }
     }
     else if (actionSheet==fetchSizeActionSheet){
     NSNumber * newSize; // = [ NSNumber numberWithInt:100];
     switch (buttonIndex) {
     case 0:
     NSLog(@"actionSheet==fetchSizeActionSheet 0");
     newSize = [ NSNumber numberWithInt:100];
     
     break;
     case 1:
     newSize = [ NSNumber numberWithInt:500];
     NSLog(@"actionSheet==fetchSizeActionSheet 1");
     break;
     case 2:
     newSize = [ NSNumber numberWithInt:1000];
     NSLog(@"actionSheet==fetchSizeActionSheet 2");
     break;
     case 3:
     newSize = [ NSNumber numberWithInt:2000];
     NSLog(@"actionSheet==fetchSizeActionSheet 3");
     //[[NSNotificationCenter defaultCenter] postNotificationName:@"change_graph_size_note" object:objectNumber userInfo:nil];
     break;
     default:
     newSize = [ NSNumber numberWithInt:123];
     break;
     }
     [[NSUserDefaults standardUserDefaults] setObject:newSize forKey:DEFAULTS_FETCH_PAGE_SIZE];
     NSIndexPath * indexPath = [ NSIndexPath indexPathForRow:0 inSection:kFetchSettings];
     UITableViewCell * cell = [ self.tableView cellForRowAtIndexPath:indexPath ];
     NSString * tString = NSLocalizedString (@"Fetch Size",@"");
     cell.textLabel.text = [ NSString stringWithFormat:@"%@ : %d", tString, [newSize integerValue]];
     [ cell setNeedsDisplay ];
     }
     */
}


@end
