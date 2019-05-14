//
//  AnnotationLayer.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "FPh_GraphData.h"
#import "TimeDisplayLayer.h"

@interface AnnotationLayer : NSObject <CALayerDelegate>{
    
    CALayer * _layer;
    
    TimeDisplayLayer * _timeSubLayer;
    
    FPh_GraphData * _motionValue;
    CGPoint _annotationPoint;
    
    int _annotationType;
    NSString *_annotationString;
    NSString *_valueString;
    
}

@property (nonatomic, retain) CALayer * layer;
@property (nonatomic, retain) TimeDisplayLayer * timeSubLayer;

@property (nonatomic, retain) FPh_GraphData * motionValue;
@property (nonatomic, assign) CGPoint annotationPoint;
@property (nonatomic, assign) int annotationType;
@property (nonatomic, retain) NSString *annotationString;
@property (nonatomic, retain) NSString *valueString;

//-(id)  initWithCenter:(CGPoint)center value:(int)value boundsRect:(CGRect)boundsRect;

@end

