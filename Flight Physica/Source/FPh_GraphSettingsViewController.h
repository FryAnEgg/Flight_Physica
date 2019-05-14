//
//  FPh_GraphSettingsViewController.h
//  Flight Physica
//
//  Created by David Lathrop on 1/26/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "GraphLegendViewController.h"
//#import "GraphAttributesTableViewController.h"
#import "GraphLineAttributeView.h"
#import "GraphLayer.h"

enum SizeIndices
{
	k800x1200 = 0,
    k1200x800,
	k1200x1800,
    k1800x1200
};

enum GraphSettingsSections
{
	kGraphSize = 0,
	kGraphLines,
    kFetchSettings,
    kGraph_Last
};


@interface FPh_GraphSettingsViewController : UITableViewController <UIActionSheetDelegate> {
    
    //UITableView * tableView;
    GraphLineAttributeView *graphLineView;
    //GraphLegendViewController * graphLegendViewController;
    //GraphAttributesTableViewController * graphAttributesTableViewController;
    
    UIActionSheet * graphSizeActionSheet;
    UIActionSheet * fetchSizeActionSheet;
    
    NSMutableArray * graphLayers;
    GraphLayer * selectedGraphLayer;
}

//@property(nonatomic,retain) IBOutlet UITableView * tableView;
//@property(nonatomic, retain) GraphLegendViewController * graphLegendViewController;
//@property(nonatomic, retain) GraphAttributesTableViewController * graphAttributesTableViewController;

@property(nonatomic, retain) NSMutableArray * graphLayers;


@end
