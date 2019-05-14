//
//  FPh_RecorderView.m
//  Flight Physica
//
//  Created by David Lathrop on 2/18/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_RecorderView.h"

@implementation FPh_RecorderView

@synthesize  fileLabel,motionDeltaLabel, gpsDeltaLabel, cameraDeltaLabel, triggerLabel, fileNameLabel, pilotLabel, planeLabel;

@synthesize liveGraph, liveGraphSegControl, recordButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)layoutSubviews {
    
    //[ super layoutSubviews];
    //NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    //NSNumber * width = [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_WIDTH];
    //NSNumber *  height= [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_HEIGHT];
/*
    CGPoint centerP = CGPointMake(self.frame.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height/2);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    
        self.liveGraph.frame = CGRectMake(self.liveGraph.frame.origin.x,
                                          self.frame.origin.y+76,
                                          self.frame.size.width - 2*( self.liveGraph.frame.origin.x - self.frame.origin.x),
                                          self.frame.size.height - 300); // from bottom?
        
        
        self.fileLabel.frame = CGRectMake(centerP.x - 0.5*fileLabel.frame.size.width,
                                   self.frame.origin.y+self.frame.size.height - 214.,
                                    self.fileLabel.frame.size.width,
                                    self.fileLabel.frame.size.height);
    
        float halfHt = self.liveGraphSegControl.frame.size.height / 2.;
    
        CGRect lgsRect = self.liveGraphSegControl.frame;
        
        self.liveGraphSegControl.frame = CGRectMake(centerP.x - 0.5*lgsRect.size.width,
                                      self.frame.origin.y+ self.frame.size.height - 250. - halfHt,
                                      lgsRect.size.width, lgsRect.size.height);
        //center x
        float cenX = self.frame.origin.x+self.frame.size.width/2.0;
        
        self.recordButton.frame = CGRectMake(cenX-0.5*self.recordButton.frame.size.width,
                                             self.recordButton.frame.origin.y,
                                             self.recordButton.frame.size.width, self.recordButton.frame.size.height);
    } else { // iPhone/iPod
        
        self.liveGraph.frame = CGRectMake(self.liveGraph.frame.origin.x,
                                          self.frame.origin.y+36,
                                          self.frame.size.width - 2*( self.liveGraph.frame.origin.x - self.frame.origin.x),
                                          self.frame.origin.y+self.frame.size.height - 180); // from bottom?
        
        
        self.fileLabel.frame = CGRectMake(centerP.x - 0.5*fileLabel.frame.size.width,
                                          self.frame.origin.y+self.frame.size.height - 144.,
                                          self.fileLabel.frame.size.width,
                                          self.fileLabel.frame.size.height);
        
        float halfHt = self.liveGraphSegControl.frame.size.height / 2.;
        
        CGRect lgsRect = self.liveGraphSegControl.frame;
        
        self.liveGraphSegControl.frame = CGRectMake(centerP.x - 0.5*lgsRect.size.width,
                                                    self.frame.origin.y+ self.frame.size.height - 159 - halfHt,
                                                    lgsRect.size.width, lgsRect.size.height);
        //center x
        float cenX = self.frame.origin.x+self.frame.size.width/2.0;
        
        self.recordButton.frame = CGRectMake(cenX-0.5*self.recordButton.frame.size.width,
                                             self.frame.origin.y+ self.frame.size.height-self.recordButton.frame.size.height-5.,
                                             self.recordButton.frame.size.width, self.recordButton.frame.size.height);
        
        
        // space 4 labels
        float botGraphY = self.liveGraph.frame.origin.y+self.liveGraph.frame.size.height;
        
        float labelDelta = 22.;
        
        self.fileNameLabel.frame = CGRectMake(self.fileNameLabel.frame.origin.x, botGraphY+labelDelta,
                                               self.fileNameLabel.frame.size.width, 21.);
        
        self.motionDeltaLabel.frame = CGRectMake(self.motionDeltaLabel.frame.origin.x, botGraphY+2*labelDelta,
                                                  self.motionDeltaLabel.frame.size.width, 21.);
        
        self.pilotLabel.frame  = CGRectMake(self.pilotLabel.frame.origin.x, botGraphY+3*labelDelta,
                                            self.pilotLabel.frame.size.width, 21.);
        
        self.planeLabel.frame = CGRectMake(self.planeLabel.frame.origin.x, botGraphY+4*labelDelta,
                                           self.planeLabel.frame.size.width, 21.);
        
        
    }
    */
}

/*
 -(void) createScreenForLaunchImage {
    
    [fileLabel setHidden:YES];
    [planeLabel setHidden:YES];
    [pilotLabel setHidden:YES];
    [fileNameLabel setHidden:YES];
    [motionDeltaLabel setHidden:YES];
    [liveGraphSegControl setHidden:YES];
    [recordButton setHidden:YES];
    
    //,, gpsDeltaLabel, cameraDeltaLabel, triggerLabel, , , ;
    
    //liveGraph, , ;
    
}
*/

@end
