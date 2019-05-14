//
//  GraphLineAttributeView.m
//  Flight Physica
//
//  Created by David Lathrop on 1/26/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "GraphLineAttributeView.h"

@implementation GraphLineAttributeView

@synthesize lineColor, lineStyle, lineWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.lineWidth = [NSNumber numberWithFloat:5.0];
    
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor );
    CGContextSetFillColorWithColor(context, self.lineColor.CGColor );
    CGContextSetLineWidth(context, [self.lineWidth floatValue]);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.size.width*0.5, rect.size.height*0.5);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height*0.5);
    CGContextStrokePath(context);
    
    //CGContextSetLineWidth(<#CGContextRef c#>, <#CGFloat width#>);
    //CGContextSetLineCap(<#CGContextRef c#>, <#CGLineCap cap#>);//—kCGLineCapButt (the default), kCGLineCapRound, or kCGLineCapSquare
    //CGContextSetLineDash(<#CGContextRef c#>, <#CGFloat phase#>, <#const CGFloat *lengths#>, <#size_t count#>);
    //CGContextSetLineJoin(<#CGContextRef c#>, <#CGLineJoin join#>);//kCGLineJoinMiter (the default), kCGLineJoinRound, or kCGLineJoinBevel
    
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor );
}



@end
