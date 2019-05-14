//
//  AttitudeDisplayLayer.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

#import "FlightAppConstants.h"

@interface AttitudeDisplayLayer : NSObject <CALayerDelegate>{
    CALayer * _layer;
    CALayer * _bglayer;
    
    double attitudeRoll;
    double attitudePitch;
    double attitudeHeading;
    
    int attitudeMode;
}

@property (nonatomic, retain) CALayer * layer;
@property (nonatomic, retain) CALayer * bglayer;

@property (nonatomic, assign) double attitudeRoll;
@property (nonatomic, assign) double  attitudePitch;
@property (nonatomic, assign) double  attitudeHeading;

@property (nonatomic, assign) int attitudeMode;


@end
