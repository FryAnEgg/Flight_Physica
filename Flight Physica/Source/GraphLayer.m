//
//  GraphLayer.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "GraphLayer.h"
#import "FPh_GraphData.h"
#import "FPh_AppDelegate.h"

@implementation GraphLayer

@synthesize layer = _layer;
@synthesize lineColor = _lineColor;
@synthesize lineWidth, typeIndex;
@synthesize graphMinTime = _graphMinTime;
@synthesize graphMaxTime = _graphMaxTime;
@synthesize isSelected = _isSelected;
@synthesize legendValue = _legendValue;
@synthesize annoString = _annoString;
@synthesize longString = _longString;
@synthesize scaley = _scaley;
@synthesize zeroPointY = _zeroPointY;
@synthesize subAnnotations = _subAnnotations;
@synthesize cursorLayer = _cursorLayer;

-(id) initWithLineIndex : (int) index {
	
    self = [ super init ];
    
	if ( self != nil )
	{
        self.typeIndex = index;
        self.layer = [ [CALayer alloc] init];
        self.layer.delegate = self;
        self.layer.cornerRadius = 100.0;
        self.layer.backgroundColor = [ UIColor clearColor ].CGColor;
        
        //self.subLayers = [NSMutableArray arrayWithCapacity:4];
        
        self.scaley = -256;
        self.zeroPointY = 0.0;
        self.subAnnotations = [ NSMutableArray array ];
        
        self.cursorLayer = [[TextAnnotationLayer alloc] initWithType:index showIndicator:NO offset:CGPointMake(125., 0.)];
        
        self.cursorLayer.layer.position = CGPointMake(0.0, 0.0);
        [ self.layer addSublayer : self.cursorLayer.layer ];
        
        //NSArray * array = [ UIFont familyNames ];
        //for (int i=0; i<[array count]; i++) {
        //    NSLog(@" %d %@", i, [array objectAtIndex:i]);
        //}
        
    }
    return self;
}

-(void) addAnnotationAt:(float)xPointValue motion:(FPh_GraphData*)motion {
    
    double yValue = [ self getLayerYValue:motion ];
    // create layer and add as sublayer
    
    TextAnnotationLayer * newAnno = [[TextAnnotationLayer alloc] initWithType:typeIndex showIndicator:NO offset:CGPointMake(0., -64.)];
    
    newAnno.layer.position = CGPointMake(xPointValue, yValue * self.scaley + self.zeroPointY);
    newAnno.color = self.lineColor;
    newAnno.valueString = [NSString stringWithFormat:@"%6.3f", yValue];
    newAnno.annotationString = @""; //self.annoString;
    newAnno.motionValue = motion;
    newAnno.timeStamp = motion.timestamp;
    newAnno.yValue = yValue;
    
    [self.subAnnotations addObject:newAnno];
    [ self.layer addSublayer : newAnno.layer ];
    [ newAnno.layer setNeedsDisplay ];
    
    // notify to add to document
    [[NSNotificationCenter defaultCenter] postNotificationName:@"add_graph_marker" object:newAnno userInfo:nil];
    
}

-(void) removeSubAnnotations {
    
    for ( int i=0; i<self.subAnnotations.count; i++) { // remove layer
        TextAnnotationLayer * tLayer = [self.subAnnotations objectAtIndex:i];
        [tLayer.layer removeFromSuperlayer];
    }
    [self.subAnnotations removeAllObjects];
}

-(void) resetSubAnnotationPositions {
    
    for ( int i=0; i<self.subAnnotations.count; i++) { // remove layer
        TextAnnotationLayer * tLayer = [self.subAnnotations objectAtIndex:i];
        
        if (tLayer.motionValue) {
            
            double yValue = [ self getLayerYValue:tLayer.motionValue ];
            NSTimeInterval layerTime = tLayer.motionValue.timestamp; // can we save this elsehow
            
            //convert layerTime back to point in view
            float scalex = self.layer.bounds.size.width/([self.graphMaxTime floatValue]-[self.graphMinTime floatValue]);
            CGPoint graphPoint = CGPointMake(( layerTime-[self.graphMinTime floatValue] ) * scalex, yValue * self.scaley + self.zeroPointY );
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:0.0f] forKey:kCATransactionAnimationDuration];
            tLayer.layer.position = graphPoint;
            [CATransaction commit];
            
            
        } else {
            //NSLog(@"!tLayer.motionValue");
            //convert layerTime back to point in view
            float scalex = self.layer.bounds.size.width/([self.graphMaxTime floatValue]-[self.graphMinTime floatValue]);
            CGPoint graphPoint = CGPointMake(( tLayer.timeStamp-[self.graphMinTime doubleValue] ) * scalex, tLayer.yValue * self.scaley + self.zeroPointY );
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:0.0f] forKey:kCATransactionAnimationDuration];
            tLayer.layer.position = graphPoint;
            [CATransaction commit];
        }
        //CGPoint graphPoint = CGPointZero; //CGPointMake(xPointValue, yValue * self.scaley + self.zeroPointY);
        
    }
}

-(double) getLayerYValue:(FPh_GraphData *) motionPoint {
    
    double yValue = 0.0;
    
    switch (self.legendValue) {
        case kLegend_Accel_x:
            yValue = motionPoint.accx;
            break;
        case kLegend_Accel_y:
            yValue = motionPoint.accy;
            break;
        case kLegend_Accel_z:
            yValue = motionPoint.accz;
            break;
        case kLegend_Attitude_Roll:
            yValue = RTOD*motionPoint.attRoll;
            break;
        case kLegend_Attitude_Pitch:
            yValue = RTOD*motionPoint.attPitch;
            break;
        case kLegend_Attitude_Yaw:
            yValue = RTOD*motionPoint.attYaw;
            break;
        case kLegend_Rotation_x:
            yValue = motionPoint.rotx;
            break;
        case kLegend_Rotation_y:
            yValue = motionPoint.roty;
            break;
        case kLegend_Rotation_z:
            yValue = motionPoint.rotz;
            break;
        case kLegend_Heading:
            yValue = 0;//motionPoint.heading;
            break;
        case kLegend_Gravity_x:
            yValue = motionPoint.gravx;
            break;
        case kLegend_Gravity_y:
            yValue = motionPoint.gravy;
            break;
        case kLegend_Gravity_z:
            yValue = motionPoint.gravz;
            break;
        default:
            break;
    };
    
    return yValue;
    
}

-(NSString*) unitString {
    NSString* retString = @"";;
    switch (self.legendValue) {
        case kLegend_Accel_x:
        case kLegend_Accel_y:
        case kLegend_Accel_z:
            retString = @"m/s2";
            break;
        case kLegend_Attitude_Roll:
        case kLegend_Attitude_Pitch:
        case kLegend_Attitude_Yaw:
            retString = @"°";
            break;
        case kLegend_Rotation_x:
        case kLegend_Rotation_y:
        case kLegend_Rotation_z:
            retString = @"°/s";
            break;
        case kLegend_Heading:
            retString = @"°";
            break;
        case kLegend_Gravity_x:
        case kLegend_Gravity_y:
        case kLegend_Gravity_z:
            retString = @"m/s2";
            break;
        default:
            break;
    };
    return retString;
}

-(void) setLegendValue:(int)legendValue {
    _legendValue = legendValue;
    switch (self.legendValue) {
        case kLegend_Accel_x:
            unitsString = @"";
            self.annoString = @"acc.x";
            self.longString = NSLocalizedString(@"Acceleration x", @"");
            break;
        case kLegend_Accel_y:
            unitsString = @"";
            self.annoString = @"acc.y";
            self.longString = NSLocalizedString(@"Acceleration y", @"");
            break;
        case kLegend_Accel_z:
            unitsString = @"";
            self.annoString = @"acc.z";
            self.longString = NSLocalizedString(@"Acceleration z", @"");
            break;
        case kLegend_Attitude_Roll:
            unitsString = @"°";
            self.annoString = @"roll";
            self.longString = NSLocalizedString(@"Attitude Roll", @"");
            break;
        case kLegend_Attitude_Pitch:
            unitsString = @"°";
            self.annoString = @"pitch";
            self.longString = NSLocalizedString(@"Attitude Pitch", @"");
            break;
        case kLegend_Attitude_Yaw:
            unitsString = @"°";
            self.annoString = @"yaw";
            self.longString = NSLocalizedString(@"Attitude Yaw", @"");
            break;
        case kLegend_Rotation_x:
            unitsString = @"°/s";
            self.annoString = @"rot.x";
            self.longString = NSLocalizedString(@"Rotation X", @"");
            break;
        case kLegend_Rotation_y:
            unitsString = @"°/s";
            self.annoString = @"rot.y";
            self.longString = NSLocalizedString(@"Rotation Y", @"");
            break;
        case kLegend_Rotation_z:
            unitsString = @"°/s";
            self.annoString = @"rot.z";
            self.longString = NSLocalizedString(@"Rotation Z", @"");
            break;
        case kLegend_Heading:
            self.annoString = @"head";
            self.longString = NSLocalizedString(@"Heading", @"");
            break;
        case kLegend_Gravity_x:
            unitsString = @"";
            self.annoString = @"grav.x";
            self.longString = NSLocalizedString(@"Gravity X", @"");
            break;
        case kLegend_Gravity_y:
            unitsString = @"";
            self.annoString = @"grav.y";
            self.longString = NSLocalizedString(@"Gravity Y", @"");
            break;
        case kLegend_Gravity_z:
            unitsString = @"";
            self.annoString = @"grav.z";
            self.longString = NSLocalizedString(@"Gravity Z", @"");
            break;
        default:
            break;
    }
}
-(void) autoScaleData {
    
    double yMin = -1000.0;
    double yMax = 1000.0;
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    for (int j=0; j<[appDelegate.flightData.filteredData count]; j++) {
        
        FPh_GraphData * motionPoint = [appDelegate.flightData.filteredData objectAtIndex:j];
        
        double yValue = [ self getLayerYValue:motionPoint ];
        
        if(j==0){
            yMin=yValue;
            yMax=yValue;
        }
        if (yValue<yMin) {
            yMin=yValue;
        }
        if (yValue>yMax) {
            yMax=yValue;
        }
    }
    
    if( yMin > 0.0 ) {
        yMin = 0.0;
    }
    if( yMax < 0.0 ) {
        yMax = 0.0;
    }
    
    double yRange = yMax-yMin;
    
    self.scaley = - ( [[NSNumber numberWithFloat:self.layer.bounds.size.height-10.0 ] doubleValue] ) / yRange;
    
    self.zeroPointY = - (self.scaley * yMax)+5.0;
    
}

-(void) moveCursorTo:(float)xPointValue motion:(FPh_GraphData*)motion {
    
    double yValue = [ self getLayerYValue:motion ];
    
    //NSTimeInterval stamp = motion.timestamp;
    //NSNumber * stampNumber = [NSNumber numberWithDouble:stamp ];
    
    CGPoint graphPoint = CGPointMake(xPointValue, yValue * self.scaley + self.zeroPointY);
    //CGPoint graphPointIndica = CGPointMake(xPointValue, yValue * self.scaley + self.zeroPointY -250.0);
    
    // set color and text
    self.cursorLayer.color = self.lineColor;
    if( self.legendValue == kLegend_Attitude_Roll ){
        
    }
    self.cursorLayer.valueString = [NSString stringWithFormat:@"%6.3f", yValue];//, unitsString
    self.cursorLayer.annotationString = self.annoString;//[NSString stringWithFormat:@"%6.3f", yValue];
    [ self.cursorLayer.layer setNeedsDisplay ];
    
    //////////////////////////////////
    // set and display attitude layer
    
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.0f]
                     forKey:kCATransactionAnimationDuration];
    
    self.cursorLayer.layer.position = graphPoint;
    
    if ( self.cursorLayer.valueDisplayIndicator && (self.legendValue == kLegend_Attitude_Roll || self.legendValue == kLegend_Attitude_Pitch)) {
        CATransform3D transform;
        self.cursorLayer.valueDisplayIndicator.attitudeRoll = motion.attRoll;
        self.cursorLayer.valueDisplayIndicator.attitudePitch = motion.attPitch;
        self.cursorLayer.valueDisplayIndicator.attitudeHeading = motion.attYaw;
        
        
        if ( self.legendValue == kLegend_Attitude_Roll ) {
            transform = CATransform3DRotate( CATransform3DIdentity, self.cursorLayer.valueDisplayIndicator.attitudeRoll, 0, 0, 1.0);
        } else if ( self.legendValue == kLegend_Attitude_Pitch ){
            transform = CATransform3DRotate( CATransform3DIdentity, -self.cursorLayer.valueDisplayIndicator.attitudePitch, 0, 0, 1.0);
        }
        self.cursorLayer.valueDisplayIndicator.layer.transform = transform;
    }
    
    //self.valueDisplayIndicator.bglayer.position = graphPointIndica; // track
    //self.valueDisplayIndicator.layer.position = graphPointIndica; // track
    ////////////////////
    
    // set self.pitchLayer.layer.position too for
    // dynamic cursor positioning ...
    // should  attach self.attitudeLayer to roll partial graph
    // should  attach self.pitchLayer to pitch partial graph
    
    [CATransaction commit];
    
}

-(void) showCursor{
    
}

-(void) hideCursor{
    // maybe do opacity...
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.0f] forKey:kCATransactionAnimationDuration];
    self.cursorLayer.layer.position = CGPointMake(-200.0,0.0);
    [CATransaction commit];
}

#pragma mark drawing
//////////////////////////////
-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //NSLog(@"layer.frame = %4.2f %4.2f %4.2f %4.2f", l.frame.origin.x, l.frame.origin.y, l.frame.size.width, l.frame.size.height);
    
    if(self.isSelected){
         
        CGContextSetStrokeColorWithColor ( context, [UIColor blueColor].CGColor );
        
        CGContextStrokeRectWithWidth( context, self.layer.bounds, [self.lineWidth floatValue]);
        
        float gridSize = 100.0;
        float nextLine = 0.0;
        while ( nextLine < self.layer.bounds.size.width) {
            CGContextSetLineWidth(context, 3.0);
            CGContextMoveToPoint(context, nextLine, 0.0);
            CGContextAddLineToPoint(context, nextLine, l.bounds.size.height);
            CGContextStrokePath(context);
            
            nextLine+=gridSize;
        }
        
        nextLine = 0.0;
        while ( nextLine < self.layer.bounds.size.height) {
            CGContextMoveToPoint(context, 0.0, nextLine );
            CGContextAddLineToPoint(context, l.bounds.size.width, nextLine);
            CGContextStrokePath(context);
            
            nextLine+=gridSize;
        }
    }
    
    float scalex = l.bounds.size.width/([self.graphMaxTime floatValue]-[self.graphMinTime floatValue]);
    
    // we need scale and shiftx
    NSTimeInterval oldStamp = 0.0;
    
    //flip it
    //CGContextScaleCTM(context, 1.0, -1.0);
    
    BOOL bFirstPointDrawn = NO;
    
    int  drawCycleLimit = 100;
    int  drawCycleCount = -1;
    
    // draw zero base line
    CGContextSetStrokeColorWithColor ( context, self.lineColor.CGColor );
    CGContextSetLineWidth(context, 3.0);
    CGContextMoveToPoint(context, 0.0, self.zeroPointY );
    CGContextAddLineToPoint( context, l.bounds.size.width, self.zeroPointY );
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor ( context, self.lineColor.CGColor );
    
    //NSLog(@"[appDelegate.flightData.filteredData count] = %d",[appDelegate.flightData.filteredData count]);
    
    if ([appDelegate.flightData.filteredData count] == 0) {
        //    show fetching graphic
        // or could just be empty ...
        NSString * string = NSLocalizedString(@"fetching...", @"");
        CGContextSetFillColorWithColor ( context, [ UIColor grayColor ].CGColor );
        UIFont * theFont =  [ UIFont fontWithName:@"Helvetica" size:128.0 ];
        CGSize sSize = [ string sizeWithFont:theFont ];
        
        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
        CGContextSelectFont(context, "Helvetica", 128.0, kCGEncodingMacRoman);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        
        CGContextShowTextAtPoint(context, l.bounds.size.width / 2 - sSize.width/2 , l.bounds.size.height - 25 , [ string UTF8String ], [ string length ] );
        //
    } else {
        
        for (int j=0; j<[appDelegate.flightData.filteredData count]; j++) {
            
            drawCycleCount++;
            
            FPh_GraphData * motionPoint = [appDelegate.flightData.filteredData objectAtIndex:j];
            
            NSTimeInterval stamp = motionPoint.timestamp;
            
            if (oldStamp>stamp) {
                NSLog(@"oldStamp>stamp");
            }
            oldStamp = stamp;
            
            //NSNumber * stampNumber = [NSNumber numberWithDouble:stamp ];
            
            if ( stamp < [self.graphMinTime doubleValue]) {
                continue;
            }
            if ( stamp > [self.graphMaxTime doubleValue]) {
                continue;
            }
            
            double yValue = [ self getLayerYValue: motionPoint ];
            
            double graphYValue = yValue * self.scaley + self.zeroPointY;
            
            CGPoint graphPoint = CGPointMake( (stamp-[self.graphMinTime doubleValue]) * scalex, graphYValue );
            
            if (bFirstPointDrawn==NO) {
                CGContextMoveToPoint(context, graphPoint.x, graphPoint.y );
                bFirstPointDrawn = YES;
            } else {
                CGContextAddLineToPoint( context, graphPoint.x, graphPoint.y );
            }
            
            if (drawCycleCount >= drawCycleLimit) {
                drawCycleCount = -1;
                if(self.isSelected){
                    CGContextSetLineWidth(context, 2*[self.lineWidth floatValue]);
                } else {
                    CGContextSetLineWidth(context, [self.lineWidth floatValue]);
                }
                CGContextStrokePath(context);
                CGContextMoveToPoint(context, graphPoint.x, graphPoint.y );
            }
        }
        
        if(self.isSelected){
            CGContextSetLineWidth(context, 2*[self.lineWidth floatValue]);
        } else {
            CGContextSetLineWidth(context, [self.lineWidth floatValue]);
        }
        CGContextStrokePath(context);
    }
}

@end

