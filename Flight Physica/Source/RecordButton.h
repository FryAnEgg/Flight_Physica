//
//  RecordButton.h
//  Flight Physica
//
//  Created by David Lathrop on 4/1/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "RecordingButtonLayer.h"

#define RB_MODE_READY 0
#define RB_MODE_RECORDING 1
#define RB_MODE_CLEAR 2

@interface RecordButton : UIButton {
    
    RecordingButtonLayer *buttonLayer;
    int buttonMode;
    
}

@property(nonatomic,assign) int buttonMode;

-(void) startRecordingAnimation;
-(void) stopRecordingAnimation;

@end
