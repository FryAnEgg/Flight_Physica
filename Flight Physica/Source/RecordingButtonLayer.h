//
//  RecordingButtonLayer.h
//  Flight Physica
//
//  Created by David Lathrop on 4/2/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface RecordingButtonLayer : NSObject <CALayerDelegate, CAAnimationDelegate> {
    
    BOOL isRunning;
    CALayer * mLayer; // spinLayer
    CALayer * flashLayer;
}

@property(nonatomic,retain) CALayer * mLayer;
@property(nonatomic,retain) CALayer * flashLayer;

@property(nonatomic,assign) BOOL isRunning;

-(CAKeyframeAnimation *) doRecordAnimation;
-(CAKeyframeAnimation *) doFlashAnimation;

@end
