//
//  FPh_RecorderView.h
//  Flight Physica
//
//  Created by David Lathrop on 2/18/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveGraphView.h"

@interface FPh_RecorderView : UIView {
 
    LiveGraphView *liveGraph;
    UISegmentedControl * liveGraphSegControl;
    UILabel *motionDeltaLabel;
    UILabel *gpsDeltaLabel;
    UILabel *cameraDeltaLabel;
    UILabel *triggerLabel;
    UILabel *fileNameLabel;
    UILabel *pilotLabel;
    UILabel *planeLabel;
    UIButton *recordButton;
    
}

@property(nonatomic, retain) IBOutlet LiveGraphView *liveGraph;
@property(nonatomic, retain) IBOutlet UISegmentedControl * liveGraphSegControl;
@property(nonatomic, retain) IBOutlet UILabel *fileLabel;
@property(nonatomic, retain) IBOutlet UILabel *motionDeltaLabel;
@property(nonatomic, retain) IBOutlet UILabel *gpsDeltaLabel;
@property(nonatomic, retain) IBOutlet UILabel *cameraDeltaLabel;
@property(nonatomic, retain) IBOutlet UILabel *triggerLabel;
@property(nonatomic, retain) IBOutlet UILabel *fileNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *pilotLabel;
@property(nonatomic, retain) IBOutlet UILabel *planeLabel;
@property(nonatomic, retain) IBOutlet UIButton *recordButton;

//-(void) createScreenForLaunchImage;

@end
