
//
//  FPh_GraphView.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_GraphView.h"

#import "FPh_AppDelegate.h"
#import "FPh_GraphData.h"

#import <CoreMotion/CMMotionManager.h>

@implementation FPh_GraphView

@synthesize inset = _inset;
//@synthesize graphRect = _graphRect;
@synthesize startTime, stopTime;
@synthesize graphMinTime, graphMaxTime;

@synthesize scaley = _scaley;
@synthesize annotationLayer = _annotationLayer;
@synthesize timeRulerLayer = _timeRulerLayer;

@synthesize partialGraphLayers = _partialGraphLayers;
@synthesize selectedGraphLayer = _selectedGraphLayer;
@synthesize touchPoint = _touchPoint;
@synthesize touchPoint_L = _touchPoint_L;
@synthesize touchPoint_R = _touchPoint_R;

@synthesize timeAtCursor = _timeAtCursor;
@synthesize cursorIsShowing = _cursorIsShowing;

@synthesize cropRightGrayView = _cropRightGrayView;
@synthesize cropLeftGrayView = _cropLeftGrayView;


-(void) initGraphLayers {
    //CGRect bRect = self.bounds;
    // cursor layer
    if (!self.annotationLayer) {
        self.annotationLayer = [[AnnotationLayer alloc] init];
        self.annotationLayer.layer.bounds = CGRectMake(0.0, 0.0, 10.0, self.bounds.size.height);//10.0w
        self.annotationLayer.annotationPoint = self.annotationLayer.layer.bounds.origin;
        [self.layer addSublayer:self.annotationLayer.layer];
        // time sublayer
        self.annotationLayer.timeSubLayer.layer.position = CGPointMake(0.0, self.bounds.size.height - 123.0);
        self.annotationLayer.layer.anchorPoint = CGPointMake(0.5, 0.0);
    }
    
    //RulerLayer
    if (!self.timeRulerLayer) {
        self.timeRulerLayer = [[RulerLayer alloc] init];
        self.timeRulerLayer.layer.bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, 80.0);
        CGPoint layerPoint = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        self.timeRulerLayer.layer.position = layerPoint;
        [self.layer addSublayer:self.timeRulerLayer.layer];
    }
    
    if(!self.partialGraphLayers){
        self.partialGraphLayers = [ NSMutableArray array ];
        [self setUpVisibleLines];
    }
    
    //self.graphRect = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);

}

-(void) commonInit {
    
    self.inset = CGPointMake(10.0, 10.0);
    
    self.startTime = [ NSNumber numberWithFloat: 0.];
    self.stopTime = [ NSNumber numberWithFloat: 0.];
    self.graphMinTime = [ NSNumber numberWithFloat: 0.];
    self.graphMaxTime = [ NSNumber numberWithFloat: 0.];
    
    self.backgroundColor = [UIColor whiteColor];
    self.scaley = 512.0;
    
    dragLayerInProgress = NO;
    
    self.multipleTouchEnabled = YES;
    
    //self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITapGestureRecognizer *recognizer11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap11:)];
    [self addGestureRecognizer:recognizer11];
    //self.tapRecognizer = (UITapGestureRecognizer *)recognizer;
    //recognizer11.delegate = self;
    
    UITapGestureRecognizer *recognizer21 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap21:)];
    recognizer21.numberOfTouchesRequired = 2;
    [self addGestureRecognizer:recognizer21];
    
    UITapGestureRecognizer *recognizer12 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap12:)];
    recognizer12.numberOfTapsRequired = 2;
    [self addGestureRecognizer:recognizer12];
    
    UITapGestureRecognizer *recognizer22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap22:)];
    recognizer22.numberOfTapsRequired = 2;
    recognizer22.numberOfTouchesRequired = 2;
    [self addGestureRecognizer:recognizer22];
    
    NSNotificationCenter * noteCen = [ NSNotificationCenter defaultCenter ];
    [ noteCen addObserver:self  selector:@selector(pinchSelectedLayerNote:)name:@"pinch_selected_layer"  object:nil];
    

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void) awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self commonInit];
    
}


-(void) deSelectSelectedLayer {
    if(self.selectedGraphLayer) {
        self.selectedGraphLayer.isSelected = NO;
        [self.selectedGraphLayer autoScaleData];
        [self.selectedGraphLayer.layer setNeedsDisplay];
        self.selectedGraphLayer = nil;
    }
}

//- (void)layoutSubviews {
    
//    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
//    NSNumber * width = [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_WIDTH];
//    NSNumber *  height= [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_HEIGHT];
   
    //if (self.bounds.size.width != [width floatValue] || self.bounds.size.height != [height floatValue]) {
    //    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, [width floatValue], [height floatValue] ) ;
    //}
//}

#pragma mark - tap gestures

- (void)handleTap11:(UITapGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint location = [recognizer locationInView:self];
        
        if(self.selectedGraphLayer) {
            
            [ self deSelectSelectedLayer ];
            
            // is there anything below
            
        } else { // find a new selection
            
            // test for partialGraphLayers bounds
            for ( int i=0; i<self.partialGraphLayers.count; i++) {
                
                GraphLayer * pgl = [self.partialGraphLayers objectAtIndex:i];
                
                float halfHeight = pgl.layer.bounds.size.height / 2;
                
                // hit test the sublayers of partial graph layer
                //AttitudeDisplayLayer * adl = pgl.cursorLayer. valueDisplayIndicator;
                //NSArray *array = pgl.subAnnotations;
                
                if ( location.y > pgl.layer.position.y - halfHeight && location.y < pgl.layer.position.y + halfHeight){
                    //set as selected
                    self.selectedGraphLayer = pgl;
                    self.selectedGraphLayer.isSelected = YES;
                    [self.selectedGraphLayer.layer setNeedsDisplayInRect:self.bounds];
                    // maybe smarter?
                    break;
                    
                }
            }
        }
        
        [ self removeCropViews ];
        //[ self hideCursor ];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_graph_bar_buttons_notification" object:nil userInfo:nil];
    }
}

- (void)handleTap21:(UITapGestureRecognizer *)recognizer {
    //NSLog(@"handleTap21");
}

- (void)handleTap12:(UITapGestureRecognizer *)recognizer {
    //NSLog(@"handleTap12");
}

- (void)handleTap22:(UITapGestureRecognizer *)recognizer {
    //NSLog(@"handleTap22");
}

-(void) removePartialGraphLayers {
    for ( int i=0; i<self.partialGraphLayers.count; i++) { // remove layer
        GraphLayer * pLayer = [self.partialGraphLayers objectAtIndex:i];
        [pLayer.layer removeFromSuperlayer];
    }
    [self.partialGraphLayers removeAllObjects];
    self.selectedGraphLayer = nil;
}

-(void) setUpVisibleLines {
    
    // can we do this without removing all layers
    [ self removePartialGraphLayers ];
    
    NSUserDefaults	*application_Defaults = [NSUserDefaults standardUserDefaults];
    numLines = 0;
    // setup line colors and lineVisibles
    for (int i=0; i<kLegend_Last; i++) {
        
        BOOL defaultsValue;
        UIColor *trueBlackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        
        switch (i) {
            case kLegend_Accel_x:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_X];
                lineColor[i] = [UIColor redColor];
                break;
            case kLegend_Accel_y:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_Y];
                lineColor[i] = trueBlackColor;
                break;
            case kLegend_Accel_z:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ACC_Z];
                lineColor[i] = [UIColor blueColor];
                break;
            case kLegend_Attitude_Roll:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ATT_ROLL];
                lineColor[i] = [UIColor redColor];
                break;
            case kLegend_Attitude_Pitch:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ATT_PITCH];
                lineColor[i] = trueBlackColor;
                break;
            case kLegend_Attitude_Yaw:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ATT_YAW];
                lineColor[i] = [UIColor blueColor];
                break;
            case kLegend_Rotation_x:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ROT_X];
                lineColor[i] = [UIColor redColor];
                break;
            case kLegend_Rotation_y:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ROT_Y];
                lineColor[i] = trueBlackColor;
                break;
            case kLegend_Rotation_z:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_ROT_Z];
                lineColor[i] = [UIColor blueColor];
                break;
            case kLegend_Heading:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_HEADING];
                lineColor[i] = trueBlackColor;
                break;
            case kLegend_Gravity_x:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_GRAV_X];
                lineColor[i] = [UIColor redColor];
                break;
            case kLegend_Gravity_y:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_GRAV_Y];
                lineColor[i] = trueBlackColor;
                break;
            case kLegend_Gravity_z:
                defaultsValue = [application_Defaults boolForKey:DEFAULTS_LEGEND_SHOW_GRAV_Z];
                lineColor[i] = [UIColor blueColor];
                break;
                
            //default:
            //    NSLog(@"bad case value!");
            //    break;
        }
        
        lineVisible[i] = defaultsValue;
        
        BOOL foundLayer = NO;
        GraphLayer * gl;
        for(int j=0; j<self.partialGraphLayers.count && !foundLayer; j++) {
            GraphLayer * gl = [self.partialGraphLayers objectAtIndex:j];
            if (gl.legendValue == i) {
                NSLog(@"found existing graph layer");
                foundLayer = YES;
            }
        }
        
        if (defaultsValue == YES) {
            if (foundLayer==NO) {
                numLines++;
                
                // graphlayer
                GraphLayer * graphLayer = [[ GraphLayer alloc ] initWithLineIndex: i];
                [self.partialGraphLayers addObject:graphLayer];
                
                graphLayer.lineColor = lineColor[i];
                graphLayer.lineWidth = [NSNumber numberWithFloat:5.0];
                graphLayer.legendValue = i;
                
                graphLayer.graphMaxTime = self.graphMaxTime; //[NSNumber numberWithDouble:self.graphStopTime];
                graphLayer.graphMinTime = self.graphMinTime; //[NSNumber numberWithDouble:self.graphStartTime];
                
                graphLayer.layer.anchorPoint = CGPointMake(0.0, 0.5);
                
                graphLayer.layer.position = CGPointMake(0.0, self.bounds.size.height/2);
                [ self.layer addSublayer : graphLayer.layer ];
                [graphLayer.layer setNeedsDisplay];
            } else { // do we need do anything
                NSLog(@"YES YES");
            }
        } else {
            if(foundLayer==YES){ // remove this layer
                [gl.layer removeFromSuperlayer];
                [self.partialGraphLayers removeObject:gl];
            }
        }
    }
    
    [self setDefaultLayerYPositions];
    
    [ self hideCursor ];
}

-(void) setDefaultLayerYPositions {
    
    float delta = (self.bounds.size.height - 140.0)/numLines;
    float linePos = delta/2.0;
    
    float cushion = 20.0;
    for(int i=0; i<self.partialGraphLayers.count; i++) {
        GraphLayer * graphLayer = [self.partialGraphLayers objectAtIndex:i];
        graphLayer.layer.bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height/self.partialGraphLayers.count-2*cushion);
        graphLayer.layer.position = CGPointMake(0.0, linePos);
        linePos+=delta;
    }
    
    self.timeRulerLayer.layer.position = CGPointMake(self.timeRulerLayer.layer.position.x, self.bounds.size.height- 50.0 );
}

-(void) setGraphLimits:(NSNumber*)min max:(NSNumber*)max {
    
    self.graphMinTime = min;
    self.graphMaxTime = max;
    
    for (int i=0; i<self.partialGraphLayers.count; i++) {
        
        GraphLayer * pgl = [self.partialGraphLayers objectAtIndex:i];
        
        pgl.graphMinTime = self.graphMinTime;
        pgl.graphMaxTime = self.graphMaxTime;
        
    }
    
    [self.timeRulerLayer setRuleLimits:min max:max];
}

-(void) redrawGraph {
    
    [self setNeedsDisplay ];
    
    [self.annotationLayer.layer setNeedsDisplay];
    
    [self.timeRulerLayer.layer setNeedsDisplay];
    
    for (int i=0; i<self.partialGraphLayers.count; i++) {
        
        GraphLayer * pgl = [self.partialGraphLayers objectAtIndex:i];
        
        [pgl autoScaleData];
        
        [pgl resetSubAnnotationPositions];
        
        [pgl.layer setNeedsDisplay];
    }
}

/*-(void) drawGraphinContext:(CGContextRef)context rect:(CGRect)rect {
 
 FR_AppDelegate* appDelegate = (FR_AppDelegate*)[UIApplication sharedApplication].delegate;
 
 CGContextSetFillColorWithColor ( context, [ UIColor whiteColor ].CGColor );
 CGContextFillRect(context, rect );
 
 //CGContextSetStrokeColorWithColor ( context, [ UIColor blackColor ].CGColor );
 //CGContextBeginPath( context );
 //CGContextMoveToPoint(context, 0.0, rect.size.height-origin.y);//origin.x
 //CGContextAddLineToPoint( context, rect.size.width, rect.size.height-origin.y );
 
 //CGContextMoveToPoint(context, 0.0, rect.size.height-origin.y);
 //CGContextAddLineToPoint( context, 0.0, 0.0 );
 //CGContextStrokePath(context);
 
 if ( appDelegate.motionData.count == 0 ) { //No Data
 NSString *string = NSLocalizedString(@"No Data", @"");
 int fontsize = 128;
 UIFont * theFont = [ UIFont systemFontOfSize:fontsize ];
 CGContextSetFillColorWithColor ( context, [ UIColor blackColor ].CGColor );
 
 CGSize sSize = [ string sizeWithFont:theFont ];
 [ string drawAtPoint: CGPointMake( rect.origin.x + ( rect.size.width - sSize.width ) / 2 ,  rect.origin.y + ( rect.size.height - sSize.height ) / 2 ) withFont:theFont ] ;
 
 return;
 }
 
 float lineDiffy = self.bounds.size.height / (numLines+2);
 float lineBasey = 2*lineDiffy;
 
 double graph_scale_y = (self.scaley/numLines);
 
 _scalex = self.bounds.size.width/([self.graphMaxTime floatValue]-[self.graphMinTime floatValue]);
 
 // we need scale and shiftx
 NSTimeInterval oldStamp = 0.0;
 
 for ( int i=0; i<kLegend_Last; i++ ) { //
 
 if (lineVisible[i]) {
 
 //
 CGContextSetStrokeColorWithColor ( context, lineColor[i].CGColor );
 
 BOOL bFirstPointDrawn = NO;
 
 int  drawCycleLimit = 100;
 int  drawCycleCount = -1;
 
 for (int j=0; j<[appDelegate.motionData count]; j++) {
 
 drawCycleCount++;
 
 ZZDeviceMotion * motionPoint = [appDelegate.motionData objectAtIndex:j];
 
 NSTimeInterval stamp = [motionPoint.timestamp doubleValue];
 
 if (oldStamp>stamp) {
 NSLog(@"oldStamp>stamp");
 }
 oldStamp = stamp;
 
 NSNumber * stampNumber = [NSNumber numberWithDouble:stamp ];
 
 if ([stampNumber floatValue] < [self.graphMinTime floatValue]) {
 continue;
 }
 if ([stampNumber floatValue] > [self.graphMaxTime floatValue]) {
 continue;
 }
 
 double yValue = 0.0;
 switch (i) {
 case kLegend_Accel_x:
 yValue = [motionPoint.accx doubleValue];
 break;
 case kLegend_Accel_y:
 yValue = [motionPoint.accy doubleValue];
 break;
 case kLegend_Accel_z:
 yValue = [motionPoint.accz doubleValue];
 break;
 case kLegend_Attitude_Roll:
 yValue = [motionPoint.attRoll doubleValue];
 break;
 case kLegend_Attitude_Pitch:
 yValue = [motionPoint.attPitch doubleValue];
 break;
 case kLegend_Attitude_Yaw:
 yValue = [motionPoint.attYaw doubleValue];
 break;
 case kLegend_Rotation_x:
 yValue = [motionPoint.rotx doubleValue];
 break;
 case kLegend_Rotation_y:
 yValue = [motionPoint.roty doubleValue];
 break;
 case kLegend_Rotation_z:
 yValue = [motionPoint.rotz doubleValue];
 break;
 case kLegend_Heading:
 yValue = 0;//motionPoint.heading;
 break;
 case kLegend_Gravity_x:
 yValue = [motionPoint.gravx doubleValue];
 break;
 case kLegend_Gravity_y:
 yValue = [motionPoint.gravy doubleValue];
 break;
 case kLegend_Gravity_z:
 yValue = [motionPoint.gravz doubleValue];
 break;
 default:
 break;
 }
 
 
 CGPoint graphPoint = CGPointMake( ([stampNumber floatValue]-[self.graphMinTime floatValue]) * _scalex, lineBasey - yValue*graph_scale_y );
 
 if (bFirstPointDrawn==NO) {
 CGContextMoveToPoint(context, graphPoint.x, graphPoint.y );
 bFirstPointDrawn = YES;
 } else {
 CGContextAddLineToPoint( context, graphPoint.x, graphPoint.y );
 }
 
 //////
 if (drawCycleCount >= drawCycleLimit) {
 drawCycleCount = -1;
 CGContextSetLineWidth(context, 5.0);
 CGContextStrokePath(context);
 CGContextMoveToPoint(context, graphPoint.x, graphPoint.y );
 }
 }
 CGContextSetLineWidth(context, 5.0);
 CGContextStrokePath(context);
 lineBasey += lineDiffy;
 }
 }
 
 //int fontsize = 16;
 //UIFont * theFont = [ UIFont systemFontOfSize:fontsize ];
 //CGContextSetFillColorWithColor ( context, [ UIColor blackColor ].CGColor );
 
 //CGSize sSize = [ abString sizeWithFont:gridFont ];
 //[ abString drawAtPoint: CGPointMake( gridOrig.x + ([ ab.inning intValue ]-1)*cellSize.x + ( cellSize.x - sSize.width ) / 2,
 //									gridOrig.y + ([ ab.orderSlot intValue ]-1)*cellSize.y + ( cellSize.y - sSize.height ) / 2  ) withFont: gridFont ] ;
 }*/

-(NSTimeInterval) timeAtPoint:(CGPoint) point {
    
    NSNumber * ratioX = [NSNumber numberWithFloat:(point.x - self.bounds.origin.x) / self.bounds.size.width]; // or self.graphRect ?
    
    NSTimeInterval timeValue = [self.graphMinTime doubleValue] + [ratioX doubleValue] *([self.graphMaxTime doubleValue]-[self.graphMinTime doubleValue ]);
    
    return timeValue;
}


#pragma mark - cursor related

-(void) hideCursor {
    
    self.cursorIsShowing = NO;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.0f]
                     forKey:kCATransactionAnimationDuration];
    self.annotationLayer.layer.position = CGPointMake( self.bounds.origin.x - 200, 0.0);
    [CATransaction commit];
    
    // will need to hide layer marks too
    for ( int i=0; i<self.partialGraphLayers.count; i++) {
        
        GraphLayer * pgl = [self.partialGraphLayers objectAtIndex:i];
        
        [ pgl hideCursor ];
    }
}

-(NSTimeInterval) setCursorToPoint:(CGPoint)point refreshRegardless:(BOOL)refreshRegardless {
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSTimeInterval timeValue  = [ self timeAtPoint:self.touchPoint ];
    
    NSTimeInterval largestUnderTime = 0.0;
    NSTimeInterval lowestOverTime = 0.0;
    
    FPh_GraphData * largestUnderMotion;
    FPh_GraphData * lowestOverMotion;
    FPh_GraphData * selectedMotion;
    
    BOOL bFirstOver = NO;
    
    // go thru data to find closest value
    // can we cache some search data for i start?
    for (int i=0; i<appDelegate.flightData.filteredData.count && bFirstOver==NO; i++) {
        
        FPh_GraphData * motionPoint = [appDelegate.flightData.filteredData objectAtIndex:i];
        NSTimeInterval stamp = motionPoint.timestamp;
        //NSNumber * stampNumber = [NSNumber numberWithDouble:stamp ];
        
        if (stamp < timeValue ) {
            largestUnderTime = stamp;
            largestUnderMotion = motionPoint;
        } else {
            bFirstOver = YES;
            lowestOverTime = stamp;
            lowestOverMotion = motionPoint;
            _cursorIndex = i;
        }
    }
    
    // check to see if motionValue has changed
    NSTimeInterval layerTime = lowestOverTime;
    selectedMotion = lowestOverMotion;
    
    // round to nearest (low or high)
    if ((timeValue-largestUnderTime) < (lowestOverTime-timeValue)) {
        layerTime = largestUnderTime;
        selectedMotion = largestUnderMotion;
        _cursorIndex--;
    }
    
    //refreshRegardless = YES;
    // we should track the chosen index as well
    
    if ( self.annotationLayer.motionValue != selectedMotion || refreshRegardless ) { // new value
        
        self.annotationLayer.motionValue = selectedMotion;
        
        //FPh_GraphData * checkMotion = [appDelegate.flightData.filteredData objectAtIndex:_cursorIndex];
        
        //convert layerTime back to point in view
        _scalex = self.bounds.size.width/([self.graphMaxTime floatValue]-[self.graphMinTime floatValue]);
        
        NSNumber * timeNumber = [ NSNumber numberWithDouble:layerTime - [self.graphMinTime doubleValue] ];
        
        CGPoint layerPoint = CGPointMake( [timeNumber floatValue] * _scalex, 0.0 );
        
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:0.0f]
                         forKey:kCATransactionAnimationDuration];
        self.annotationLayer.layer.position = layerPoint;
        //CGPointMake( self.bounds.origin.x + ratioX*self.bounds.size.width, self.bounds.origin.y + ratioY*self.bounds.size.height);
        [CATransaction commit];
        
        [ self calculateNoteLayerPositions: layerPoint.x ];
        
    } else {
        
    }
    
    return layerTime;
}

-(NSTimeInterval) dragCursorToPoint:(CGPoint)point {
    // we wont have to start from the first point since we know where the last point was.
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSTimeInterval timeValue  = [ self timeAtPoint:self.touchPoint ];
    
    // iteratively determine search index from cached
    //self.annotationLayer.motionValue.timestamp;
    //_cursorIndex
    //int startIndex = _cursorIndex;
    //if (_timeAtCursor < timeValue) {
     //   NSLog(@"_timeAtCursor < timeValue");
    //}
    //NSTimeInterval startTime = xxx;
    
    NSTimeInterval largestUnderTime = 0.0;
    NSTimeInterval lowestOverTime = 0.0;
    
    FPh_GraphData * largestUnderMotion;
    FPh_GraphData * lowestOverMotion;
    FPh_GraphData * selectedMotion;
    
    BOOL bFirstOver = NO;
    
    // go thru data to find closest value
    // can we cache some search data for i start?
    for (int i=0; i<appDelegate.flightData.filteredData.count && bFirstOver==NO; i++) {
        
        FPh_GraphData * motionPoint = [appDelegate.flightData.filteredData objectAtIndex:i];
        NSTimeInterval stamp = motionPoint.timestamp;
        //NSNumber * stampNumber = [NSNumber numberWithDouble:stamp ];
        
        if (stamp < timeValue ) {
            largestUnderTime = stamp;
            largestUnderMotion = motionPoint;
        } else {
            bFirstOver = YES;
            lowestOverTime = stamp;
            lowestOverMotion = motionPoint;
            _cursorIndex = i;
        }
    }
    
    // check to see if motionValue has changed
    NSTimeInterval layerTime = lowestOverTime;
    selectedMotion = lowestOverMotion;
    
    // round to nearest (low or high)
    if ((timeValue-largestUnderTime) < (lowestOverTime-timeValue)) {
        layerTime = largestUnderTime;
        selectedMotion = largestUnderMotion;
        _cursorIndex--;
    }
    
    // we should track the chosen index as well
    
    if ( self.annotationLayer.motionValue != selectedMotion ) { // new value
        
        self.annotationLayer.motionValue = selectedMotion;
        
        //FPh_GraphData * checkMotion = [appDelegate.flightData.filteredData objectAtIndex:_cursorIndex];
        
        //convert layerTime back to point in view
        _scalex = self.bounds.size.width/([self.graphMaxTime floatValue]-[self.graphMinTime floatValue]);
        
        NSNumber * timeNumber = [ NSNumber numberWithDouble:layerTime - [self.graphMinTime doubleValue] ];
        
        CGPoint layerPoint = CGPointMake( [timeNumber floatValue] * _scalex, 0.0 );
        
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:0.0f]
                         forKey:kCATransactionAnimationDuration];
        self.annotationLayer.layer.position = layerPoint;
        //CGPointMake( self.bounds.origin.x + ratioX*self.bounds.size.width, self.bounds.origin.y + ratioY*self.bounds.size.height);
        [CATransaction commit];
        
        [ self calculateNoteLayerPositions: layerPoint.x ];
        
    } else {
        
    }
    
    return layerTime;
}

//-(NSTimeInterval) setCursorToTouchedPoint {
    
//    return [ self setCursorToPoint:self.touchPoint ];
    
//}

-(NSTimeInterval) calculateLayerTime:(BOOL)refreshRegardless {
    
    return [ self setCursorToPoint:self.touchPoint refreshRegardless:refreshRegardless];
    
}

-(void) calculateNoteLayerPositions :(float) xPointValue {
    
    if (self.annotationLayer.motionValue) {
        
        //NSNumber *sn = [NSNumber numberWithDouble: self.annotationLayer.motionValue.timestamp];
        
        //NSLog(@"calculateNoteLayerPositions at %4.2f - %5.3f", xPointValue, [sn floatValue]);
        
        NSTimeInterval delta = self.annotationLayer.motionValue.timestamp - [ self.graphMinTime doubleValue ];
        
        NSNumber * deltaNumber = [ NSNumber numberWithDouble:delta ];
        
        self.annotationLayer.timeSubLayer.seconds = delta;
        
        self.annotationLayer.timeSubLayer.timeString = [ NSString stringWithFormat:@"+%4.2f s", [ deltaNumber floatValue ] ];
        
        self.annotationLayer.annotationString = [ NSString stringWithFormat:@"+%4.2f s", [ deltaNumber floatValue ] ];
        
        [self.annotationLayer.timeSubLayer.layer setNeedsDisplay ];
        
        [ self.annotationLayer.layer setNeedsDisplay ];
        
        for (int i=0; i<self.partialGraphLayers.count; i++) {
            
            GraphLayer * pgLayer =  [self.partialGraphLayers objectAtIndex:i];
            
            [ pgLayer moveCursorTo:xPointValue motion:self.annotationLayer.motionValue ];
            
        }
        
    }
}

-(void) setMarkerAtCursor {
    
    if(self.annotationLayer.motionValue) {
        
        if(self.selectedGraphLayer) {
            
            [ self.selectedGraphLayer addAnnotationAt:self.annotationLayer.layer.position.x  motion:self.annotationLayer.motionValue ];
            
        } else {
            // go thru all layers
            for (int i=0; i<self.partialGraphLayers.count; i++) {
                GraphLayer * pgl = [self.partialGraphLayers objectAtIndex: i];
                [ pgl addAnnotationAt:self.annotationLayer.layer.position.x  motion:self.annotationLayer.motionValue ];
            }
        }
    }
    
    /*
     // where can we get these
     obj.annotation = @"Test-Annotation";
     obj.datatype = [NSNumber numberWithInt:0];
     obj.markDate = [NSDate date];
     obj.style = [NSNumber numberWithInt:0];
     obj.value = [NSNumber numberWithDouble:0.0];
     obj.timestamp = [NSNumber numberWithDouble:0.0];
     */
}

#pragma mark - crop views

-(void) showLeftCropView:(CGRect)rect {
    if (!self.cropLeftGrayView){
        self.cropLeftGrayView = [[ UIView alloc ] initWithFrame:rect ];
        self.cropLeftGrayView.backgroundColor = [ UIColor colorWithWhite:0.5 alpha:0.3 ];
        [self addSubview:self.cropLeftGrayView];
    } else {
        self.cropLeftGrayView.frame = rect;
    }
}

-(void) showRightCropView:(CGRect)rect{
    if (!self.cropRightGrayView){
        self.cropRightGrayView = [[ UIView alloc ] initWithFrame:rect ];
        self.cropRightGrayView.backgroundColor = [ UIColor colorWithWhite:0.5 alpha:0.3 ];
        [self addSubview:self.cropRightGrayView];
    } else {
        self.cropRightGrayView.frame = rect;
    }
}

-(void) removeCropViews {
    
    if (self.cropRightGrayView) {
        [self.cropRightGrayView removeFromSuperview];
        self.cropRightGrayView = nil;
    }
    if (self.cropLeftGrayView) {
        [self.cropLeftGrayView removeFromSuperview];
        self.cropLeftGrayView = nil;
    }
}

#pragma mark - cursor moving

-(void) cursorToNextPoint {
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //self.timeAtCursor = [ self calculateLayerTime: NO ];
    // this uses
    //NSTimeInterval timeValue  = [ self timeAtPoint:self.touchPoint ]; // for touch
    
    // we want current cursor point selection...
    _cursorIndex++;
    
    if (_cursorIndex < appDelegate.flightData.filteredData.count) {
        
        FPh_GraphData * nextPoint = [appDelegate.flightData.filteredData objectAtIndex:_cursorIndex];
        
        self.annotationLayer.motionValue = nextPoint;
        
        //convert layerTime back to point in view
        _scalex = self.bounds.size.width/([self.graphMaxTime floatValue]-[self.graphMinTime floatValue]);
        
        NSNumber * timeNumber = [ NSNumber numberWithDouble: nextPoint.timestamp - [self.graphMinTime doubleValue] ];
        
        CGPoint layerPoint = CGPointMake( [timeNumber floatValue] * _scalex, 0.0 );
        
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:0.0f]
                         forKey:kCATransactionAnimationDuration];
        self.annotationLayer.layer.position = layerPoint;
        //CGPointMake( self.bounds.origin.x + ratioX*self.bounds.size.width, self.bounds.origin.y + ratioY*self.bounds.size.height);
        [CATransaction commit];
        
        [ self calculateNoteLayerPositions: layerPoint.x ];
        
        
        
    } else {
        _cursorIndex = 0;
    }
}


#pragma mark - touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// taps are handled by the gesture handler
    if (touches.count == 2) {
        int index = 0;
        for (UITouch *touch in touches) {
            
            CGPoint locPoint = [touch locationInView:self];
            //CGPoint prevPoint = [touch previousLocationInView:self];
            
            if (index==0) {
                self.touchPoint_L = locPoint;
                _previousPoint_L = locPoint;
            } else {
                if (locPoint.x < self.touchPoint_L.x) {
                    self.touchPoint_R = self.touchPoint_L;
                    _previousPoint_R = _previousPoint_L;
                    self.touchPoint_L = locPoint;
                    _previousPoint_L = locPoint;
                } else {
                    self.touchPoint_R = locPoint;
                    _previousPoint_R = locPoint;
                }
            }
            index++;
        }
        
        // test if both points on selected graph
        
        _isTrackingLayerPinch = NO;// in case
        
        if(self.selectedGraphLayer) {
            
            //NSLog(@"bounds - %f %f %f %f", self.selectedGraphLayer.layer.bounds.origin.x, self.selectedGraphLayer.layer.bounds.origin.x,
            //      self.selectedGraphLayer.layer.bounds.size.width, self.selectedGraphLayer.layer.bounds.size.height);
            
            //NSLog(@"position - %f %f", self.selectedGraphLayer.layer.position.x, self.selectedGraphLayer.layer.position.y);
            //NSLog(@"anchorPoint - %f %f", self.selectedGraphLayer.layer.anchorPoint.x, self.selectedGraphLayer.layer.anchorPoint.y);
            
            //NSLog(@"self.touchPoint_R - %f %f", self.touchPoint_R.x, self.touchPoint_R.y);
            //NSLog(@"self.touchPoint_L - %f %f", self.touchPoint_L.x, self.touchPoint_L.y);
            
            if ( fabs(self.touchPoint_R.y - self.selectedGraphLayer.layer.position.y ) <= self.selectedGraphLayer.layer.bounds.size.height / 2.0)
            {
                if ( fabs(self.touchPoint_L.y - self.selectedGraphLayer.layer.position.y ) <= self.selectedGraphLayer.layer.bounds.size.height / 2.0)
                {
                    _isTrackingLayerPinch = YES;
                    _layerPinchOrigDeltaY = fabs(self.touchPoint_R.y - self.touchPoint_L.y);
                    _origStretchyBounds = self.selectedGraphLayer.layer.bounds;
                }
            }
        }
        
        if(!_isTrackingLayerPinch) {
            _isTrackingCrop = YES;
            
            CGRect lcRect = CGRectMake(self.bounds.origin.x,
                                       self.bounds.origin.y,
                                       self.touchPoint_L.x - self.bounds.origin.x,
                                       self.bounds.size.height);
            
            CGRect rcRect = CGRectMake(self.bounds.origin.x + self.touchPoint_R.x,
                                       self.bounds.origin.y,
                                       self.bounds.size.width - self.touchPoint_R.x + self.bounds.origin.x,
                                       self.bounds.size.height);
            
            [self showLeftCropView:lcRect];
            [self showRightCropView:rcRect];
            
            [ self hideCursor ];
            
            // notify to updateBarButtons
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_graph_bar_buttons_notification" object:nil userInfo:nil];
            
            //NSLog(@"double touch began: %6.2f %6.2f :: %6.2f %6.2f", self.touchPoint_L.x, self.touchPoint_L.y, self.touchPoint_R.x, self.touchPoint_R.y );
        }
    }
    else { // touches == 1
        
        UITouch *theTouch = [ [ event allTouches ] anyObject ];
        
        CGPoint tPoint = [ theTouch locationInView:self ];
        
        self.touchPoint = tPoint;
        
        // are we touching on the selected layer?
        //float halfHeight = self.selectedGraphLayer.layer.bounds.size.height / 2;
        if ( self.selectedGraphLayer
            && tPoint.y > self.selectedGraphLayer.layer.position.y - self.selectedGraphLayer.layer.bounds.size.height / 2
            && tPoint.y < self.selectedGraphLayer.layer.position.y + self.selectedGraphLayer.layer.bounds.size.height / 2){
            
            dragLayerInProgress = YES;
            
        } else { // update cursor
            
            self.timeAtCursor = [ self setCursorToPoint:self.touchPoint refreshRegardless:YES ];
            
            self.cursorIsShowing = YES;
        }
        
        [ self removeCropViews ];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_graph_bar_buttons_notification" object:nil userInfo:nil];
        
    }
}

//	touchesCancelled
///////////////////////////
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
    //for (UITouch *touch in touches) {
        
        //CGPoint locPoint = [touch locationInView:self];
        //CGPoint prevPoint = [touch previousLocationInView:self];
        
        //NSLog(@"touch cancelled: %6.2f %6.2f previous: %6.2f %6.2f", locPoint.x, locPoint.y, prevPoint.x, prevPoint.y );
        
    //}
    
    _isTrackingCrop = NO;
    _isTrackingLayerPinch = NO;
    dragLayerInProgress = NO;
}


//	touchesEnded
///////////////////////////
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//for (UITouch *touch in touches) {
        
        
        //CGPoint locPoint = [touch locationInView:self];
        //CGPoint prevPoint = [touch previousLocationInView:self];
        
        //NSLog(@"touch ended: %6.2f %6.2f previous: %6.2f %6.2f", locPoint.x, locPoint.y, prevPoint.x, prevPoint.y );
        
    //}
    
    _isTrackingCrop = NO;
    _isTrackingLayerPinch = NO;
    dragLayerInProgress = NO;
    
    //UITouch *theTouch = [ [ event allTouches ] anyObject ];
	//CGPoint lastLocation = [ theTouch locationInView:self ];
	//NSLog(@"touchesEnded");
    //[self setNeedsDisplay ];
    
    // double tap
    //for (UITouch *touch in touches) {
    //    if (touch.tapCount >= 2) {
    //        [self.superview bringSubviewToFront:self];
    //    }
    // }
}

//	touchesMoved
//////////////////////////
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_isTrackingLayerPinch) {
        //int ctr = 1;
        //NSLog( @"touches.count = %d", touches.count);
        for (UITouch *touch in touches) {
            
            CGPoint locPoint = [touch locationInView:self];
            CGPoint prevPoint = [touch previousLocationInView:self];
            
            // we need to track them correctly
            if ( prevPoint.x == _previousPoint_L.x && prevPoint.y == _previousPoint_L.y ) {
                _previousPoint_L = locPoint;
                self.touchPoint_L = locPoint; //pointInBounds;
                
            } else if ( prevPoint.x == _previousPoint_R.x && prevPoint.y == _previousPoint_R.y ) {
                _previousPoint_R = locPoint;
                self.touchPoint_R = locPoint; //pointInBounds;
                
            } else {
                //NSLog(@"touch not tracked!!!");
                //NSLog(@"layer pinch touch moved: %6.2f %6.2f %6.2f %6.2f  %6.2f %6.2f", prevPoint.x, prevPoint.y, self.touchPoint_L.x, self.touchPoint_L.y, self.touchPoint_R.x, self.touchPoint_R.y );
                return;
            }
            
        }
        
        float newdeltaY = fabs(_previousPoint_L.y - _previousPoint_R.y);
        
        NSNumber * pinchvalue = [ NSNumber numberWithFloat:(newdeltaY/_layerPinchOrigDeltaY) ];
        
        // this next step crashes from time to time when
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pinch_selected_layer" object:pinchvalue userInfo:nil];;
        
        
        //notify to animate the view ... tbi
        
        //NSLog(@"_isTrackingLayerPinch %4.2f ratio: %4.2f (%4.2f-%4.2f)", newdeltaY, newdeltaY / _layerPinchOrigDeltaY, _previousPoint_L.y, _previousPoint_R.y );
        //_layerPinchOrigDeltaY
        
    }
    
    else if (_isTrackingCrop) {
        
        for (UITouch *touch in touches) {
            
            CGPoint locPoint = [touch locationInView:self];
            CGPoint prevPoint = [touch previousLocationInView:self];
            
            BOOL oobl = locPoint.x < self.bounds.origin.x;
            BOOL oobr = locPoint.x > self.bounds.origin.x + self.bounds.size.width;
            //BOOL prevOOBL = prevPoint.x < self.bounds.origin.x;
            //BOOL prevOOBR = prevPoint.x > self.bounds.origin.x + self.bounds.size.width;
            
            CGPoint pointInBounds = locPoint;
            if(oobl){
                pointInBounds.x = self.bounds.origin.x;
            }
            if(oobr){
                pointInBounds.x = self.bounds.origin.x + self.bounds.size.width;
            }
            
            if ( prevPoint.x == _previousPoint_L.x && prevPoint.y == _previousPoint_L.y ) {
                _previousPoint_L = locPoint;
                self.touchPoint_L = pointInBounds;
                
            } else if ( prevPoint.x == _previousPoint_R.x && prevPoint.y == _previousPoint_R.y ) {
                _previousPoint_R = locPoint;
                self.touchPoint_R = pointInBounds;
                
            } else {
                //NSLog(@"touch not tracked!!!");
                //NSLog(@"crop touch moved: %6.2f %6.2f %6.2f %6.2f  %6.2f %6.2f", prevPoint.x, prevPoint.y, self.touchPoint_L.x, self.touchPoint_L.y, self.touchPoint_R.x, self.touchPoint_R.y );
                return;
            }
            
            // update the cropping layers...
            CGRect lcRect = CGRectMake(self.bounds.origin.x,
                                       self.bounds.origin.y,
                                       self.touchPoint_L.x - self.bounds.origin.x,
                                       self.bounds.size.height);
            
            CGRect rcRect = CGRectMake(self.bounds.origin.x + self.touchPoint_R.x,
                                       self.bounds.origin.y,
                                       self.bounds.size.width - self.touchPoint_R.x + self.bounds.origin.x,
                                       self.bounds.size.height);
            
            [self showLeftCropView:lcRect];
            [self showRightCropView:rcRect];
            
        }
    } else { // single touch, where double
        
        UITouch *touch = [ [ event allTouches ] anyObject ];
        
        self.touchPoint = [ touch locationInView:self ];
        
        //[self setNeedsDisplay];
        
        if (dragLayerInProgress) {
            
            self.selectedGraphLayer.layer.position = CGPointMake ( self.selectedGraphLayer.layer.position.x, self.touchPoint.y ) ;
            
        } else {
            
            self.timeAtCursor = [ self calculateLayerTime: NO ];
            
            [ self dragCursorToPoint:self.touchPoint ];
            
        }
        
    }
    
    /*//convert layerTime back to point in view
     CGPoint layerPoint = CGPointMake(( layerTime-[self.graphMinTime floatValue] ) * _scalex, self.bounds.size.height/2);//touchPoint.x
     
     [CATransaction begin];
     [CATransaction setValue:[NSNumber numberWithFloat:0.0f]
     forKey:kCATransactionAnimationDuration];
     self.annotationLayer.layer.position = layerPoint;
     //CGPointMake( self.bounds.origin.x + ratioX*self.bounds.size.width, self.bounds.origin.y + ratioY*self.bounds.size.height);
     [CATransaction commit];
     */
}

//- (void)cacheBeginPointForTouches:(NSSet *)touches
//{
//    if ([touches count] > 0) {
//        for (UITouch *touch in touches) {
//            CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
//            if (point == NULL) {
//                point = (CGPoint *)malloc(sizeof(CGPoint));
//                CFDictionarySetValue(touchBeginPoints, touch, point);
//            }
//            *point = [touch locationInView:view.superview];
//        }
//    }
//}

#pragma mark - notifications
-(void) pinchSelectedLayerNote :(NSNotification*) notif {
    
    NSNumber * scale = (NSNumber *) notif.object;
    
    //NSLog(@"pinchSelectedLayerNote %4.2f", [scale floatValue]);
    
    // cache stretchy bounds
    //_origStretchyBounds
    
    self.selectedGraphLayer.layer.bounds = CGRectMake(_origStretchyBounds.origin.x, _origStretchyBounds.origin.y,
                                                      _origStretchyBounds.size.width, _origStretchyBounds.size.height*[scale floatValue]);
    
    //GraphLayer * pgl = self.selectedGraphLayer;
    //[pgl autoScaleData];
    //[pgl resetSubAnnotationPositions];
}


#pragma mark - Drawing
/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor ( context, [ UIColor redColor ].CGColor );
    
    CGContextMoveToPoint(context, self.bounds.origin.x, self.touchPoint.y);
    CGContextAddLineToPoint(context, self.bounds.origin.x+self.bounds.size.width, self.touchPoint.y);
    
    CGContextMoveToPoint(context, self.touchPoint.x, self.bounds.origin.y );
    CGContextAddLineToPoint(context, self.touchPoint.x, self.bounds.origin.y+self.bounds.size.height);
    
    CGContextStrokePath(context);
    //CGContextFillRect(context, rect);
    //CGRect brectum = self.bounds;
    //CGRect frectum = self.frame;
    //CGPoint prectum = self.position;
    
//    [self initGraphLayers];
    
    //[ self drawGraphinContext:context rect:rect ];
    //NSLog(@"FPh_GraphView : drawRect");
}
*/

- (UIImage *)takeScreenshot:(UIView*)yourView
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [yourView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

/*-(UIImage *)createGraphImage { // unused
 
 CGRect framedRect = self.graphRect;//CGRectMake(0, 0, 200.0, 200.0);
 
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 
 CGContextRef context = CGBitmapContextCreate(nil, framedRect.size.width, framedRect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
 
 //CGContextTranslateCTM(context, 200, 200);
 //CGAffineTransform CGContextGetCTM ( CGContextRef c  );
 CGContextTranslateCTM( context, 0, (float)(framedRect.size.height) );
 CGContextScaleCTM( context, 1.0, -1.0 );
 
 [ self drawGraphinContext:context rect:framedRect ];
 
 // do layers too
 [ self.annotationLayer drawLayer:self.annotationLayer.layer inContext:context ];
 
 for (int i=0; i<[ self.partialGraphLayers count ]; i++) {
 GraphLayer * pgLayer = [ self.partialGraphLayers objectAtIndex:i];
 [pgLayer drawLayer:pgLayer.layer inContext:context ];
 }
 
 CGImageRef theCGImage = CGBitmapContextCreateImage(context);
 
 UIImage *theUIImage = [UIImage imageWithCGImage:theCGImage];
 
 CGImageRelease(theCGImage);
 
 CGContextRelease(context);
 
 CGColorSpaceRelease(colorSpace);
 
 return theUIImage;
 
 // Draw with white round strokes
 CGContextSetLineCap(context, kCGLineCapRound);
 CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
 CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
 CGContextSetLineWidth(context, 1.0);
 
 CGContextClearRect(context, framedRect );
 CGContextStrokeRect (context, framedRect );
 
 float w, h;
 w = 200.0;
 h = 200.0;
 
 //CGAffineTransform myTextTransform; //2
 //CGContextSelectFont (context,"Helvetica-Bold",24.0,kCGEncodingMacRoman);
 //CGContextSetCharacterSpacing (context, 10); // 4
 
 CGContextSetTextDrawingMode (context, kCGTextFill); //kCGTextFillStroke
 
 CGContextSetRGBFillColor (context, 0, 0, 0, .5); // 6
 CGContextSetRGBStrokeColor (context, 0, 0, 0, 1); // 7
 //myTextTransform =  CGAffineTransformMakeRotation  (0.75); // 8
 //CGContextSetTextMatrix (context, myTextTransform); // 9
 
 //CGRect textRect = CGRectMake(20.0, 168.0, 160.0, 24.0);
 
 //[ self drawAdaptiveText:self.visTeam.teamname rect:textRect context:context ];
 
 //textRect = CGRectMake(20.0, 136.0, 160.0, 24.0);
 //[ self drawAdaptiveText:self.homeTeam.teamname rect:textRect context:context ];
 
 //NSString * dateString = [ dateFormatter stringFromDate:self.dateandtime ];
 //NSString * timeString = [ timeFormatter stringFromDate:self.dateandtime ];
 
 //textRect = CGRectMake(20.0, 102.0, 160.0, 24.0);
 //[ self drawAdaptiveText:dateString rect:textRect context:context ];
 
 //textRect = CGRectMake(20.0, 80.0, 160.0, 24.0);
 //[ self drawAdaptiveText:timeString rect:textRect context:context ];
 
 NSString * inningString;
 switch ([ self.inningStatus intValue ]) {
 case -1:
 inningString = @"Final";
 break;
 case 0:
 inningString = @"Scheduled";
 break;
 case 1:
 inningString = @"1st";
 break;
 case 2:
 inningString = @"2nd";
 break;
 case 3:
 inningString = @"3rd";
 break;
 default:
 inningString = [ NSString stringWithFormat: @"%dth", [ self.inningStatus intValue ] ];
 break;
 }
 
 if ( [ self.inningStatus intValue ] >= 1 ) {
 if ( self.currentAtBat.gameScore.isBottom ) {
 inningString = [ NSString stringWithFormat : @"bot %@", inningString ];
 } else {
 inningString = [ NSString stringWithFormat : @"top %@", inningString ];
 }
 }
 
 textRect = CGRectMake(100.0, 20.0, 80.0, 36.0);
 [ self drawAdaptiveText:inningString rect:textRect context:context ];
 
 const CGFloat line[8*4] = {
 15.0, 6.0, 15.0, 4.0,
 15.0,24.0, 15.0,26.0,
 6.0,15.0,  4.0,15.0,
 24.0,15.0, 26.0,15.0,
 21.5,21.5, 23.0,23.0,
 8.5, 8.5,  7.0, 7.0,
 21.5, 8.5, 23.0, 7.0,
 8.5,21.5,  7.0,23.0,
 };
 
 // A circle with eight rays around it
 CGContextStrokeEllipseInRect(context, CGRectMake(10.5, 10.5, 9.0, 9.0));
 for (int i = 0; i < 8; i++)
 {
 CGContextMoveToPoint(context, line[i*4+0], line[i*4+1]);
 CGContextAddLineToPoint(context, line[i*4+2], line[i*4+3]);
 CGContextStrokePath(context);
 }
 
 }*/



@end
