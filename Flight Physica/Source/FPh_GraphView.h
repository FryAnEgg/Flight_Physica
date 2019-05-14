//
//  FPh_GraphView.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "FlightAppConstants.h"

#import "FPh_GraphData.h"

#import "GraphLayer.h"

#import "AnnotationLayer.h"
#import "TextAnnotationLayer.h"
#import "RulerLayer.h"

@interface FPh_GraphView : UIView <UIGestureRecognizerDelegate> { //UIScrollView <UIScrollViewDelegate> {
    
    CGPoint _inset;
    //CGRect _graphRect;
    
    NSNumber * startTime;
    NSNumber * stopTime;
    
    NSNumber * graphMinTime;
    NSNumber * graphMaxTime;
    
    NSNumber * tZeroTime; // tbi
    
    // cursor
    CGPoint _touchPoint;
    BOOL _cursorIsShowing;
    NSTimeInterval _timeAtCursor;
    int _cursorIndex;
    
    // double finger crop
    BOOL _isTrackingCrop;
    UIView * _cropLeftGrayView;
    UIView * _cropRightGrayView;
    CGPoint _touchPoint_L;
    CGPoint _touchPoint_R;
    CGPoint _previousPoint_L;
    CGPoint _previousPoint_R;
    
    // zoom stretch
    BOOL _isTrackingLayerPinch;
    float _layerPinchOrigDeltaY;
    CGRect _origStretchyBounds;
    
    // graph layers
    NSMutableArray  * _partialGraphLayers;
    GraphLayer * _selectedGraphLayer;
    BOOL dragLayerInProgress;
    
    BOOL    lineVisible[kLegend_Last];
    UIColor *lineColor[kLegend_Last];
    
    int numLines;
    
    float _scalex;
    double _scaley;
    
    AnnotationLayer * _annotationLayer; // cursor layer
    
    RulerLayer      * _timeRulerLayer;
    
}

@property(nonatomic, assign) CGPoint inset;
//@property(nonatomic, assign) CGRect graphRect;

@property(nonatomic, assign) CGPoint touchPoint;

@property(nonatomic, assign) double scaley;

@property(nonatomic, retain) NSNumber * startTime;
@property(nonatomic, retain) NSNumber * stopTime;

@property(nonatomic, assign) NSTimeInterval timeAtCursor;
@property(nonatomic, assign) BOOL cursorIsShowing;

@property(nonatomic, retain) NSNumber * graphMinTime;
@property(nonatomic, retain) NSNumber * graphMaxTime;

@property(nonatomic, retain) AnnotationLayer * annotationLayer;
@property(nonatomic, retain) NSMutableArray  * partialGraphLayers;
@property(nonatomic, retain) RulerLayer      * timeRulerLayer;

@property(nonatomic, retain) GraphLayer * selectedGraphLayer;

@property(nonatomic, assign) CGPoint touchPoint_L;
@property(nonatomic, assign) CGPoint touchPoint_R;

@property(nonatomic, retain) UIView * cropLeftGrayView;
@property(nonatomic, retain) UIView * cropRightGrayView;


-(void) initGraphLayers;
-(void) removePartialGraphLayers;
-(void) setUpVisibleLines;
-(void) setDefaultLayerYPositions;

-(void) setGraphLimits:(NSNumber*)min max:(NSNumber*)max;
-(void) redrawGraph;

-(void) deSelectSelectedLayer;
-(void) setMarkerAtCursor;

-(NSTimeInterval) timeAtPoint:(CGPoint) point;
-(void) hideCursor;
//-(NSTimeInterval) setCursorToTouchedPoint;
-(void) cursorToNextPoint;
-(void) calculateNoteLayerPositions:(float) xPointValue;
-(NSTimeInterval) calculateLayerTime:(BOOL) refreshRegardless;

//-(UIImage *)createGraphImage;
-(UIImage *)takeScreenshot:(UIView*)yourView;
-(void) pinchSelectedLayerNote :(NSNotification*) notif;

-(void) showLeftCropView:(CGRect)rect;
-(void) showRightCropView:(CGRect)rect;
-(void) removeCropViews;

@end
