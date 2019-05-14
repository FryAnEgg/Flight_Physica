//
//  TimeDisplayLayer.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "TimeDisplayLayer.h"

@implementation TimeDisplayLayer

@synthesize layer = _layer;
@synthesize timeString = _timeString;
@synthesize seconds = _seconds;
@synthesize theColor, theFont;


-(id)  init {
	
    self = [ super init ];
    
	if ( self != nil )
	{
        //image = [ UIImage imageNamed:@"22-skull-n-bones@2x" ];
        self.layer = [ [CALayer alloc] init];
        self.layer.delegate = self;
        //self.layer.position = center;
        //self.layer.position = CGPointMake(0.0, 0.0);
        //self.layer.cornerRadius = 25.0;
        self.layer.backgroundColor = [ UIColor clearColor ].CGColor;
        
        //_timeSubLayer
        //self.timeString =@"9.99";
        
    }
    return self;
}

#pragma mark drawing
//////////////////////////////
-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
    //self.theColor = [ UIColor grayColor ];
    //CGRect brectum = l.bounds;
    //CGRect frectum = l.frame;
    //CGPoint prectum = l.position;
    
    CGContextSetStrokeColorWithColor ( context, self.theColor.CGColor );
    CGContextSetFillColorWithColor ( context, self.theColor.CGColor );
    
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
    
    //self.theFont =  [ UIFont fontWithName:@"Helvetica" size:64.0 ];
    //self.timeString = @"xx:xx";
    
    CGSize sSize = [ self.timeString sizeWithFont:self.theFont ]; //optionText
    
    ;
    
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextSelectFont(context, "Helvetica", self.theFont.pointSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    CGContextShowTextAtPoint(context, l.bounds.size.width/2.0 - sSize.width/2.0 , l.bounds.origin.y + l.bounds.size.height/2.0 + sSize.height/4.0, [ self.timeString UTF8String ], [self.timeString length ] );//+ sSize.height/2
    
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
