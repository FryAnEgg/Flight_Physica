//
//  GraphAttributesTableViewController.h
//  Flight Physica
//
//  Created by David Lathrop on 1/26/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GraphLayer.h"
#import "GraphLineAttributeView.h"

@interface GraphAttributesTableViewController : UITableViewController {
    
    UISlider * r_slider;
    UISlider * g_slider;
    UISlider * b_slider;
    UISlider * a_slider;
    
    //UILabel * annoLabelView;
    
    BOOL bDirtyColor;
    GraphLayer * _graphLayer;
    GraphLineAttributeView *graphLineView;
    
    NSArray * sortedMarkers;
}

@property(nonatomic,retain) IBOutlet UISlider * r_slider;
@property(nonatomic,retain) IBOutlet UISlider * g_slider;
@property(nonatomic,retain) IBOutlet UISlider * b_slider;
@property(nonatomic,retain) IBOutlet UISlider * a_slider;
//@property(nonatomic,retain) IBOutlet UILabel * annoLabelView;
@property(nonatomic,retain) GraphLayer * graphLayer;

@property(nonatomic,retain) IBOutlet GraphLineAttributeView *graphLineView;

-(IBAction)sliderDidSlide:(id)sender;
-(IBAction)lineSizeStepped:(id)sender;

@end

