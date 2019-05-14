//
//  RecordButton.m
//  Flight Physica
//
//  Created by David Lathrop on 4/1/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "RecordButton.h"
#import "FlightAppConstants.h"

@implementation RecordButton

@synthesize buttonMode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"RecordButton:initWithFrame");
    }
    return self;
}

-(void) awakeFromNib {
    
    self.buttonMode = RB_MODE_READY;
    
    buttonLayer = [[ RecordingButtonLayer alloc] init];
    
    buttonLayer.mLayer.opacity = 0.0;
    buttonLayer.flashLayer.opacity = 0.0;
    
    [self.layer addSublayer:buttonLayer.flashLayer];
    [self.layer addSublayer:buttonLayer.mLayer];
    
}

#pragma mark - Layer
-(void) startRecordingAnimation {
    //self.mLayer
    buttonLayer.isRunning = YES;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.0f]
                     forKey:kCATransactionAnimationDuration];
    
    buttonLayer.mLayer.frame = CGRectMake( buttonLayer.mLayer.frame.origin.x, buttonLayer.mLayer.frame.origin.y, self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    buttonLayer.mLayer.position = CGPointMake(self.bounds.origin.x+0.5*self.bounds.size.width, self.bounds.origin.y+0.5*self.bounds.size.height) ;
    
    buttonLayer.flashLayer.frame = CGRectMake( buttonLayer.flashLayer.frame.origin.x, buttonLayer.flashLayer.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
    buttonLayer.flashLayer.position = CGPointMake(self.bounds.origin.x+0.5*self.bounds.size.width, self.bounds.origin.y+0.5*self.bounds.size.height) ;
    
    [CATransaction commit];
    
    buttonLayer.mLayer.opacity = 1.0;
    [buttonLayer.mLayer setNeedsDisplay];
    
    //buttonLayer.flashLayer.opacity = 1.0;
    [buttonLayer.flashLayer setNeedsDisplay];
    
    [buttonLayer doRecordAnimation];
    [buttonLayer doFlashAnimation];
}

-(void) stopRecordingAnimation {
    buttonLayer.isRunning = NO;
    buttonLayer.mLayer.opacity = 0.0;
    [buttonLayer.mLayer setNeedsDisplay];
    
    buttonLayer.flashLayer.opacity = 0.0;
    [buttonLayer.flashLayer setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    /*UIControlState theState = self.state;
    
    if (theState == UIControlStateNormal ) {
        NSLog(@"theState == UIControlStateNormal");
    }
    if (theState == UIControlStateHighlighted ) {
        NSLog(@"theState == UIControlStateHighlighted");
    }
    if (theState == UIControlStateDisabled ) {
        NSLog(@"theState == UIControlStateDisabled");
    }
    if (theState == UIControlStateSelected ) {
        NSLog(@"theState == UIControlStateSelected");
    }
    if (theState == UIControlStateApplication ) {
        NSLog(@"theState == UIControlStateApplication");
    }
    if (theState == UIControlStateReserved ) {
        NSLog(@"theState == UIControlStateReserved");
    }*/
      
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *buttonColor = [ UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5];
    
    CGContextSetFillColorWithColor ( context, buttonColor.CGColor );
    CGContextSetStrokeColorWithColor ( context, [ UIColor darkGrayColor ].CGColor );
    
    //CGContextFillRect (context, rect );
    
    
    CGFloat x = rect.origin.x + 0.5*rect.size.width;
    CGFloat y = rect.origin.y + 0.5*rect.size.height;
    CGFloat radius = 0.5*rect.size.height - 5.;
    CGFloat startAngle = 0.;
    CGFloat endAngle = 6.3; //PITIMES2;
    int clockwise = 0;
    
    CGContextBeginPath (context);
    CGContextAddArc (context, x, y, radius, startAngle, endAngle, clockwise );
    CGContextClosePath(context);
    CGContextFillPath (context);
    
    radius = 0.9*radius;
    CGContextSetLineWidth(context, 3.);
    CGContextBeginPath (context);
    CGContextAddArc (context, x, y, radius, startAngle, endAngle, clockwise );
    CGContextClosePath(context);
    CGContextStrokePath (context);
    
    if (self.buttonMode == RB_MODE_READY || self.buttonMode == RB_MODE_RECORDING) {
        radius = 0.5*radius;
        CGContextSetLineWidth(context, 2.);
        CGContextBeginPath (context);
        CGContextAddArc (context, x, y, radius, startAngle, endAngle, clockwise );
        CGContextClosePath(context);
        CGContextStrokePath (context);
        
        radius = radius-1.0;
        CGContextSetFillColorWithColor ( context, [ UIColor redColor ].CGColor );
        CGContextBeginPath (context);
        CGContextAddArc (context, x, y, radius, startAngle, endAngle, clockwise );
        CGContextClosePath(context);
        CGContextFillPath (context);
        
        /*//// Color Declarations
         //with highlight 
         UIColor* color = [UIColor colorWithRed: 0.886 green: 0 blue: 0.295 alpha: 1];
         UIColor* color2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
         
         //// Shadow Declarations
         UIColor* highlight = color2;
         CGSize highlightOffset = CGSizeMake(1.1, 1.1);
         CGFloat highlightBlurRadius = 5;
         
         //// Oval Drawing
         UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(99, 26, 36, 36)];
         [color setFill];
         [ovalPath fill];
         
         ////// Oval Inner Shadow
         CGRect ovalBorderRect = CGRectInset([ovalPath bounds], -highlightBlurRadius, -highlightBlurRadius);
         ovalBorderRect = CGRectOffset(ovalBorderRect, -highlightOffset.width, -highlightOffset.height);
         ovalBorderRect = CGRectInset(CGRectUnion(ovalBorderRect, [ovalPath bounds]), -1, -1);
         
         UIBezierPath* ovalNegativePath = [UIBezierPath bezierPathWithRect: ovalBorderRect];
         [ovalNegativePath appendPath: ovalPath];
         ovalNegativePath.usesEvenOddFillRule = YES;
         
         CGContextSaveGState(context);
         {
         CGFloat xOffset = highlightOffset.width + round(ovalBorderRect.size.width);
         CGFloat yOffset = highlightOffset.height;
         CGContextSetShadowWithColor(context,
         CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
         highlightBlurRadius,
         highlight.CGColor);
         
         [ovalPath addClip];
         CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(ovalBorderRect.size.width), 0);
         [ovalNegativePath applyTransform: transform];
         [[UIColor grayColor] setFill];
         [ovalNegativePath fill];
         }
         CGContextRestoreGState(context);
         */
        
    } else if (self.buttonMode == RB_MODE_CLEAR) {
        // text for clear
        NSString * clearString = NSLocalizedString(@"Clear", @"");
        CGContextSetFillColorWithColor ( context, [ UIColor whiteColor ].CGColor );
        float fontsize = 16.0;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            fontsize = 28.0;
        }
        UIFont *font = [ UIFont fontWithName:@"Helvetica" size:fontsize ];
        CGSize size = [clearString sizeWithFont:font];
        
        CGFloat rx4draw = x-0.5*size.width;
        CGFloat ry4draw = y-0.5*size.height;
        
        CGRect stringRect = CGRectMake(rx4draw, ry4draw, size.width, size.height);
        [clearString drawInRect:stringRect withFont:font];
    }
}

@end
