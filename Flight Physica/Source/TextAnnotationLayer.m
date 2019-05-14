//
//  TextAnnotationLayer.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "TextAnnotationLayer.h"

@implementation TextAnnotationLayer

@synthesize layer = _layer;
@synthesize valueDisplayIndicator = _valueDisplayIndicator;
@synthesize annotationType=_annotationType;
@synthesize yValue=_yValue;
@synthesize annotationString = _annotationString;
@synthesize valueString = _valueString;
@synthesize titleString = _titleString;
@synthesize color = _color;
@synthesize motionValue = _motionValue;
@synthesize timeStamp;

@synthesize labelOffset = _labelOffset;

-(id)  initWithType: (int) type showIndicator:(BOOL)showIndicator offset:(CGPoint)offset{
	
    // can we do a different class for
    self.annotationType = type;
    // cursor tracking and annotation layer?
    
    self = [ super init ];
    
	if ( self != nil )
	{
        self.labelOffset = offset;
        self.layer = [ [CALayer alloc] init];
        self.layer.delegate = self;
        
        // set the size here ...
        self.layer.bounds = CGRectMake(0.0, 0.0, 300.0, 210.0);
        if(offset.x > offset.y){
            if (offset.y < 0) { // top
                self.layer.anchorPoint = CGPointMake(0.5, 0.93);
            } else {// for 125,0 right
                self.layer.anchorPoint = CGPointMake(0.05, 0.5);
            }
        } else if (offset.y > 0) { // for 0,100 bottom
            self.layer.anchorPoint = CGPointMake(0.5, 0.07);
        } else { // left
            self.layer.anchorPoint = CGPointMake(0.95, 0.5);
        }
        
        
        self.layer.position = CGPointMake(0.0, 0.0);
        //self.layer.cornerRadius = 100.0;
        self.layer.backgroundColor = [ UIColor clearColor ].CGColor;
        
        if ( showIndicator && (type == kLegend_Attitude_Roll || type == kLegend_Attitude_Pitch) ) {
            // AttitudeDisplayLayer (ROLL)
            self.valueDisplayIndicator = [[ AttitudeDisplayLayer alloc] init];
            self.valueDisplayIndicator.attitudeMode = type;
            CGPoint layerPoint = CGPointMake(self.layer.bounds.size.width, self.layer.bounds.size.height/2.);//(frame.size.width/4.0, frame.size.height/4.0);
            // bgLayer
            self.valueDisplayIndicator.bglayer.position = layerPoint;
            [self.layer addSublayer:self.valueDisplayIndicator.bglayer];
            [self.valueDisplayIndicator.bglayer setNeedsDisplay];
            //layer
            self.valueDisplayIndicator.layer.position = layerPoint;
            [self.layer addSublayer:self.valueDisplayIndicator.layer];
            [self.valueDisplayIndicator.layer setNeedsDisplay];
        }
    }
    return self;
}

#pragma mark drawing
//////////////////////////////
-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    // each visible line should have a text sublayer
    
    //NSLog(@" layer at %f %f %f %f", l.frame.origin.x, l.frame.origin.y, l.frame.size.width, l.frame.size.height);
    //NSLog(@" layer bounds %f %f %f %f", l.bounds.origin.x, l.bounds.origin.y, l.bounds.size.width, l.bounds.size.height);
    //NSLog(@" layer position %f %f ", l.position.x, l.position.y);
    //NSLog(@" self position %f %f ", self.layer.position.x, self.layer.position.y);
    //NSLog(@" anchorPoint %f %f ", self.layer.anchorPoint.x, self.layer.anchorPoint.y);
    
    float pi_x_2 = 3.1415926535*2;
    
    CGContextSetStrokeColorWithColor ( context, self.color.CGColor );
    
    CGContextSetFillColorWithColor ( context, [UIColor colorWithWhite:1.0 alpha:0.5].CGColor );
    
    
    //CGContextFillRect ( context, l.bounds );
    //CGContextStrokeRect ( context, l.bounds );
    
    // center point on graph layer
    // will depend on
    //l.anchorPoint
    
    // this is solution for 0.5,0.5
    CGPoint centerPoint = CGPointMake(l.bounds.origin.x+(l.bounds.size.width*self.layer.anchorPoint.x) ,
                                      l.bounds.origin.y+(l.bounds.size.height*self.layer.anchorPoint.y));
    
    CGContextSetLineWidth(context, 3.0);
    
    //white circle
    CGContextAddArc  ( context, centerPoint.x, centerPoint.y,  10.0, 0, pi_x_2, 1 );
    CGContextSetFillColorWithColor ( context, [UIColor colorWithWhite:1.0 alpha:0.5].CGColor );
    CGContextFillPath(context);
    // stroke circle
    CGContextAddArc  ( context, centerPoint.x, centerPoint.y,  10.0, 0, pi_x_2, 1 );
    CGContextStrokePath(context);
    
    /*//pointer
     CGContextBeginPath( context );
     CGContextMoveToPoint(context, centerPoint.x , centerPoint.y);
     CGContextAddLineToPoint(context, centerPoint.x -50 , centerPoint.y -86.60254);
     CGContextAddLineToPoint(context, centerPoint.x + 50, centerPoint.y-86.60254);
     CGContextAddLineToPoint(context, centerPoint.x , centerPoint.y);
     CGContextStrokePath(context);
     */
    
    // draw the text
    //CGContextSetLineWidth(context, 3.0);
    
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0)); //Helvetica
    CGContextSelectFont(context, "Helvetica", 64.0, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    UIFont * theFont =  [ UIFont fontWithName:@"Helvetica" size:64.0 ];
    
    //self.labelOffset = CGPointMake(125., 0.);// should depend on orientation ...
    
    BOOL bShowAnnoString = self.annotationString.length > 0;
    
    if ( bShowAnnoString ){
        
        CGSize sSize = [ self.annotationString sizeWithFont:theFont ];
        CGPoint annoPoint = CGPointMake(centerPoint.x + self.labelOffset.x - sSize.width/2, centerPoint.y + self.labelOffset.y + sSize.height/2 -48.); //
        
        CGSize sSize2 = [ self.valueString sizeWithFont:theFont ];
        CGPoint valPoint = CGPointMake(centerPoint.x + self.labelOffset.x - sSize2.width/2, centerPoint.y + self.labelOffset.y + sSize2.height/2 + 16.); //
        
        CGRect textFrame = CGRectMake(annoPoint.x-2., annoPoint.y-52.0, sSize.width+4., 124.0);
        if( valPoint.x < annoPoint.x ) {
            textFrame.origin.x = valPoint.x-2.;
            textFrame.size.width = sSize2.width+4.;
        }
        
        CGContextFillRect ( context, textFrame );
        CGContextStrokeRect ( context, textFrame );
        
        CGContextSetFillColorWithColor ( context, self.color.CGColor );
        CGContextShowTextAtPoint(context, annoPoint.x, annoPoint.y, [ self.annotationString UTF8String ], [self.annotationString length ] );
        CGContextShowTextAtPoint(context, valPoint.x, valPoint.y, [ self.valueString UTF8String ], [self.valueString length ] );
        
    } else {
        //NSLog(@"°°°not showing the data type label°°°");
        CGSize sSize2 = [ self.valueString sizeWithFont:theFont ];
        CGPoint valPoint = CGPointMake(centerPoint.x + self.labelOffset.x - sSize2.width/2, centerPoint.y + self.labelOffset.y + sSize2.height/2 -16.); //
        
        CGRect textFrame = CGRectMake(valPoint.x-2., valPoint.y-54.0, sSize2.width+4., 64.0);
        
        CGContextFillRect ( context, textFrame );
        CGContextStrokeRect ( context, textFrame );
        
        CGContextSetFillColorWithColor ( context, self.color.CGColor );
        CGContextShowTextAtPoint(context, valPoint.x, valPoint.y, [ self.valueString UTF8String ], [self.valueString length ] );
    }
    
    //CGContextScaleCTM (context, 1.0,-1.0);
    //CGContextTranslateCTM (context, 0.0, -l.bounds.size.height);
    
    //CGRect imageRect = CGRectMake(l.bounds.origin.x +2, l.bounds.origin.y +5, l.bounds.size.width-5, l.bounds.size.height-5);
    //= CGRectInset (l.bounds,4,4);
    //CGContextDrawImage (context, imageRect, image.CGImage ); //CGImageRef
}

@end

