//
//  GraphLayer.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "FPh_GraphData.h"

#import "TextAnnotationLayer.h"

@interface GraphLayer : NSObject <CALayerDelegate>{
    
    CALayer * _layer;
    
    int typeIndex;
    UIColor * _lineColor;
    NSNumber * lineWidth;
    
    NSNumber * _graphMinTime;
    NSNumber * _graphMaxTime;
    
    double _scaley;
    double _zeroPointY;
    
    int _legendValue;
    NSString * _annoString;
    NSString * _longString;
    NSString *unitsString;
    
    NSMutableArray  * _subAnnotations;
    
    //TextAnnotationLayer * _cursorLayer;
    
    BOOL _isSelected;
}

@property (nonatomic, retain) CALayer * layer;

@property (nonatomic, retain) UIColor * lineColor;
@property (nonatomic, retain) NSNumber * lineWidth;

@property(nonatomic, retain) NSNumber * graphMinTime;
@property(nonatomic, retain) NSNumber * graphMaxTime;

@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, assign) int typeIndex;

@property(nonatomic, assign) double scaley;
@property(nonatomic, assign) double zeroPointY;

@property(nonatomic, assign) int legendValue;
@property(nonatomic, retain) NSString * annoString;
@property(nonatomic, retain) NSString * longString;

@property(nonatomic, retain) NSMutableArray  * subAnnotations;
@property(nonatomic, retain) TextAnnotationLayer * cursorLayer;

-(id) initWithLineIndex : (int) index;

-(void) autoScaleData;
-(void) resetSubAnnotationPositions;
-(void) removeSubAnnotations;
-(double) getLayerYValue:(FPh_GraphData *) motionPoint;
-(NSString*) unitString;
-(void) moveCursorTo:(float)xPointValue motion:(FPh_GraphData*)motion;
-(void) addAnnotationAt:(float)xPointValue motion:(FPh_GraphData*)motion;
-(void) showCursor;
-(void) hideCursor;

@end
