//
//  TextAnnotationLayer.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "FPh_GraphData.h"

#import "AttitudeDisplayLayer.h"


@interface TextAnnotationLayer : NSObject <CALayerDelegate>{
    
    CALayer * _layer;
    AttitudeDisplayLayer *_valueDisplayIndicator;
    int _annotationType;
    double _yValue;
    NSString *_annotationString;
    NSString *_valueString;
    NSString *_titleString;
    UIColor * _color;
    
    FPh_GraphData* _motionValue;
    NSTimeInterval timeStamp;
    CGPoint _labelOffset;
    
}

-(id)  initWithType: (int) type showIndicator:(BOOL)showIndicator offset:(CGPoint)offset;

@property (nonatomic, retain) CALayer * layer;
@property(nonatomic, retain) AttitudeDisplayLayer *valueDisplayIndicator;
@property (nonatomic, assign) int annotationType;
@property (nonatomic, assign) double yValue;
@property (nonatomic, assign) NSTimeInterval timeStamp;
@property (nonatomic, retain) NSString *annotationString;
@property (nonatomic, retain) NSString *valueString;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) UIColor * color;
@property (nonatomic, retain) FPh_GraphData* motionValue;

@property (nonatomic, assign) CGPoint labelOffset;

@end
