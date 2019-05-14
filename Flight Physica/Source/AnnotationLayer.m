//
//  AnnotationLayer.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "AnnotationLayer.h"

@implementation AnnotationLayer

@synthesize layer = _layer;
@synthesize timeSubLayer = _timeSubLayer;
@synthesize motionValue = _motionValue;
@synthesize annotationPoint = _annotationPoint;
@synthesize annotationType = _annotationType;
@synthesize annotationString = _annotationString;
@synthesize valueString = _valueString;

-(id)  init {
	
    self = [ super init ];
    
	if ( self != nil )
	{
        //image = [ UIImage imageNamed:@"22-skull-n-bones@2x" ];
        self.layer = [ [CALayer alloc] init];
        self.layer.delegate = self;
        //self.layer.bounds = boundsRect;
        //self.layer.position = center;
        //self.layer.position = CGPointMake(0.0, 0.0);
        self.layer.cornerRadius = 100.0;
        self.layer.backgroundColor = [ UIColor clearColor ].CGColor;
        
        
        _timeSubLayer = [[TimeDisplayLayer alloc] init];
        _timeSubLayer.layer.bounds = CGRectMake(0.0, 0.0, 250.0, 75.0);
        _timeSubLayer.theFont =  [ UIFont fontWithName:@"Helvetica" size:64.0 ];
        _timeSubLayer.theColor = [ UIColor grayColor ];
        //CGPoint layerPoint = CGPointMake(90.0, 90.0);
        _timeSubLayer.layer.position = CGPointMake(0.0, 0.0);;
        
        
        [self.layer addSublayer:_timeSubLayer.layer];
        
        [_timeSubLayer.layer setNeedsDisplay];
        
    }
    return self;
}

#pragma mark drawing
//////////////////////////////
-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    CGContextSetStrokeColorWithColor ( context, [ UIColor lightGrayColor ].CGColor );
    CGContextSetFillColorWithColor ( context, [ UIColor grayColor ].CGColor );
    
    //CGRect brectum = l.bounds;
    //CGRect frectum = l.frame;
    //CGPoint prectum = l.position;
    
    CGFloat dashPattern[3] = {20, 20, 20};
    CGContextSetLineDash(context, 0.0, dashPattern, 3);
    CGContextSetLineWidth(context, 5.0);
    CGContextBeginPath( context );
    CGContextMoveToPoint(context, l.bounds.origin.x+l.bounds.size.width/2 , l.bounds.origin.y);
    CGContextAddLineToPoint( context, l.bounds.origin.x+l.bounds.size.width/2, l.bounds.origin.y + l.frame.size.height);
	CGContextStrokePath(context);
    
    // draw the text
    // should do in separate sublayer
    // use _timeSubLayer instead
    
    /*UIFont * theFont =  [ UIFont fontWithName:@"Helvetica" size:64.0 ];
     CGSize sSize = [ self.annotationString sizeWithFont:theFont ]; //optionText
     
     CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
     CGContextSelectFont(context, "Helvetica", 64.0, kCGEncodingMacRoman);
     CGContextSetTextDrawingMode(context, kCGTextFill);
     
     CGContextShowTextAtPoint(context, l.bounds.size.width / 2 - sSize.width/2 , l.bounds.size.height - 100 , [ self.annotationString UTF8String ], [self.annotationString length ] );
     
     CGContextAddArc  ( context, l.frame.size.width / 2, l.frame.size.height / 2,  l.frame.size.height / 2 - 1,0, pi_x_2, 1 );
     CGContextSetStrokeColorWithColor ( context, [ UIColor orangeColor ].CGColor );
     CGContextStrokePath(context);
     */
    
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
