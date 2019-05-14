//
//  RulerLayer.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "RulerLayer.h"

@implementation RulerLayer

@synthesize layer = _layer;

-(id)  init {
	
    self = [ super init ];
    
	if ( self != nil )
	{
        //scoreValue = value;
        //image = [ UIImage imageNamed:@"22-skull-n-bones@2x" ];
        
        self.layer = [ [CALayer alloc] init];
        self.layer.delegate = self;
        //self.layer.bounds = boundsRect;
        //self.layer.position = center;
        //self.layer.position = CGPointMake(0.0, 0.0);
        //self.layer.cornerRadius = 100.0;
        self.layer.backgroundColor = [ UIColor clearColor ].CGColor;
        
    }
    return self;
}

-(void) setRuleLimits:(NSNumber*)min max:(NSNumber*)max {
    
    //float delta = [ max floatValue ] - [ min floatValue ];
    
    ruleStart = [ min doubleValue ];
    ruleEnd = [ max doubleValue ];
    //NSTimeInterval delta = self.annotationLayer.motionValue.timestamp - [ self.graphMinTime doubleValue ];
    
    //NSLog(@"setRuleLimits %4.2f ( %4.2f %4.2f )", delta, [ min floatValue ], [ max floatValue ] );
}

#pragma mark drawing
//////////////////////////////
-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    
	//CGRect brectum = l.bounds;
    //CGRect frectum = l.frame;
    //CGPoint prectum = l.position;
    
	// Main line
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, l.bounds.size.width, 0.0);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokePath(context);
    
    // ticks
    double delta = ruleEnd - ruleStart;
    
    double ruleLen = [[ NSNumber numberWithFloat:l.bounds.size.width ] doubleValue ];
    
    double markDelta = 1.0;
    if ( delta >= 300.0) {
        markDelta = 60.0;
    }
    else if ( delta >= 200.0) {
        markDelta = 30.0;
    }
    else if ( delta >= 100.0) {
        markDelta = 20.0;
    }
    else if ( delta >= 50.0) {
        markDelta = 10.0;
    }
    else if ( delta >= 20.0) {
        markDelta = 5.0;
    }
    else if ( delta >= 10.0) {
        markDelta = 3.0;
    }
    else if ( delta >= 5.0) {
        markDelta = 2.0;
    }
    
    BOOL useMin = YES;
    if (delta<60.0) {
        useMin = NO;
    }
    double firstMark = (markDelta / delta) * ruleLen; // point per second
    
    double nextMark = firstMark;
    
    float markLocationX = [[NSNumber numberWithDouble:nextMark] floatValue];
    
    float tickStartY = 0.0;
    float tickStopY = l.bounds.size.height/2.0;
    
    double tValue = markDelta;
    UIFont * theFont =  [ UIFont fontWithName:@"Helvetica" size:48.0 ];
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextSelectFont(context, "Helvetica", 48.0, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    while ( markLocationX < l.bounds.size.width ) {
        //NSLog(@"marking %4.2f", markLocationX);
        CGContextMoveToPoint(context, markLocationX, tickStartY);
        CGContextAddLineToPoint(context, markLocationX, tickStopY);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextSetLineWidth(context, 5.0);
        CGContextStrokePath(context);
        
        NSString * markString;
        if(useMin) {
            float timeLeft = [[NSNumber numberWithDouble:tValue]floatValue];
            int minutes = 0;
            while (timeLeft > 59.0) {
                minutes++;
                timeLeft -= 60.0;
            }
            if (timeLeft<10.0) {
                markString = [ NSString stringWithFormat:@"%d:0%1.0f", minutes, timeLeft];
            } else {
                markString = [ NSString stringWithFormat:@"%d:%2.0f", minutes, timeLeft];
            }
        } else {
            markString = [ NSString stringWithFormat:@"%3.0f", [[NSNumber numberWithDouble:tValue]floatValue]];
        }
        CGSize sSize = [markString sizeWithFont:theFont ];
        CGContextShowTextAtPoint(context, markLocationX-sSize.width*0.75, l.bounds.size.height-4.0 , [markString UTF8String], [markString length]); // -sSize.height/2.0
        
        // prepare for next
        nextMark += firstMark;
        markLocationX = [[NSNumber numberWithDouble:nextMark] floatValue];
        tValue += markDelta;
    }
    
    //NSString * string = @"0 1 2 3 4 5 6 7 8";
    
    //optionText
    
    //NSLog(@" layer at %f %f %f %f", l.frame.origin.x, l.frame.origin.y, l.frame.size.width, l.frame.size.height);
    //NSLog(@" layer bounds %f %f %f %f", l.bounds.origin.x, l.bounds.origin.y, l.bounds.size.width, l.bounds.size.height);
    //NSLog(@" layer position %f %f ", l.position.x, l.position.y);
    //NSLog(@" self position %f %f ", self.layer.position.x, self.layer.position.y);
    //NSLog(@" anchorPoint %f %f ", self.layer.anchorPoint.x, self.layer.anchorPoint.y);
    
    /*    float pi_x_2 = 3.1415926535*2;
     
     CGContextSetStrokeColorWithColor ( context, [ UIColor lightGrayColor ].CGColor );
     CGContextSetFillColorWithColor ( context, [ UIColor grayColor ].CGColor );
     
     CGFloat dashPattern[3] = {20, 20, 20};
     CGContextSetLineDash(context, 0.0, dashPattern, 3);
     CGContextSetLineWidth(context, 5.0);
     CGContextBeginPath( context );
     CGContextMoveToPoint(context, l.bounds.origin.x+l.bounds.size.width/2 , l.bounds.origin.y);
     CGContextAddLineToPoint( context, l.bounds.origin.x+l.bounds.size.width/2, l.bounds.origin.y + l.frame.size.height);
     CGContextStrokePath(context);
     
     // draw the text
     //CGContextSetFillColorWithColor ( context, self.color.CGColor );
     
     UIFont * theFont =  [ UIFont fontWithName:@"Helvetica" size:64.0 ];
     CGSize sSize = [ self.annotationString sizeWithFont:theFont ]; //optionText
     
     CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
     CGContextSelectFont(context, "Helvetica", 64.0, kCGEncodingMacRoman);
     CGContextSetTextDrawingMode(context, kCGTextFill);
     
     CGContextShowTextAtPoint(context, l.bounds.size.width / 2 - sSize.width/2 , l.bounds.size.height - 25 , [ self.annotationString UTF8String ], [self.annotationString length ] );
     
     
     sSize = [ self.valueString sizeWithFont:theFont ];
     CGContextShowTextAtPoint(context, l.bounds.size.width / 2 - sSize.width/2, 75  + sSize.height/2, [ self.valueString UTF8String ], [self.valueString length ] );
     */
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

