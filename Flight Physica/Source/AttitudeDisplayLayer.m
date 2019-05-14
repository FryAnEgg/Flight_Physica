//
//  AttitudeDisplayLayer.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "AttitudeDisplayLayer.h"

//#import "HeadingView.h"

@implementation AttitudeDisplayLayer

@synthesize layer = _layer;
@synthesize bglayer = _bglayer;

@synthesize attitudeRoll;
@synthesize attitudePitch;
@synthesize attitudeHeading;
@synthesize attitudeMode;

-(id)  init {
	
    self = [ super init ];
    
	if ( self != nil )
	{
        self.layer = [ [CALayer alloc] init];
        self.layer.delegate = self;
        self.layer.bounds = CGRectMake(0.0, 0.0, 120, 120.0);
        self.layer.anchorPoint = CGPointMake(0.5,0.5);
        //self.layer.position = center;
        //self.layer.position = CGPointMake(0.0, 0.0);
        //self.layer.cornerRadius = 25.0;
        self.layer.backgroundColor = [ UIColor clearColor ].CGColor;
        
        //_timeSubLayer
        //self.timeString =@"9.99";
        self.attitudeMode = kLegend_Attitude_Roll;
        //kLegend_Attitude_Pitch,
        
        self.bglayer = [ [CALayer alloc] init];
        self.bglayer.delegate = self;
        self.bglayer.bounds = CGRectMake(0.0, 0.0, 120, 120.0);
        self.bglayer.backgroundColor = [ UIColor clearColor ].CGColor;
        
    }
    return self;
}

-(void)drawRollIndicator:(CALayer*)l inContext:(CGContextRef)context
{
    CGContextSetStrokeColorWithColor ( context, [ UIColor blackColor ].CGColor );
    CGContextSetFillColorWithColor ( context, [ UIColor blackColor ].CGColor );
    
    //NSNumber * pitch = [ NSNumber numberWithDouble: self.attitudePitch ];
    //NSNumber * roll = [ NSNumber numberWithDouble: self.attitudeRoll ];
    //NSNumber * heading = [ NSNumber numberWithDouble: self.attitudeHeading ];
    
    //NSLog(@"drawLayer R: %4.2f P: %4.2f H: %4.2f", [roll floatValue], [pitch floatValue], [heading floatValue]);
    // degrees
    
    //double kRadiansToDegress = 360.0/PITIMES2;
    //NSLog(@"degrees   R: %4.2f P: %4.2f H: %4.2f", [roll floatValue]*radToDeg, [pitch floatValue]*radToDeg, [heading floatValue]*radToDeg);
    
    //double sineR = sin(self.attitudeRoll);
    //double cosR = cos(self.attitudeRoll);
    
    //draw circle
    //double radius = l.bounds.size.width/2.0;
    
    //CGContextAddArc (context, l.bounds.size.width/2.0 , l.bounds.size.height/2.0, radius,  0, 6.3, 0  );
    //CGContextFillPath(context);
    
    //draw Roll
    CGPoint center = CGPointMake(l.bounds.size.width/2.0, l.bounds.size.height/2.0);
    CGPoint topLt = CGPointMake(0.0, 0.0);
    CGPoint botRt = CGPointMake(l.bounds.size.width, l.bounds.size.height);
    
    float wingY1 = 0.02 * l.bounds.size.height;
    float wingY2 = 0.03 * l.bounds.size.height;
    float fuseRadius = 0.10 * l.bounds.size.height;
    
    CGContextSetFillColorWithColor ( context, [ UIColor blueColor ].CGColor );
    
    CGContextBeginPath( context );
    
    CGContextMoveToPoint( context, topLt.x, center.y + wingY1 );
    CGContextAddLineToPoint( context, topLt.x, center.y - wingY1 );
    CGContextAddLineToPoint( context, center.x, center.y - wingY2 );
    CGContextAddLineToPoint( context, botRt.x, center.y - wingY1 );
    CGContextAddLineToPoint( context, botRt.x, center.y + wingY1 );
    CGContextAddLineToPoint( context, center.x, center.y + wingY2 );
    CGContextAddLineToPoint( context, topLt.x, center.y + wingY1 );
    
    CGContextFillPath(context);
    
    CGContextAddArc (context, center.x ,center.y - wingY2, fuseRadius,  0, 6.3, 0  );
    CGContextFillPath(context);
    
    float stabY = 0.08 * l.bounds.size.height;
    float stabLen = 0.20 * l.bounds.size.height;
    float tailLen = 0.15 * l.bounds.size.height;
    
    CGContextSetStrokeColorWithColor ( context, [ UIColor blackColor ].CGColor );
    CGContextSetLineWidth(context, 4.0);
    
    CGContextBeginPath( context );
    CGContextMoveToPoint( context, center.x + stabLen, center.y - stabY + 4.0 );
    CGContextAddLineToPoint( context, center.x - stabLen, center.y - stabY + 4.0);
    CGContextStrokePath(context);
    
    
    CGContextSetStrokeColorWithColor ( context, [ UIColor blueColor ].CGColor );
    CGContextSetLineWidth(context, 8.0);
    
    CGContextBeginPath( context );
    
    CGContextMoveToPoint( context, center.x + stabLen, center.y - stabY );
    CGContextAddLineToPoint( context, center.x - stabLen, center.y - stabY );
    
    CGContextMoveToPoint( context, center.x , center.y - stabY );
    CGContextAddLineToPoint( context, center.x, center.y - stabY - tailLen );
    
    CGContextStrokePath(context);
}

-(void)drawRollBgd:(CALayer*)l inContext:(CGContextRef)context
{
    
    CGContextSetFillColorWithColor ( context, [ UIColor blueColor ].CGColor );
    CGContextSetStrokeColorWithColor ( context, [ UIColor grayColor ].CGColor );
    
    //draw circle
    double radius = l.bounds.size.width/2.0;
    
    CGContextAddArc (context, l.bounds.size.width/2.0 , l.bounds.size.height/2.0, radius,  0, 6.3, 0  );
    //CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context,5.0);
    
    CGContextBeginPath( context );
    
    CGContextMoveToPoint( context, l.bounds.size.width/2.0, 0.0 );
    CGContextAddLineToPoint( context, l.bounds.size.width/2.0, l.bounds.size.height );
    
    CGContextMoveToPoint( context, 0.0 , l.bounds.size.height/2.0 );
    CGContextAddLineToPoint( context, l.bounds.size.width , l.bounds.size.height/2.0 );
    
    CGContextStrokePath(context);
}

-(void)drawPitchIndicator:(CALayer*)l inContext:(CGContextRef)context
{
    CGPoint center = CGPointMake(l.bounds.size.width/2.0, l.bounds.size.height/2.0);
    //CGPoint topLt = CGPointMake(0.0, 0.0);
    CGPoint botRt = CGPointMake(l.bounds.size.width, l.bounds.size.height);
    
    float needlewidth = 0.05 * l.bounds.size.height;
    
    CGContextSetFillColorWithColor ( context, [ UIColor blackColor ].CGColor );
    CGContextSetStrokeColorWithColor ( context, [ UIColor blackColor ].CGColor );
    CGContextSetLineWidth(context,5.0);
    
    CGContextBeginPath( context );
    
    CGContextMoveToPoint( context, center.x, center.y + needlewidth );
    CGContextAddLineToPoint( context, botRt.x, center.y  );
    CGContextAddLineToPoint( context, center.x, center.y - needlewidth  );
    CGContextAddLineToPoint( context, center.x, center.y + needlewidth );
    
    CGContextFillPath(context);
    //CGContextStrokePath(context);
    
    /*CGContextAddArc (context, center.x ,center.y - wingY2, fuseRadius,  0, 6.3, 0  );
     CGContextFillPath(context);
     
     float stabY = 0.08 * l.bounds.size.height;
     float stabLen = 0.20 * l.bounds.size.height;
     float tailLen = 0.15 * l.bounds.size.height;
     
     CGContextSetStrokeColorWithColor ( context, [ UIColor blackColor ].CGColor );
     CGContextSetLineWidth(context, 4.0);
     
     CGContextBeginPath( context );
     CGContextMoveToPoint( context, center.x + stabLen, center.y - stabY + 4.0 );
     CGContextAddLineToPoint( context, center.x - stabLen, center.y - stabY + 4.0);
     CGContextStrokePath(context);
     
     
     CGContextSetStrokeColorWithColor ( context, [ UIColor whiteColor ].CGColor );
     CGContextSetLineWidth(context, 8.0);
     
     CGContextBeginPath( context );
     
     CGContextMoveToPoint( context, center.x + stabLen, center.y - stabY );
     CGContextAddLineToPoint( context, center.x - stabLen, center.y - stabY );
     
     CGContextMoveToPoint( context, center.x , center.y - stabY );
     CGContextAddLineToPoint( context, center.x, center.y - stabY - tailLen );
     
     CGContextStrokePath(context);
     */
    
}

-(void)drawPitchBgd:(CALayer*)l inContext:(CGContextRef)context
{
    //CGContextSetFillColorWithColor ( context, [ UIColor blueColor ].CGColor );
    CGContextSetStrokeColorWithColor ( context, [ UIColor grayColor ].CGColor );
    
    //draw circle
    double radius = l.bounds.size.width/2.0;
    
    CGContextAddArc (context, l.bounds.size.width/2.0 , l.bounds.size.height/2.0, radius,  0, 6.3, 0  );
    CGContextStrokePath(context);
    
    //crosshatch
    CGContextSetLineWidth(context,5.0);
    
    CGContextBeginPath( context );
    
    CGContextMoveToPoint( context, l.bounds.size.width/2.0, 0.0 );
    CGContextAddLineToPoint( context, l.bounds.size.width/2.0, l.bounds.size.height );
    
    CGContextMoveToPoint( context, 0.0 , l.bounds.size.height/2.0 );
    CGContextAddLineToPoint( context, l.bounds.size.width , l.bounds.size.height/2.0 );
    
    CGContextStrokePath(context);
    
}

#pragma mark drawing
//////////////////////////////
-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    // should draw flat and the animate with rotation matrix...
    if(l == self.layer) {
        
        if (self.attitudeMode == kLegend_Attitude_Roll) {
            
            [ self drawRollIndicator:l inContext:context ];
            
        } else if (self.attitudeMode == kLegend_Attitude_Pitch) {
            
            [ self drawPitchIndicator:l inContext:context ];
            
        }
    }
    else  if(l == self.bglayer) { // draw the background
        
        if(self.attitudeMode == kLegend_Attitude_Roll) {
            
            [ self drawRollBgd:l inContext:context ];
            
        } else if (self.attitudeMode == kLegend_Attitude_Pitch) {
            
            [ self drawPitchBgd:l inContext:context ];
            
        }
    }
    
    /*
     //draw line
     CGContextSetStrokeColorWithColor ( context, [ UIColor redColor ].CGColor );
     CGContextBeginPath( context );
     CGContextMoveToPoint( context, l.bounds.size.width/2.0, l.bounds.size.height/2.0 );
     CGContextAddLineToPoint( context, l.bounds.size.width/2.0 - (radius*sineH), l.bounds.size.height/2.0 - (radius*cosH) );
     CGContextStrokePath(context); //errorCircleCenter
     
     //draw pitch
     CGContextSetStrokeColorWithColor ( context, [ UIColor blueColor ].CGColor );
     CGContextBeginPath( context );
     CGContextMoveToPoint( context, l.bounds.size.width/2.0, l.bounds.size.height/2.0 );
     CGContextAddLineToPoint( context, l.bounds.size.width/2.0 - (radius*cosP), l.bounds.size.height/2.0 - (radius*sineP) );
     CGContextStrokePath(context); //errorCircleCenter
     */
    //CGFloat dashPattern[3] = {20, 20, 20};
    //CGContextSetLineDash(context, 0.0, dashPattern, 3);
    //CGContextSetLineWidth(context, 5.0);
    //CGContextBeginPath( context );
    //CGContextMoveToPoint(context, l.bounds.origin.x+l.bounds.size.width/2 , l.bounds.origin.y);
    //CGContextAddLineToPoint( context, l.bounds.origin.x+l.bounds.size.width/2, l.bounds.origin.y + l.frame.size.height);
	//CGContextStrokePath(context);
    
    // draw the text
    // should do in separate sublayer
    // use _timeSubLayer instead
    //CGContextSetFillColorWithColor ( context, self.color.CGColor );
    
    /*    UIFont * theFont =  [ UIFont fontWithName:@"Helvetica" size:64.0 ];
     CGSize sSize = [ self.timeString sizeWithFont:theFont ]; //optionText
     
     CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
     CGContextSelectFont(context, "Helvetica", 64.0, kCGEncodingMacRoman);
     CGContextSetTextDrawingMode(context, kCGTextFill);
     
     CGContextShowTextAtPoint(context, l.bounds.size.width / 2 - sSize.width/2 , l.bounds.size.height / 2 +20, [ self.timeString UTF8String ], [self.timeString length ] );//+ sSize.height/2
     */
    //sSize = [ self.valueString sizeWithFont:theFont ];
    //CGContextShowTextAtPoint(context, l.bounds.size.width / 2 - sSize.width/2, 75  + sSize.height/2, [ self.valueString UTF8String ], [self.valueString length ] );
    
    //CGContextSetFillColorWithColor ( context, [ UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:0.5 ].CGColor );
    //CGContextBeginPath( context );
    //CGContextAddArc  ( context, l.bounds.origin.x+l.bounds.size.width / 2, l.bounds.origin.y+l.bounds.size.height / 2,  l.bounds.size.width / 2 - 1,0, pi_x_2, 1 );
    //CGContextFillPath(context);
    
    /*
     CGContextAddArc  ( context, l.frame.size.width / 2, l.frame.size.height / 2,  l.frame.size.height / 2 - 1,0, pi_x_2, 1 );
     CGContextSetStrokeColorWithColor ( context, [ UIColor orangeColor ].CGColor );
     CGContextStrokePath(context);*/
    
    //
    //CGContextAddRect( context,CGRectMake( 0.0, 0.0, l.frame.size.width, l.frame.size.height ));
    //CGContextStrokePath(context);
    
    /*// draw the text
     CGContextSetFillColorWithColor ( context, [ UIColor redColor ].CGColor );
     
     UIFont * theFont =  [ UIFont fontWithName:@"Helvetica" size:32.0 ];
     NSString * strengthString = [[ NSNumber numberWithFloat: self.strength ] stringValue ];
     CGSize sSize = [ strengthString sizeWithFont:theFont ]; //optionText
     
     CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
     CGContextSelectFont(context, "Helvetica", 32.0, kCGEncodingMacRoman);
     CGContextSetTextDrawingMode(context, kCGTextFill);
     
     CGContextShowTextAtPoint(context, l.bounds.size.width / 2 - sSize.width/2, l.bounds.size.height / 2 + sSize.height/2, [ strengthString UTF8String ], [strengthString length ] );
     */
    
    //CGContextScaleCTM (context, 1.0,-1.0);
    //CGContextTranslateCTM (context, 0.0, -l.bounds.size.height);
    
    //CGRect imageRect = CGRectMake(l.bounds.origin.x +2, l.bounds.origin.y +5, l.bounds.size.width-5, l.bounds.size.height-5);
    //= CGRectInset (l.bounds,4,4);
    //CGContextDrawImage (context, imageRect, image.CGImage ); //CGImageRef
}


@end

