//
//  FPh_GraphViewController.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GraphScrollView.h"
#import "MotionRecorder.h"
#import "GraphTitleView.h"

#import <CoreData/CoreData.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface FPh_GraphViewController : UIViewController < MFMailComposeViewControllerDelegate >{
    
    FlightManagedDocument * _flightGraphDocument;
    
    MetaData * fmd;
    
    FlightManagedDocument* _copiedDoc;
    NSTimeInterval firstCopyTime;
    NSTimeInterval lastCopyTime;
    
    UITapGestureRecognizer *tapRecognizer;
	UISwipeGestureRecognizer *swipeLeftRecognizer;
    
    BOOL waitingOnFetch;
    BOOL isDataFetchComplete;
    
    UIAlertView *errorAlert;
    UIAlertView *closeAlert;
    
    float cacheMinTime;
    float cacheMaxTime;
    
    NSUInteger graphFetchOffset;
    NSUInteger graphFetchOffsetStart;
    
    NSFetchedResultsController *_fetchedResultsController;
    
    NSTimeInterval _graphStartTime;
    NSTimeInterval _graphStopTime;
    
}

@property(nonatomic, retain) FlightManagedDocument * flightGraphDocument;
@property(nonatomic, retain) FlightManagedDocument* copiedDoc;

@property(nonatomic, strong) IBOutlet UIToolbar * toolbar;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * spaceLeftItem;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * spaceRightItem;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * cropLeftBarButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * cropRightBarButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * resetCropBarButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * cropBothBarButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * copDocBarButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * deselectLayerBarButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * layerToolsBarButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * cameraBarButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * markerBarButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * stopFetchBarButton;

@property(nonatomic, strong) IBOutlet UIBarButtonItem * pageUpButton;
@property(nonatomic, strong) IBOutlet UIBarButtonItem * pageDownButton;

@property(nonatomic, strong) GraphTitleView * graphTitleView;

@property(nonatomic, strong) IBOutlet GraphScrollView *graphScrollView;

//@property(nonatomic, retain) GraphSettingsViewController *graphSettingsViewController;
//@property(nonatomic, retain) GraphAttributesTableViewController * graphAttributesTableViewController;
//@property(nonatomic, retain) ToolsTableController * toolsViewController;
//@property(nonatomic, retain) FlightDocumentListViewController *flightDocsController;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property(nonatomic, assign) NSTimeInterval graphStartTime;
@property(nonatomic, assign) NSTimeInterval graphStopTime;

@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;

-(void) setUpDataFetch;
-(IBAction) stopFetchAction:(id) sender;
-(void) refreshGraph;

-(void)fetchMetaDataForGraph;
-(void)addGraphMarkersFromDBArray:(NSArray*)array;

-(IBAction)cropLeftTool:(id)sender;
-(IBAction)cropRightTool:(id)sender;
-(IBAction)resetTimeScaleTool:(id)sender;
-(IBAction)pageDownTool:(id)sender;
-(IBAction)pageUpTool:(id)sender;
-(IBAction)cropTool:(id)sender;

-(IBAction)openLayerTools:(id)sender;

-(IBAction)resetYTool:(id)sender;

-(IBAction)deselectLayerAction:(id)sender;
-(IBAction)markerPinAction:(id)sender;

-(IBAction)expandSelectedLayerAction:(id)sender;
-(IBAction)contractSelectedLayerAction:(id)sender;
-(IBAction)normalizeSelectedLayerAction:(id)sender;
-(IBAction)reorderSelectedLayerAction:(id)sender;
-(IBAction)moveSelectedLayerAction:(id)sender;

@end
