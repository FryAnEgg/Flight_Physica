
//
//  FPh_GraphViewController.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#include <AudioToolbox/AudioToolbox.h>

#import "FPh_GraphViewController.h"
#import "FPh_AppDelegate.h"
#import "MetaData.h"
#import "FPh_GraphData.h"
#import "DeviceMotionObject.h"
#import "FPh_GraphSettingsViewController.h"
#import "FPh_CopyTableViewController.h"
#import "GraphAttributesTableViewController.h"
#import "GraphMarkerObject.h"

@interface FPh_GraphViewController ()

@end

@implementation FPh_GraphViewController

@synthesize graphScrollView, tapRecognizer, swipeLeftRecognizer;

@synthesize fetchedResultsController, flightGraphDocument, copiedDoc, graphTitleView, toolbar;
@synthesize spaceLeftItem, spaceRightItem, cropLeftBarButton, cropRightBarButton, resetCropBarButton, cropBothBarButton;
@synthesize copDocBarButton, stopFetchBarButton, deselectLayerBarButton, layerToolsBarButton, cameraBarButton, markerBarButton;
@synthesize pageUpButton, pageDownButton, graphStartTime, graphStopTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (fmd) { // sets the graph limits
        //NSLog(@"name:%@",fmd.pilot);
        //NSLog(@"plane:%@",fmd.plane);
        //NSLog(@"start %4.2f",[fmd.startTime floatValue]) ;
        //NSLog(@"stop %4.2f",[fmd.stopTime floatValue]) ;
        //NSLog(@"date:%@",[fmd.date description]);
        
        self.graphStartTime = [fmd.startTime doubleValue];
        self.graphStopTime = [fmd.stopTime doubleValue];
        
        // elsewhere
        self.graphScrollView.graphView.graphMinTime =  [NSNumber numberWithDouble:self.graphStartTime];
        //self.graphScrollView.graphView.startTime;
        self.graphScrollView.graphView.graphMaxTime = [NSNumber numberWithDouble:self.graphStopTime];
        //self.graphScrollView.graphView.stopTime;
        
        // can we test change fmd.pilot here
    }
    
    NSNotificationCenter * noteCen = [ NSNotificationCenter defaultCenter ];
    
    [ noteCen addObserver:self  selector:@selector(updateLegendSelection:)name:@"update_selectedLayers_note" object:nil];
    
    [ noteCen addObserver:self  selector:@selector(closeTools:)name:@"dismiss_tools_notification" object:nil];
    [ noteCen addObserver:self  selector:@selector(doCopy:)name:@"do_copy_notification" object:nil];
    
    [ noteCen addObserver:self  selector:@selector(scaleLayerNote:)name:@"layer_tool_scale_note" object:nil];
    [ noteCen addObserver:self  selector:@selector(moveLayerNote:)name:@"layer_tool_move_note" object:nil];
    [ noteCen addObserver:self  selector:@selector(reorderLayerNote:)name:@"layer_tool_reorder_note" object:nil];
    [ noteCen addObserver:self  selector:@selector(normalizeLayerNote:)name:@"layer_tool_normalize_note" object:nil];
    
    [ noteCen addObserver:self  selector:@selector(shouldUpdateBarButtonsNote:)name:@"update_graph_bar_buttons_notification"object:nil];
    
    [ noteCen addObserver:self  selector:@selector(changeGraphSizeNote:)name:@"change_graph_size_note" object:nil];
    
    [ noteCen addObserver:self  selector:@selector(addGraphMarkerToDocument:)name:@"add_graph_marker" object:nil];
    
    [ noteCen addObserver:self  selector:@selector(stopFetchNote:)name:@"stopFetchNotification" object:nil];
    
    [ self showToolbarView ];
    
    // Custom initialization
    CGRect titleRect = CGRectMake(0.0, 0.0, 200.0, 40.0);
    self.graphTitleView = [ [ GraphTitleView alloc ] initWithFrame:titleRect ];
    self.graphTitleView.graphTitleString = self.flightGraphDocument.localizedName;
    self.graphTitleView.loadEndTime= 0.0;
    self.graphTitleView.loadStartTime= 0.0;
    self.graphTitleView.self.alpha = 1.0;
    self.graphTitleView.bWaitingForStop = NO;
    self.graphTitleView.docStartTime = self.graphStartTime;
    self.graphTitleView.docEndTime = self.graphStopTime;
    
    // set page size and frequency and pps
    self.graphTitleView.pageSize = [[[ NSUserDefaults standardUserDefaults ] objectForKey:DEFAULTS_FETCH_PAGE_SIZE ] doubleValue ];
    self.graphTitleView.pointsPerSecond = [fmd.motionInterval doubleValue];
    
    //[self.graphTitleView setNeedsDisplay];
    
    self.navigationItem.titleView = self.graphTitleView;
    
    [ self fetchMetaDataForGraph];
    
    [ self setUpDataFetch ];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateFileListFired:(NSTimer*)timer {
    NSLog(@"updateFileListFired");
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"reload_ tableview_notification" object:nil userInfo:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"OpenGraphSettings"]) {
        
        FPh_GraphSettingsViewController * settingsController = (FPh_GraphSettingsViewController *)segue.destinationViewController;
        //destination.topViewController;
        
        // set the current line info into self.graphSettingsViewController
        settingsController.graphLayers = self.graphScrollView.graphView.partialGraphLayers;
        
    } else if ([segue.identifier isEqualToString:@"OpenGraphAttributesTable"]) {
        
        // set color slider
        GraphAttributesTableViewController *gaController = (GraphAttributesTableViewController *) segue.destinationViewController;
        
        gaController.graphLayer = self.graphScrollView.graphView.selectedGraphLayer;
        
    }
    else if ([segue.identifier isEqualToString:@"OpenCopySettings"]) {
        
        FPh_CopyTableViewController * copyController = (FPh_CopyTableViewController *)segue.destinationViewController;
       
        FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSURL* loc = [appDelegate expLocalURL];
        
        //NSString * filename = self.flightGraphDocument.localizedName;
        
        NSString *newFileName = [ NSString stringWithFormat:@"%@_c",self.flightGraphDocument.localizedName];
        
        NSURL *newURL = [ loc URLByAppendingPathComponent:newFileName ];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[newURL path]]) {
            NSLog(@"fileExistsAtPath");
        }

        // we need metadata for old file ...
        MetaData * tfmd = [ self.flightGraphDocument fetchMetaData];
        
        copyController.source_fmd = tfmd;
        copyController.sourceURL = loc;
        copyController.destStart = self.graphScrollView.graphView.graphMinTime;
        copyController.destEnd = self.graphScrollView.graphView.graphMaxTime;
        
        copyController.nameString = newFileName;
        
        // on a timer please
        //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateFileListFired:) userInfo:nil repeats:NO];
        
        //NSLog(@"...OpenCopySettings....");
        //NSLog(@"**** metadata *****");
        //NSLog(@"name:%@",tfmd.pilot);
        //NSLog(@"plane:%@",tfmd.plane);
        //NSLog(@"start %4.2f",[tfmd.startTime floatValue]);
        //NSLog(@"stop %4.2f",[tfmd.stopTime floatValue]);
        //NSLog(@"date:%@",[tfmd.date description]);
        //NSLog(@"stop %4.2f",[tfmd.motionInterval floatValue]);
        //NSLog(@"*******************");
    }
}



#pragma mark - fetch

-(BOOL) fetchMotionDataWithStart:(NSNumber*)startTime stop:(NSNumber*)stopTime {
    
    FPh_AppDelegate* appDel = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    int graphFetchLimit = [[[ NSUserDefaults standardUserDefaults ] objectForKey:DEFAULTS_FETCH_PAGE_SIZE ] intValue ];
    
    //NSNumber * startT = [NSNumber numberWithDouble:self.graphStartTime ];
    //NSNumber * stopT = [NSNumber numberWithDouble:self.graphStopTime ];
    
    //double recordingLength = self.graphStopTime - self.graphStartTime;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp>=%@ AND timestamp<=%@", startTime, stopTime];
    
    NSFetchRequest* motionRequest =  [NSFetchRequest fetchRequestWithEntityName:@"Motion"];
    
    NSSortDescriptor *timeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:timeDescriptor, nil];
    
    [motionRequest setSortDescriptors:sortDescriptors];
    
    if ( self.flightGraphDocument ) {
        
        // Create and initialize the fetch results controller.
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:motionRequest
                                                                                                    managedObjectContext:self.flightGraphDocument.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        self.fetchedResultsController = aFetchedResultsController;
        
        [ self.fetchedResultsController.fetchRequest setPredicate:predicate];
        [self.fetchedResultsController.fetchRequest setFetchOffset:graphFetchOffset];
        [self.fetchedResultsController.fetchRequest setFetchLimit:graphFetchLimit];
        
        
        waitingOnFetch = YES;
        [self showToolbarView];
        
        [ self.graphTitleView.activityIndicator startAnimating ];
        
        NSError *error;
        
        if (![self.fetchedResultsController performFetch:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            waitingOnFetch = NO;
            
            errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unresolved Error", @"") message:NSLocalizedString(@"Unresolved Error while loading data", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [ errorAlert show];
            
            return NO;
            //exit(-1);  // Fail
            
        } else { //no error
            //NSLog(@"success fetch %d", self.fetchedResultsController.fetchedObjects.count);
            waitingOnFetch = NO;
        }
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        //Dont sort for now
        //appDel.flightData.motionData = [self.fetchedResultsController.fetchedObjects sortedArrayUsingSelector:@selector(timestampCompare:)];
        
        appDel.flightData.motionData = [ NSArray arrayWithArray: self.fetchedResultsController.fetchedObjects ];
        
        [ appDel.flightData filterData : YES compression:1 ];
        
        if(appDel.flightData.filteredData.count > 0){
            
            FPh_GraphData * lastOne = [appDel.flightData.filteredData objectAtIndex:appDel.flightData.filteredData.count -1 ];
            
            [ self.graphScrollView.graphView setGraphLimits:startTime max:[NSNumber numberWithDouble: lastOne.timestamp ] ];
            self.graphScrollView.graphView.startTime = startTime;
            self.graphScrollView.graphView.stopTime = [NSNumber numberWithDouble: lastOne.timestamp ];
            
            self.graphTitleView.loadStartTime = [startTime doubleValue];
            self.graphTitleView.loadEndTime = lastOne.timestamp;
            
            [self.graphTitleView setNeedsDisplay];
            
            
            // set sublayer size
        } else {
            
            //NSLog(@"no fetched data, put up alert and then close");
            errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Data", @"") message:NSLocalizedString(@"File Contains No Data", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [ errorAlert show];
            
            return NO;
            
        }
        
        appDel.flightData.motionData = [ NSArray array ];
        
        if (self.fetchedResultsController.fetchedObjects.count < graphFetchLimit || isDataFetchComplete) {
            
            isDataFetchComplete = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            NSArray * markerArray = [self.flightGraphDocument fetchGraphMarkerPoints];
            
            [ self addGraphMarkersFromDBArray:markerArray ];
            
            self.graphTitleView.fullyLoaded = YES;
            self.graphTitleView.bWaitingForStop = NO;
            [ self.graphTitleView.activityIndicator stopAnimating ];
            
            [self.graphTitleView setNeedsDisplay];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_graph_bar_buttons_notification" object:nil userInfo:nil];
            
            NSArray * locationArray = [self.flightGraphDocument fetchLocations];
            NSLog(@"locationArray count = %lu", locationArray.count);
            
            NSArray * altitudeArray = [self.flightGraphDocument fetchAltitudes];
            NSLog(@"altitudeArray count = %lu", altitudeArray.count);
            
        } else { // still more
            
            graphFetchOffset += graphFetchLimit;
            self.graphTitleView.fullyLoaded = NO;
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(fetchNextMotionBlock) userInfo:nil repeats:NO];
        
        }
        
        
        //appDel.flightData.filteredData = [appDel.flightData.motionData arrayByAddingObjectsFromArray: [ self.fetchedResultsController.fetchedObjects sortedArrayUsingSelector:@selector(timestampCompare:)]];
        
        // just once for now
        
        [ self refreshGraph ];
        
        
    } else {
        NSLog(@"NO FLIGHT DOCUMENT");
    }
    
    return YES;
}

-(void) fetchMotionData {
    
    [ self.graphScrollView.graphView setGraphLimits:self.graphScrollView.graphView.startTime max:self.graphScrollView.graphView.stopTime ];
    
    self.graphTitleView.docStartTime = self.graphStartTime;
    self.graphTitleView.docEndTime = self.graphStopTime;
    self.graphScrollView.graphView.startTime = [NSNumber numberWithDouble:self.graphStartTime];
    self.graphScrollView.graphView.stopTime = [NSNumber numberWithDouble:self.graphStopTime];
    
    [ self fetchMotionDataWithStart:[NSNumber numberWithDouble:self.graphStartTime] stop:[NSNumber numberWithDouble:self.graphStopTime]];
    
}


-(void) fetchNextMotionBlock {
    [ self fetchMotionDataWithStart:[NSNumber numberWithDouble:self.graphStartTime] stop:[NSNumber numberWithDouble:self.graphStopTime]];
}

-(void) setUpDataFetch { 
    
    isDataFetchComplete = NO;
    
    graphFetchOffset = 0;
    
    //graphFetchLimit = 2000;// use preference
    
    //can we optimize this as to size
    graphFetchOffsetStart = 0; // at some point we can set this to last one loaded ...
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelegate.flightData.motionData = [ NSArray array ];
    appDelegate.flightData.filteredData = [ NSArray array ];
    
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(fetchMotionData) userInfo:nil repeats:NO];
    
    NSURL * url = self.flightGraphDocument.fileURL;
    NSString * fName = [url lastPathComponent];
    self.navigationItem.title = fName;
    
}

-(IBAction) stopFetchAction:(id) sender {
    
    if (self.graphTitleView.bWaitingForStop || self.graphTitleView.fullyLoaded) {
        return;
    }
    isDataFetchComplete = YES;
    self.graphTitleView.bWaitingForStop = YES;
    [self.graphTitleView setNeedsDisplay];
}

-(void) stopFetchNote:(NSNotification*) notif {
    
    isDataFetchComplete = YES;
    //self.graphTitleView.bWaitingForStop = NO;
}



-(void) refreshGraph {
    
    //self.graphScrollView.contentSize = self.graphScrollView.graphView.frame.size;
    [self.graphScrollView setMaxMinZoomScalesForCurrentBounds];
    
    FPh_AppDelegate* appDel = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDel.motionRecorder) {
        
        //self.graphScrollView.graphView.startTime = [NSNumber numberWithDouble:self.graphStartTime ];
        //self.graphScrollView.graphView.stopTime = [NSNumber numberWithDouble:self.graphStopTime ];
        
        //self.graphScrollView.graphView.graphMinTime = [NSNumber numberWithDouble:self.graphStartTime ];
        //self.graphScrollView.graphView.graphMaxTime = [NSNumber numberWithDouble:self.graphStopTime ];
        
        self.graphTitleView.docStartTime = self.graphStartTime;
        self.graphTitleView.docEndTime = self.graphStopTime;
        
        [self.graphScrollView.graphView redrawGraph];
        
    }
}

#pragma mark - toolbar

-(void) showToolbarView {
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    
    [itemsArray insertObject:self.spaceRightItem atIndex:0];
    
    //[itemsArray insertObject:self.showLegendBarButton atIndex:0];
    
    if (waitingOnFetch) {
        [itemsArray insertObject:self.stopFetchBarButton atIndex:0];
    } else {
        [itemsArray insertObject:self.copDocBarButton atIndex:0];
        
        [itemsArray insertObject:self.cameraBarButton atIndex:0];
        
        if (self.graphScrollView.graphView.selectedGraphLayer) {
            //[itemsArray insertObject:self.deselectLayerBarButton atIndex:0]; // keep in for now
            [itemsArray insertObject:self.layerToolsBarButton atIndex:0];
        }
        
        //NSLog(@"graphMinTime %4.2f", [self.graphScrollView.graphView.graphMinTime floatValue]);
        //NSLog(@"graphMaxTime %4.2f", [self.graphScrollView.graphView.graphMaxTime floatValue]);
        //NSLog(@"startTime %4.2f", [self.graphScrollView.graphView.startTime floatValue]);
        //NSLog(@"stopTime %4.2f", [self.graphScrollView.graphView.stopTime floatValue]);
        
        BOOL leftIsCropped = self.graphScrollView.graphView.graphMinTime && [self.graphScrollView.graphView.graphMinTime doubleValue] != self.graphStartTime;
        
        BOOL rightIsCropped = self.graphScrollView.graphView.graphMaxTime && [self.graphScrollView.graphView.graphMaxTime doubleValue] != self.graphStopTime;
        
        if(isDataFetchComplete){
            if(leftIsCropped || rightIsCropped){
                [itemsArray insertObject:self.resetCropBarButton atIndex:0];
            }
        
        
            if(self.graphScrollView.graphView.cropLeftGrayView) {
                [itemsArray insertObject:self.cropBothBarButton atIndex:0];
                [itemsArray insertObject:self.cropRightBarButton atIndex:0]; // for now
                [itemsArray insertObject:self.cropLeftBarButton atIndex:0];
            } else if ( self.graphScrollView.graphView.cursorIsShowing ) {
                // if cursor is down
                [itemsArray insertObject:self.markerBarButton atIndex:0];
            }
        }
    }
    
    //if ( !isDataFetchComplete) {
    //    [itemsArray insertObject:self.pageUpButton atIndex:0];
        //}
        //if(  ){
        //[itemsArray insertObject:self.pageDownButton atIndex:0];
    //}
    
    [itemsArray insertObject:self.spaceLeftItem atIndex:0];
    
    [self.toolbar setItems:itemsArray animated:YES];
    
    
}

-(void) shouldUpdateBarButtonsNote:(NSNotification*) notif {
    
    [ self showToolbarView ];
}

//From MultiDetailsView project
/* - (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
 
 // Add the popover button to the toolbar.
 NSMutableArray *itemsArray = [toolbar.items mutableCopy];
 [itemsArray insertObject:barButtonItem atIndex:0];
 [toolbar setItems:itemsArray animated:NO];
 [itemsArray release];
 }
 
 
 - (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
 
 // Remove the popover button from the toolbar.
 NSMutableArray *itemsArray = [toolbar.items mutableCopy];
 [itemsArray removeObject:barButtonItem];
 [toolbar setItems:itemsArray animated:NO];
 [itemsArray release];
 }
 */

#pragma mark - copying documents

-(void)fetchMetaDataForGraph {
    
    fmd = [ self.flightGraphDocument fetchMetaData ];
    
    if (fmd) { // sets the graph limits
        
        self.graphStartTime = [fmd.startTime doubleValue];
        self.graphStopTime = [fmd.stopTime doubleValue];
        
    }
    else {
        NSLog(@"No Metadata");
        // have demonstrated that this works
        //[ self saveContext : doc ];
        return;
    }
}

///////////////////////////
-(void) addMetaDataToCopy {
    
    //get meta data from active doc
    MetaData * fmdCopy = [ self.flightGraphDocument fetchMetaData ];
    
    if (self.copiedDoc.managedObjectContext != nil) {
        
        // add and set metadata object
        NSManagedObjectContext *addingContext = self.copiedDoc.managedObjectContext;
        
        [addingContext performBlockAndWait:^() {
            
            NSUserDefaults	*application_Defaults = [NSUserDefaults standardUserDefaults];
            
            MetaData * fmd2 = (MetaData *)[NSEntityDescription insertNewObjectForEntityForName:@"MetaData" inManagedObjectContext:addingContext];
            
            
            fmd2.stopTime = [NSNumber numberWithDouble:lastCopyTime];//[self.graphScrollView.graphView.graphMaxTime doubleValue]];
            fmd2.startTime = [NSNumber numberWithDouble:firstCopyTime];//[self.graphScrollView.graphView.graphMinTime doubleValue]];
            // this should match the data ...
            
            
            fmd2.pilot = fmdCopy.pilot;//pilotString;
            fmd2.plane = fmdCopy.plane;//planeString;
            
            fmd2.date = fmdCopy.date;// [ NSDate date ];
            
            fmd2.motionInterval = [NSNumber numberWithDouble:[fmdCopy.motionInterval doubleValue]];
            
            fmd2.gpsInterval = [NSNumber numberWithDouble:[fmdCopy.gpsInterval doubleValue]];
            fmd2.pictureInterval = [NSNumber numberWithDouble:[fmdCopy.pictureInterval doubleValue]];
            
            // create display string here
            FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            
            // use date from metadata
            [ appDelegate.fileData setObject:[NSString stringWithFormat:@"%@ %6.2f sec.", [dateFormatter stringFromDate:fmd2.date], [fmd2.stopTime floatValue]-[fmd2.startTime floatValue]] forKey:self.copiedDoc.localizedName ];
            
            [[ NSUserDefaults standardUserDefaults ] setObject:appDelegate.fileData forKey:DEFAULTS_FILES_DICT ];
            [[ NSUserDefaults standardUserDefaults ] synchronize ];
            
            
        }];
        
    }
    //NSLog(@"leaving addMetaDataToCopy");
}

//////////////////////////////////////////////////////////
-(void) addDataMotionPointToCopy:(FPh_GraphData*) dataPoint {
    
    NSManagedObjectContext *addingContext = self.copiedDoc.managedObjectContext;
    
    //[ addingContext setPersistentStoreCoordinator:[[self.appDelegate.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
    [addingContext performBlockAndWait:^() {
        
        DeviceMotionObject * zzd = (DeviceMotionObject *)[NSEntityDescription insertNewObjectForEntityForName:@"Motion" inManagedObjectContext:addingContext];
        //CMDeviceMotion
        //zzd.
        // convert to ZZDeviceMotion
        //ZZDeviceMotion * zzd = [[ ZZDeviceMotion alloc ] init];
        zzd.timestamp = [NSNumber numberWithDouble: dataPoint.timestamp];
        zzd.attRoll = [NSNumber numberWithDouble: dataPoint.attRoll];
        zzd.attPitch = [NSNumber numberWithDouble: dataPoint.attPitch];
        zzd.attYaw = [NSNumber numberWithDouble: dataPoint.attYaw];
        zzd.accx= [NSNumber numberWithDouble: dataPoint.accx];
        zzd.accy= [NSNumber numberWithDouble: dataPoint.accy];
        zzd.accz= [NSNumber numberWithDouble: dataPoint.accz];
        zzd.rotx= [NSNumber numberWithDouble: dataPoint.rotx];
        zzd.roty= [NSNumber numberWithDouble: dataPoint.roty];
        zzd.rotz= [NSNumber numberWithDouble: dataPoint.rotz];
        zzd.gravx= [NSNumber numberWithDouble: dataPoint.gravx];
        zzd.gravy= [NSNumber numberWithDouble: dataPoint.gravy];
        zzd.gravz= [NSNumber numberWithDouble: dataPoint.gravz];
        
        
    }];
    
    //self.motionEndTime = dataPoint.timestamp;
    //if (self.motionStartTime==0.0) {
    //    self.motionStartTime = dataPoint.timestamp;
    //    NSLog(@"self.motionStartTime set");
    //}
    //self.pointCount++;
}

///////////////////////////
-(void) addFlightDataToCopy {
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    for (int j=0; j<[appDelegate.flightData.filteredData count]; j++) {
        
        FPh_GraphData * motionPoint = [appDelegate.flightData.filteredData objectAtIndex:j];
        
        [ self addDataMotionPointToCopy:motionPoint ];
        
        if(j==0){
            firstCopyTime = motionPoint.timestamp;
        }
        lastCopyTime = motionPoint.timestamp;
        
        // how to add it on ...
        //save in metadata
    }
}

-(void) doCopy:(NSNotification*) notif {
    
    NSString * newFileName = (NSString *) notif.object;
    
    if (newFileName.length < 1) return;//sanity
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSURL* loc = [appDelegate expLocalURL];
    
    NSURL *newURL;
    
    NSDictionary *options;
            
    newURL = [ loc URLByAppendingPathComponent:newFileName ];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[newURL path]]) {
        NSLog(@"fileExistsAtPath");
    }
    
    options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES],
                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                       NSInferMappingModelAutomaticallyOption, nil];
    
    // Now Create our document
    self.copiedDoc =  [[FlightManagedDocument alloc] initWithFileURL:newURL];
    
    
    if (self.copiedDoc == nil) {
        NSLog(@"document == nil");
        return;
    }
    
    //self.copiedDoc.undoManager = nil;
    self.copiedDoc.persistentStoreOptions = options;
    
    // save document
    [ self.copiedDoc  saveToURL:newURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        
        if (success == NO) {
            // error handling here
            NSLog(@"removeItemAtURL here");
            // delete any partially saved data
            [[NSFileManager defaultManager] removeItemAtURL:newURL error:nil];
            // and just exit
            return;
        }
        else {
            //write data
            [ self addFlightDataToCopy ];
            // write new metadata
            [ self addMetaDataToCopy ];
            
            // save document
            FPh_AppDelegate *appDel = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
            
            [ appDel saveContext: self.copiedDoc ];
            
            // use notification?
            //[ appDel.flightDocsController listLocalFiles];
            
        }
        // set as graph subject
        //self.graphingController.flightGraphDocument = self.activeFlightDocument;
        //from FR_AppDelegate createManagedDocument
    }];
    
}

#pragma mark GraphMarker to document
-(void) addGraphMarkerToDocument :(NSNotification*) notif {
    
    TextAnnotationLayer * anno = (TextAnnotationLayer *) notif.object;
    
    if (self.flightGraphDocument.managedObjectContext != nil) {
        
        // add and set metadata object
        NSManagedObjectContext *addingContext = self.flightGraphDocument.managedObjectContext;
        
        [addingContext performBlockAndWait:^() {
            
            //NSUserDefaults	*application_Defaults = [NSUserDefaults standardUserDefaults];
            //NSString * pilotString = [application_Defaults stringForKey:DEFAULTS_PILOT_NAME];
            //NSString * planeString = [application_Defaults stringForKey:DEFAULTS_PLANE_NAME];
            
            GraphMarkerObject * obj = (GraphMarkerObject *)[NSEntityDescription insertNewObjectForEntityForName:@"GraphMarker" inManagedObjectContext:addingContext];
            //NSLog(@"addGraphMarkerToDocument anno.annotationString %@",anno.annotationString);
            // where can we get these
            obj.annotation = anno.annotationString;
            obj.datatype = [NSNumber numberWithInt:anno.annotationType];
            obj.markDate = [NSDate date]; // where does this come from?
            obj.style = [NSNumber numberWithInt:0]; // line style? position
            obj.value = [NSNumber numberWithDouble:anno.yValue];
            obj.timestamp = [NSNumber numberWithDouble:anno.motionValue.timestamp];
                          
            /* 
             @property(nonatomic, strong)NSString * annotation;
             @property(nonatomic, strong)NSNumber * datatype;
             @property(nonatomic, strong)NSDate * markDate;
             @property(nonatomic, strong)NSNumber * style;
             @property(nonatomic, strong)NSNumber * value;
             @property(nonatomic, strong) NSNumber * timestamp;
             
            obj.stopTime = [NSNumber numberWithDouble:self.motionEndTime];
            obj.startTime = [NSNumber numberWithDouble:self.motionStartTime];
            obj.pilot = pilotString;
            obj.plane = planeString;
            obj.date = [ NSDate date ];
            obj.motionInterval = [NSNumber numberWithDouble:self.motionInterval];
            obj.gpsInterval = [NSNumber numberWithDouble:self.gpsInterval];
            obj.pictureInterval = [NSNumber numberWithDouble:self.cameraInterval];
            obj.location = @"locationDescription";
             */
            
        }];
        
        // save document
        FPh_AppDelegate *appDel = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
        [ appDel saveContext: self.flightGraphDocument ];
        
    }
}

-(void) addGraphMarkersFromDBArray:(NSArray*)array {
    
    for (int i=0; i<self.graphScrollView.graphView.partialGraphLayers.count; i++) {
        
        //NSLog(@"found partialGraphLayer for addGraphMarkersFromDBArray");
        
        //    GraphLayer * pgl = [self.partialGraphLayers objectAtIndex: i];
        //    [ pgl addAnnotationAt:self.annotationLayer.layer.position.x  motion:self.annotationLayer.motionValue ];
        
    }
    
    GraphMarkerObject * gmo;
    
    for (int j=0; j<[array count]; j++) {
        
        gmo = (GraphMarkerObject *)[array objectAtIndex:j];

        //NSLog(@"addGraphMarkersFromDBArray - %@", gmo.annotation);
        //gmo.annotation;
        //gmo.datatype;
        //gmo.markDate;
        //gmo.style;
        //gmo.value;
        //gmo.timestamp;
        
        for( int i = 0; i<self.graphScrollView.graphView.partialGraphLayers.count; i++) {
            GraphLayer * gl = [ self.graphScrollView.graphView.partialGraphLayers objectAtIndex:i ];
            if (gl.typeIndex == [gmo.datatype intValue]) {
                // this is the gl
                // create a TextAnnotationLayer
                TextAnnotationLayer * newAnno = [[TextAnnotationLayer alloc] initWithType:gmo.datatype showIndicator:NO offset:CGPointMake(0., -64.)];
                
                //xPointValue is gmo.timestamp convrted to x on graph
                float scalex = gl.layer.bounds.size.width/([gl.graphMaxTime floatValue]-[gl.graphMinTime floatValue]);
                
                
                CGFloat xPointValue = ([gmo.timestamp doubleValue] - [gl.graphMinTime doubleValue]) * scalex;
                CGFloat yValue = [gmo.value floatValue];
                newAnno.layer.position = CGPointMake(xPointValue, yValue * gl.scaley + gl.zeroPointY);
                newAnno.color = gl.lineColor;
                
                // units from type???
                
                newAnno.valueString = [NSString stringWithFormat:@"%6.3f", yValue];
                newAnno.annotationString = @""; //self.annoString;
                //newAnno.motionValue = motion;
                newAnno.timeStamp = (NSTimeInterval)[gmo.timestamp doubleValue];
                newAnno.yValue = yValue;
                
                [gl.subAnnotations addObject:newAnno];
                [ gl.layer addSublayer : newAnno.layer ];
                [ newAnno.layer setNeedsDisplay ];

            }
        }
        //typeIndex
                
        // from GraphLayer 2
        
    }
}


#pragma mark - actions and notifications

-(IBAction)closeGraph:(id)sender {
    
    closeAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Close Graph", @"") message:NSLocalizedString(@"You will lose graph attributes", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Close Graph", @""),nil];
    [ closeAlert show];
    
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == errorAlert) {
        
        [self.graphScrollView.graphView removePartialGraphLayers];
        
        [ self dismissViewControllerAnimated:YES completion:nil ];
        
    } else if (alertView == closeAlert) {
        if (buttonIndex == 0) {         // End Connection
            // do nothing
        } else {
            // close and scrub graph controller
            
            [self.graphScrollView.graphView removePartialGraphLayers];
            
            [ self dismissViewControllerAnimated:YES completion:nil ];
        }
    }
}


-(void) updateLegendSelection:(NSNotification*) notif {
    
    // this wipes out annotations
    
    [self.graphScrollView.graphView hideCursor];
    
    [self.graphScrollView.graphView setUpVisibleLines];
    
    // se need to update self.graphSettingsViewController
    // set the current line info into self.graphSettingsViewController
    //self.graphSettingsViewController.graphLayers = self.graphScrollView.graphView.partialGraphLayers;
    //[self.graphSettingsViewController.tableView reloadData];
    
    [self.graphScrollView.graphView redrawGraph];
    
    [self.graphScrollView.graphView setNeedsDisplay];
     
}

-(IBAction) takePicture:(id)sender {
    
    UIImage * image2 =[self.graphScrollView.graphView takeScreenshot: self.graphScrollView.graphView];
    
    UIImageWriteToSavedPhotosAlbum ( image2, nil, nil, nil  );
    
    // make shutter sound
    // play start sound
    SystemSoundID	soundFileObject;
    NSBundle * mainbundel = [NSBundle mainBundle];
    NSURL *startSound   = [ mainbundel URLForResource: @"CloseShutter" withExtension: @"snd" ];//
    AudioServicesCreateSystemSoundID ( (__bridge_retained CFURLRef) startSound, &soundFileObject );
    AudioServicesPlayAlertSound (soundFileObject);
}


-(IBAction)cropLeftTool:(id)sender {
    
    NSTimeInterval time  = [ self.graphScrollView.graphView timeAtPoint:self.graphScrollView.graphView.touchPoint_L ];
    NSTimeInterval timeValue_R  = [self.graphScrollView.graphView.graphMaxTime doubleValue];
    //NSTimeInterval time = self.graphScrollView.graphView.timeAtCursor;
    
    self.graphStartTime = time;
    
    // eliminate data to the left of NSTimeInterval time
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    [ appDelegate.flightData removeDataBeforeTime : time   aftertime:timeValue_R ];
    
    NSTimeInterval minT = [appDelegate.flightData firstTime];
    NSTimeInterval maxT = [appDelegate.flightData lastTime];
    
    [ self.graphScrollView.graphView setGraphLimits:[NSNumber numberWithDouble:minT] max:[NSNumber numberWithDouble:maxT] ];
    
    [self.graphScrollView.graphView redrawGraph];
    
    [self.graphScrollView.graphView calculateLayerTime:YES];
    
    [self.graphScrollView.graphView removeCropViews];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_graph_bar_buttons_notification" object:nil userInfo:nil];
}

-(void) cropLeft:(NSNotification*) notif {
    [ self cropLeftTool:nil ];
}

-(IBAction)cropRightTool:(id)sender {
    
    NSTimeInterval time  = [ self.graphScrollView.graphView timeAtPoint:self.graphScrollView.graphView.touchPoint_R ];
    
    self.graphStopTime = time;
    
    
    // eliminate data to the left of NSTimeInterval time
    NSTimeInterval timeValue_L  = [self.graphScrollView.graphView.graphMinTime doubleValue];
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    [ appDelegate.flightData removeDataBeforeTime : timeValue_L   aftertime:time ];
    
    NSTimeInterval minT = [appDelegate.flightData firstTime];
    NSTimeInterval maxT = [appDelegate.flightData lastTime];
    
    [ self.graphScrollView.graphView setGraphLimits:[NSNumber numberWithDouble:minT] max:[NSNumber numberWithDouble:maxT] ];
    
    [self.graphScrollView.graphView redrawGraph];
    
    [self.graphScrollView.graphView calculateLayerTime:YES];
    
    [self.graphScrollView.graphView removeCropViews];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_graph_bar_buttons_notification" object:nil userInfo:nil];
}

-(void) cropRight:(NSNotification*) notif {
    
    [ self cropRightTool:nil ];
    
}

-(IBAction)resetTimeScaleTool:(id)sender{
    
    // what it do here
    //self.graphScrollView.graphView.stopTime = [ NSNumber numberWithDouble: [self.graphScrollView.graphView.startTime doubleValue] +1200.0 ];
    
    //self.graphScrollView.graphView.graphMinTime = self.graphScrollView.graphView.startTime;
    //self.graphScrollView.graphView.graphMaxTime = self.graphScrollView.graphView.stopTime;
    
    [ self.graphScrollView.graphView setGraphLimits:[NSNumber numberWithDouble:self.graphStartTime] max:[NSNumber numberWithDouble:self.graphStopTime] ];
    
    graphFetchOffset = 0;
    
    FPh_AppDelegate* appDel = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDel.flightData.filteredData = [ NSArray  array ];
    
    isDataFetchComplete = NO;
    // we should fetch of entire range
    
    BOOL success = [ self fetchMotionDataWithStart:self.graphScrollView.graphView.graphMinTime stop:self.graphScrollView.graphView.graphMaxTime];
    
    // optimize for data already kept...
    if (success){
        
        [self.graphScrollView.graphView redrawGraph];
        
        [self.graphScrollView.graphView calculateLayerTime:YES];
        
        [self.graphScrollView.graphView removeCropViews];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_graph_bar_buttons_notification" object:nil userInfo:nil];
    }
    
}

-(void) resetTimeScaleNote  {
    [ self resetTimeScaleTool:nil ];
}

-(IBAction)cropTool:(id)sender {
    
    NSTimeInterval timeValue_L  = [ self.graphScrollView.graphView timeAtPoint:self.graphScrollView.graphView.touchPoint_L ];
    NSTimeInterval timeValue_R  = [ self.graphScrollView.graphView timeAtPoint:self.graphScrollView.graphView.touchPoint_R ];
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    [ appDelegate.flightData removeDataBeforeTime : timeValue_L   aftertime:timeValue_R ];
    
    NSTimeInterval minT = [appDelegate.flightData firstTime];
    NSTimeInterval maxT = [appDelegate.flightData lastTime];
    
    [ self.graphScrollView.graphView setGraphLimits:[ NSNumber numberWithDouble:minT ] max:[ NSNumber numberWithDouble:maxT ]];
    
    [self.graphScrollView.graphView redrawGraph];
    
    //if cursor is showing
    // or should we remove cursor
    [self.graphScrollView.graphView calculateLayerTime:YES];
    
    [self.graphScrollView.graphView removeCropViews];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_graph_bar_buttons_notification" object:nil userInfo:nil];
    
}

-(IBAction)pageDownTool:(id)sender {
    
    NSLog(@"pageDownTool");
    
}

-(IBAction)pageUpTool:(id)sender{
    
    NSLog(@"pageUpTool");
    
    [self.graphScrollView.graphView cursorToNextPoint];
    
    
    
    //we want to go to the next highest  point
    
    /*[ self.graphScrollView.graphView setGraphLimits:[NSNumber numberWithDouble:self.graphStartTime] max:[NSNumber numberWithDouble:self.graphStopTime] ];
    
    int graphFetchLimit = [[[ NSUserDefaults standardUserDefaults ] objectForKey:DEFAULTS_FETCH_PAGE_SIZE ] intValue ];
    
    graphFetchOffset += graphFetchLimit;
    
    // we should fetch of entire range
    [ self fetchMotionDataWithStart:self.graphScrollView.graphView.graphMinTime stop:self.graphScrollView.graphView.graphMaxTime];
    // optimize for data already kept...
    
    [self.graphScrollView.graphView redrawGraph];
    
    [self.graphScrollView.graphView calculateLayerTime:YES];
    
    [self.graphScrollView.graphView removeCropViews];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_graph_bar_buttons_notification" object:nil userInfo:nil];
     */
}

-(IBAction)openLayerTools:(id)sender {
    /*
    //bring up GraphAttributesTableViewController instead
    if(!self.graphAttributesTableViewController) {
        self.graphAttributesTableViewController = [[GraphAttributesTableViewController alloc] initWithNibName:@"GraphAttributesTableViewController" bundle:nil];
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.graphAttributesTableViewController];
    
    [self presentViewController:navigationController animated:YES completion: nil];
    
    // set color slider
    GraphLayer * pgl = self.graphScrollView.graphView.selectedGraphLayer;
    
    self.graphAttributesTableViewController.graphLayer = pgl;
    
     */
    
}

-(void) closeTools:(NSNotification*) notif {
    
    // do we have to ? I guess no
    
    //[self.graphScrollView.graphView setUpVisibleLines];
    
    //[self.graphScrollView.graphView redrawGraph];
    
    //[self.graphScrollView.graphView setNeedsDisplay];
}


-(void) scaleLayerNote :(NSNotification*) notif {
    
    NSNumber * scale = notif.object;
    
    NSLog(@"scaleLayerNote %4.2f", [ scale floatValue ]);
    
    if ( self.graphScrollView.graphView.selectedGraphLayer ) {
        
        GraphLayer * pgl = self.graphScrollView.graphView.selectedGraphLayer;
        
        //pgl.scaley = pgl.scaley*[ scale floatValue ]/100.0;
        
        CALayer * theLayer = pgl.layer;
        // change the layer size to match...
        
        theLayer.bounds = CGRectMake(0.0, 0.0,theLayer.bounds.size.width, theLayer.bounds.size.height*[ scale floatValue ]/100.0);
        
        [pgl autoScaleData];
        [pgl resetSubAnnotationPositions];
        [pgl.layer setNeedsDisplay];
        
        //CGRectMake(0.0, 0.0, self.graphRect.size.width, self.graphRect.size.height/self.partialGraphLayers.count -2*cushion);
        //graphLayer.layer.position = CGPointMake(0.0, linePos);
        
        [ self.graphScrollView.graphView.selectedGraphLayer.layer setNeedsDisplay ];
        
    }
}

-(void) moveLayerNote :(NSNotification*) notif {
    NSLog(@"moveLayerNote");
}
-(void) reorderLayerNote :(NSNotification*) notif {
    NSLog(@"reorderLayerNote");
}
-(void) normalizeLayerNote :(NSNotification*) notif {
    NSLog(@"normalizeLayerNote");
}


-(IBAction)resetYTool:(id)sender{
    self.graphScrollView.graphView.scaley = 512.0;
    //[self.graphScrollView.graphView calculateNoteLayerPositions];
    [self.graphScrollView.graphView setNeedsDisplay];
}
-(void) resetXScale :(NSNotification*) notif {
    [ self resetYTool:nil ];
}

-(IBAction)deselectLayerAction:(id)sender {
    
    [ self.graphScrollView.graphView deSelectSelectedLayer ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_graph_bar_buttons_notification" object:nil userInfo:nil];
    
}

-(IBAction)markerPinAction:(id)sender {
    
    [self.graphScrollView.graphView setMarkerAtCursor];
    
    // for now for here
    // maybe need to do notification
    //[self addGraphMarkerToDocument];
    
    
}

-(void) changeGraphSizeNote :(NSNotification*) notif {
    
    //NSNumber * number = notif.object;
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * newWidth = [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_WIDTH];
    NSNumber * newHeight= [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_HEIGHT];
    
    if (newWidth && newHeight){
        
        self.graphScrollView.graphView.bounds = CGRectMake(0.0, 0.0, [newWidth floatValue], [newHeight floatValue]);
        self.graphScrollView.graphView.bounds = CGRectMake(0, 0, [newWidth floatValue], [newHeight floatValue]);
        
        [self.graphScrollView.graphView setUpVisibleLines];
        
        //[self.graphScrollView.graphView redrawGraph];
        
        //self.graphScrollView.graphView.timeRulerLayer;
        self.graphScrollView.graphView.timeRulerLayer.layer.bounds = CGRectMake(0.0, 0.0, self.graphScrollView.graphView.bounds.size.width, 80.0);
        CGPoint layerPoint = CGPointMake(self.graphScrollView.graphView.bounds.size.width/2.0, self.graphScrollView.graphView.bounds.size.height - 50.0);
        self.graphScrollView.graphView.timeRulerLayer.layer.position = layerPoint;
        [self.graphScrollView.graphView.timeRulerLayer.layer  setNeedsDisplay];
        //set bounds and redraw
        
        //self.graphScrollView.graphView.annotationLayer;
        //set bounds and redraw
        self.graphScrollView.graphView.annotationLayer.layer.bounds = CGRectMake(0.0, 0.0, 10.0, self.graphScrollView.graphView.bounds.size.height);
        self.graphScrollView.graphView.annotationLayer.annotationPoint = self.graphScrollView.graphView.annotationLayer.layer.bounds.origin;
        // time sublayer
        self.graphScrollView.graphView.annotationLayer.timeSubLayer.layer.position = CGPointMake(0.0, self.graphScrollView.graphView.bounds.size.height - 123.0);
        
        [self.graphScrollView.graphView redrawGraph];
        
        [self.graphScrollView.graphView setNeedsDisplay];
    }
    
}


#pragma mark - action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // we might want to use tableview controller instead
    //FR_AppDelegate* appDelegate = (FR_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        NSLog(@"actionSheet.cancelButtonIndex == buttonIndex");
    }
    
    switch (buttonIndex) {
        case 0: // expand
            [ self expandSelectedLayerAction:self ];
            break;
        case 1: // contract
            [ self contractSelectedLayerAction:self ];
            break;
        case 2: // normalize
            [ self normalizeSelectedLayerAction:self ];
            break;
        case 3: //move to local
            NSLog(@"Reorder");
            [ self reorderSelectedLayerAction:self ];
            break;
        case 4: // move
            [ self moveSelectedLayerAction:self ];
            break;
        default:
            
            break;
    }
}

-(IBAction)expandSelectedLayerAction:(id)sender {
    NSLog(@"expandSelectedLayerAction");
}
-(IBAction)contractSelectedLayerAction:(id)sender {
    NSLog(@"contractSelectedLayerAction");
}
-(IBAction)normalizeSelectedLayerAction:(id)sender {
    NSLog(@"normalizeSelectedLayerAction");
}
-(IBAction)reorderSelectedLayerAction:(id)sender {
    NSLog(@"reorderSelectedLayerAction");
}
-(IBAction)moveSelectedLayerAction:(id)sender {
    NSLog(@"moveSelectedLayerAction");
}

#pragma mark - gestures

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
	
	//CGPoint location = [recognizer locationInView:self.graphScrollView.graphView];
	//[self showImageWithText:@"tap" atPoint:location];
	
	//[UIView beginAnimations:nil context:NULL];
	//[UIView setAnimationDuration:0.5];
	//imageView.alpha = 0.0;
	//[UIView commitAnimations];
}

/*
 In response to a swipe gesture, show the image view appropriately then move the image view in the direction of the swipe as it fades out.
 */
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
	//NSLog(@"handleSwipeFrom");
    //CGPoint location = [recognizer locationInView:self.graphScrollView.graphView];
	//[self showImageWithText:@"swipe" atPoint:location];
	
    //if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
    //    location.x -= 220.0;
    //}
    //else {
    //    location.x += 220.0;
    //}
	
	//[UIView beginAnimations:nil context:NULL];
	//[UIView setAnimationDuration:0.55];
	//imageView.alpha = 0.0;
	//imageView.center = location;
	//[UIView commitAnimations];
}

/*
 In response to a rotation gesture, show the image view at the rotation given by the recognizer, then make it fade out in place while rotating back to horizontal.
 */
- (void)handleRotationFrom:(UIRotationGestureRecognizer *)recognizer {
	//CGPoint location = [recognizer locationInView:self.graphScrollView.graphView];
    //CGAffineTransform transform = CGAffineTransformMakeRotation([recognizer rotation]);
    //imageView.transform = transform;
	//[self showImageWithText:@"rotation" atPoint:location];
	//[UIView beginAnimations:nil context:NULL];
	//[UIView setAnimationDuration:0.65];
	//imageView.alpha = 0.0;
    //imageView.transform = CGAffineTransformIdentity;
	//[UIView commitAnimations];
}

- (void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer {
    
    CGPoint point1,point2,touchCenter;
    
    UIGestureRecognizerState recState = recognizer.state;
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            //NSLog(@"UIGestureRecognizerStateBegan");
            cacheMaxTime = [self.graphScrollView.graphView.graphMaxTime floatValue];
            cacheMinTime = [self.graphScrollView.graphView.graphMinTime floatValue];
            
            break;
        case UIGestureRecognizerStateChanged:
            //NSLog(@"UIGestureRecognizerStateChanged");
            break;
        case UIGestureRecognizerStateEnded:
            //NSLog(@"UIGestureRecognizerStateEnded");
            break;
            
        default:
            NSLog(@"UIGestureRecognizerState other...");
            break;
    }
    
    if([ recognizer numberOfTouches ] > 0 ){
        point1 = [ recognizer locationOfTouch:0 inView:self.graphScrollView.graphView ];
        //NSLog(@"     ... point 1: %f  %f",point1.x, point1.y);
    }
    if([ recognizer numberOfTouches ] > 1 ){
        point2 = [ recognizer locationOfTouch:1 inView:self.graphScrollView.graphView ];
        //NSLog(@"     ... point 2: %f  %f",point2.x, point2.y);
        
    } else {
        NSLog(@"only one touch");
        return;
    }
    
    touchCenter = CGPointMake((point1.x+point2.x)/2, (point1.y+point2.y)/2 );
    
    
    //CGPoint delta = CGPointMake(point2.x-point1.x,point2.y-point1.y);
    //NSLog(@"     ... delta  : %f  %f",delta.x,delta.y);
    //NSLog(@"scale = %f  velocity = %f",recognizer.scale, recognizer.velocity);
    
    //self.graphPadView.origin
    //self.graphPadView.scale
    float dataStart = [self.graphScrollView.graphView.startTime floatValue];
    float dataStop = [self.graphScrollView.graphView.stopTime floatValue];
    
    //float graphDuration=[self.graphPadView.graphMaxTime floatValue]-[self.graphPadView.graphMinTime floatValue];
    //float dataDuration = dataStop - dataStart;
    float dataDuration = cacheMaxTime-cacheMinTime;
    
    
    // map to time at that point x
    float leftOfPoint = touchCenter.x - self.graphScrollView.graphView.bounds.origin.x;
    //float rightOfPoint = self.graphPadView.bounds.size.width-leftOfPoint;
    float ratio = leftOfPoint / self.graphScrollView.graphView.bounds.size.width;
    //float timeAtPoint = [self.graphPadView.graphMinTime floatValue] + ratio * graphDuration;
    
    
    if (recognizer.scale < 1.0 ) { // pinching in
        float newDuration = recognizer.scale * dataDuration;
        float delta = (newDuration - dataDuration)/ (2.0*recognizer.scale);
        
        float deltaL = delta*ratio;
        float deltaR = delta*(1.0-ratio);
        
        // delta needs to be balanced around touchCenter
        //touchCenter.x
        if(cacheMinTime + deltaL < dataStart) {
            self.graphScrollView.graphView.graphMinTime = [NSNumber numberWithFloat: dataStart ];
        } else {
            self.graphScrollView.graphView.graphMinTime = [NSNumber numberWithFloat: cacheMinTime + deltaL ];
            
        }
        
        if(cacheMaxTime - deltaR > dataStop) {
            self.graphScrollView.graphView.graphMaxTime = [NSNumber numberWithFloat: dataStop ];
        } else {
            self.graphScrollView.graphView.graphMaxTime = [NSNumber numberWithFloat: cacheMaxTime - deltaR ];
        }
        
        
    } else { // pinching out
        
        float newDuration = recognizer.scale * dataDuration;
        float delta = (newDuration - dataDuration)/ (2.0*recognizer.scale);
        
        float deltaL = delta*ratio;
        float deltaR = delta*(1.0-ratio);
        
        self.graphScrollView.graphView.graphMinTime = [NSNumber numberWithFloat: cacheMinTime + deltaL ];//dataStart
        self.graphScrollView.graphView.graphMaxTime = [NSNumber numberWithFloat: cacheMaxTime - deltaR ];//dataStop
    }
    
    //self.graphPadView.graphMinTime = [NSNumber numberWithFloat: dataStart + (dataStop-dataStart)/2 ];
    
    [ self.graphScrollView.graphView setNeedsDisplay ];
    
}

- (void) handlePanFrom :(UIPanGestureRecognizer *)recognizer {
    
    UIGestureRecognizerState recState = recognizer.state;
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            //NSLog(@"UIGestureRecognizerStateBegan");
            cacheMaxTime = [self.graphScrollView.graphView.graphMaxTime floatValue];
            cacheMinTime = [self.graphScrollView.graphView.graphMinTime floatValue];
            
            break;
        case UIGestureRecognizerStateChanged:
            //NSLog(@"UIGestureRecognizerStateChanged");
            break;
        case UIGestureRecognizerStateEnded:
            //NSLog(@"UIGestureRecognizerStateEnded");
            break;
            
        default:
            NSLog(@"UIGestureRecognizerState other...");
            break;
    }
    
    CGPoint translation = [ recognizer translationInView:self.view ];//graphPadView
    //CGPoint velocity = [ recognizer velocityInView:self.view ];
    
    //NSLog(@"translation x %f",translation.x);
    //NSLog(@"velocity %f %f",velocity.x,velocity.y);
    
    float dataStart = [self.graphScrollView.graphView.startTime floatValue];
    float dataStop = [self.graphScrollView.graphView.stopTime floatValue];
    
    float deltax = (translation.x / self.graphScrollView.graphView.bounds.size.width)*( [self.graphScrollView.graphView.graphMaxTime floatValue]-[self.graphScrollView.graphView.graphMinTime floatValue]);
    
    if (cacheMinTime - deltax < dataStart) {
        deltax = cacheMinTime - dataStart;
    }
    if (cacheMaxTime - deltax > dataStop) {
        deltax = cacheMaxTime - dataStop;
    }
    
    self.graphScrollView.graphView.graphMinTime = [NSNumber numberWithFloat: cacheMinTime - deltax ];
    self.graphScrollView.graphView.graphMaxTime = [NSNumber numberWithFloat: cacheMaxTime - deltax ];
    
    [ self.graphScrollView.graphView setNeedsDisplay ];
    
}

- (void) handleLongPress :(UILongPressGestureRecognizer *)recognizer {
    NSLog(@"handleLongPress");
}



#pragma mark - obsolete mail interface
//=********************************************************************=//
-(void)email_Selected_Items
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    if (picker == nil) {
        NSMutableString     *work_String = [[NSMutableString alloc] initWithString:NSLocalizedString(@"This iOS device does not support mail capability with MFMailComposeViewController.", @"")];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"mail not supported", @"") message:work_String delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
    }
    else {
        picker.mailComposeDelegate = self;
        
        [picker setSubject:NSLocalizedString(@"Flight Record", @"")];
        
        // Set up recipients
        //NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
        //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
        //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
        
        //[picker setToRecipients:sms.recipients];
        //[picker setCcRecipients:sms.cc_Recipients];
        //[picker setBccRecipients:sms.bcc_Recipients];
        
        // Fill out the email body text
        //NSString *emailBody = @"It is raining in sunny California!";
        [picker setMessageBody:NSLocalizedString(@"Sent via Flight Recorder!", @"") isHTML:NO];
        
        
        FPh_AppDelegate* appDel = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
        NSData * attachmentData = [NSKeyedArchiver archivedDataWithRootObject:appDel.motionRecorder];
        //NSData *attachmentData = [NSData dataWithContentsOfFile:outputPath];
        
        NSString *fileName = [NSString stringWithFormat:@"FlightRecord.flr"];
        [picker addAttachmentData:attachmentData mimeType:@"application/flightrecord" fileName:fileName]; //octet-stream
        
        /*
         NSMutableArray      *item_Array = [NSMutableArray arrayWithCapacity:5];
         NSUInteger currentIndex = [ self.selectedIndices lastIndex ]; // goes backward
         while (currentIndex != NSNotFound) {
         CS_Asset *asset = [ self.assets objectAtIndex: currentIndex ];
         
         // List of mime types
         //http://www.iana.org/assignments/media-types/
         //NSLog(@"processing selected index %d", currentIndex);
         if (asset.assetType == cs_asset_type_picture) {
         //NSLog(@"index %d was an image at %@", currentIndex, asset.url);
         UIImage *asset_Image = [asset getImageFromData];
         
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         BOOL fileExists = YES;
         NSString *nextFileName = nil;
         NSString *outputPath = nil;
         NSURL       *path_URL;
         //NSself.fileManager *self.fileManager = [[[NSself.fileManager alloc] init]autorelease];
         for (int fileIndex = 0; fileExists == YES; fileIndex++ ) {
         nextFileName = [ NSString stringWithFormat:@"%@%d.jpeg", @"attachedfile", fileIndex ];
         outputPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Attachments"] stringByAppendingPathComponent:nextFileName ];
         fileExists = [ [NSFileManager defaultManager] fileExistsAtPath:outputPath ];
         }
         if (fileExists == NO) {
         path_URL = [NSURL fileURLWithPath:outputPath];
         }
         
         //NSLog(@"outputPath = %@", outputPath);
         
         if (path_URL) {
         [UIImageJPEGRepresentation(asset_Image, 1.0) writeToFile:outputPath atomically:YES];
         }
         
         //NSData * attachmentData = [NSKeyedArchiver archivedDataWithRootObject:asset_Image];
         NSData *attachmentData = [NSData dataWithContentsOfFile:outputPath];
         //NSLog(@"received attachment data length %d",[attachmentData length]);
         NSString *fileName = [NSString stringWithFormat:@"file%d",currentIndex];
         [picker addAttachmentData:attachmentData mimeType:@"image/jpeg" fileName:fileName];
         
         NSError *any_Error;
         
         BOOL file_Removed = [self.fileManager removeItemAtPath:outputPath error:&any_Error];
         
         //[item_Array addObject:asset_Image];
         }
         else if (asset.assetType == cs_asset_type_movie) {          // .mov's are quicktime
         // H264, mp4, mpeg, quicktime
         // do this the URL way
         // Attach an image to the email
         //NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
         //NSData *myData = [NSData dataWithContentsOfFile:path];
         //[picker addAttachmentData:myData mimeType:@"quicktime" fileName:@"rainy"];
         }
         
         
         
         currentIndex = [ self.selectedIndices  indexLessThanIndex: currentIndex ];
         }
         */
        
        
        [self presentModalViewController:picker animated:YES];
        
    }
} // -(void)email_Selected_Items
//=********************************************************************=//

//=********************************************************************=//
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
}

@end

