//
//  RulerLayer.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

@interface RulerLayer : NSObject <CALayerDelegate> {
    
    CALayer * _layer;
    NSTimeInterval ruleStart;
    NSTimeInterval ruleEnd;
    
}

@property (nonatomic, retain) CALayer * layer;

-(void) setRuleLimits:(NSNumber*)min max:(NSNumber*)max;

@end

