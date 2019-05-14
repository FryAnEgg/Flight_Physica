//
//  GraphTitleView.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "GraphTitleView.h"

#import "FlightAppConstants.h"

@implementation GraphTitleView

@synthesize graphTitleString = _graphTitleString;
@synthesize activityIndicator = _activityIndicator;
@synthesize docStartTime,docEndTime,loadStartTime,loadEndTime;
@synthesize pageSize, pointsPerSecond, fullyLoaded, bWaitingForStop;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect frame = CGRectMake( 2.0, self.frame.size.height/2.0, 40.0, 40.0);
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.frame = frame;
        //[self.activityIndicator startAnimating];
        [self.activityIndicator sizeToFit];
        [self addSubview:self.activityIndicator];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:recognizer];

    }
    return self;
}

#pragma mark - drawing

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	UIFont * theFont = [ UIFont systemFontOfSize:18 ];
    
    if (self.graphTitleString && self.graphTitleString.length>0) {
        
        CGSize sSize = [ self.graphTitleString sizeWithFont:theFont ];
        CGContextSetFillColorWithColor ( context, [ UIColor whiteColor ].CGColor );
        [ self.graphTitleString drawAtPoint: CGPointMake( self.bounds.origin.x+(self.bounds.size.width-sSize.width)/2.0, self.bounds.origin.y) withFont: theFont ] ; //+(self.bounds.size.height-sSize.height)/2.0 )
    }
    
    if (self.docEndTime - self.docStartTime > 0.0) {
        
        //int graphFetchLimit = [[[ NSUserDefaults standardUserDefaults ] objectForKey:DEFAULTS_FETCH_PAGE_SIZE ] intValue ];
        
        //NSNumber * number = [NSNumber numberWithDouble:self.docEndTime - self.docStartTime]; // total time
        //NSNumber * preGap = [NSNumber numberWithDouble:self.loadStartTime - self.docStartTime]; // empty at start
        NSNumber * postGap = [NSNumber numberWithDouble:self.docEndTime - self.loadEndTime]; // time left at end
        
        //draw as box
        float boxHeight = 20.0;
        float boxWidth = self.bounds.size.width;
        
        //+ (UIColor *)colorWithPatternImage:(UIImage *)image
        //colorWithRed:green:blue:alpha:
        //- (BOOL)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha
        //groupTableViewBackgroundColor
        UIColor * blue = [ UIColor blueColor ];
        CGFloat r,g,b,a;
        BOOL got = [blue getRed:&r green:&g blue:&b alpha:&a];
        
        UIColor * newBlue = [ UIColor colorWithRed:0.5*r green:0.5*g blue:0.5*b alpha:1.0];
        
        CGRect boxFrame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y+self.bounds.size.height-boxHeight, boxWidth, boxHeight);
        CGContextSetFillColorWithColor ( context, [ UIColor grayColor ].CGColor );
        CGContextFillRect(context, boxFrame);
        
        CGContextSetFillColorWithColor ( context, newBlue.CGColor ); //blueColor
        
        NSString * tempString;
        
        if (fullyLoaded) { // set from GraphViewController, may also indicated truncated load
            
            CGRect boxFrame2 = CGRectMake(self.bounds.origin.x+1, self.bounds.origin.y+self.bounds.size.height-boxHeight+1,boxWidth-2, boxHeight-2);
            CGContextFillRect(context, boxFrame2);
            
             if ([postGap floatValue] <= 0.0) {
                 tempString = [NSString stringWithFormat:@"%4.1f seconds", self.docEndTime - self.docStartTime ];
             } else {
                tempString = [NSString stringWithFormat:@"%4.1f sec. (%2.0f%%)", self.loadEndTime-self.docStartTime , 100.*((self.loadEndTime-self.docStartTime)/(self.docEndTime - self.docStartTime))];
                //tempString = [NSString stringWithFormat:@"%4.1f seconds (/%4.1f)", self.loadEndTime-self.docStartTime , self.docEndTime - self.docStartTime];
            }
            [ self.activityIndicator stopAnimating ];
            
        }
        else { //still fetching
            double totalPages = (self.docEndTime - self.docStartTime) / (self.pageSize* self.pointsPerSecond);
            NSNumber * totalPageNumber = [ NSNumber numberWithDouble:totalPages ];
            //NSLog(@"totalPageNumber = %d", [totalPageNumber intValue] + 1);
            
            double ratio;
            double pageIndex;
            if(self.loadEndTime == 0.0) {
                ratio = 0.0;
                pageIndex = 0.0;
            } else {
                ratio = (self.loadEndTime - self.docStartTime )/ (self.docEndTime - self.docStartTime);
                pageIndex = round(ratio * totalPages);
            }
            
            NSNumber * pageIndexNumber = [ NSNumber numberWithDouble:pageIndex ];
            
            CGRect boxFrame2 = CGRectMake(self.bounds.origin.x+1, self.bounds.origin.y+self.bounds.size.height-boxHeight+1, ratio*boxWidth-2, boxHeight-2);
            
            CGContextFillRect(context, boxFrame2);
            
            NSString *string1 = NSLocalizedString(@"loading", @"");
            //how many pages
            tempString = [ NSString stringWithFormat:@"%@ %d / %d", string1, [pageIndexNumber intValue]+1, [totalPageNumber intValue]+1];
            
            // draw a stop x
            /*
            CGContextSetLineWidth(context, 3.0);
            CGContextSetStrokeColorWithColor ( context, [ UIColor redColor ].CGColor );
            
            CGPoint centerStop = CGPointMake(self.bounds.origin.x+self.bounds.size.width - 15.0, self.bounds.origin.y+self.bounds.size.height/2.0);
            
            if  (!self.bWaitingForStop) {
                CGContextAddArc (context, centerStop.x ,centerStop.y, 12.0,  0, 6.3, 0  );
                CGContextStrokePath(context);
            
                CGContextBeginPath( context );
            
            
                CGContextMoveToPoint(context, centerStop.x - 7.0, centerStop.y - 7.0);
                CGContextAddLineToPoint(context, centerStop.x + 7.0, centerStop.y + 7.0);
            
                CGContextMoveToPoint(context, centerStop.x - 7.0, centerStop.y + 7.0);
                CGContextAddLineToPoint(context, centerStop.x + 7.0, centerStop.y - 7.0);
            
                CGContextStrokePath(context);
            }
            */

        }
        
        if  (self.bWaitingForStop) { // sub in temp string
            tempString = NSLocalizedString(@"stopping...", @"");
        }
        
        
        CGSize sSize = [ tempString sizeWithFont:theFont ];
        CGContextSetFillColorWithColor ( context, [ UIColor whiteColor ].CGColor );
        [ tempString drawAtPoint: CGPointMake( self.bounds.origin.x+(self.bounds.size.width-sSize.width)/2.0, self.bounds.origin.y+self.bounds.size.height/2.0 ) withFont: theFont ] ;
        
    } else { // pre fetch
        // this should be post fetch
        NSString *string1 = NSLocalizedString(@"loading", @"");
        CGSize sSize = [ string1 sizeWithFont:theFont ];
        CGContextSetFillColorWithColor ( context, [ UIColor whiteColor ].CGColor );
        [ string1 drawAtPoint: CGPointMake( self.bounds.origin.x+(self.bounds.size.width-sSize.width)/2.0, self.bounds.origin.y+self.bounds.size.height/2.0 ) withFont: theFont ] ;
    }
    // loadStartTime,loadEndTime
    
    //CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1.0);
	//CGContextSetFillColorWithColor ( context, [ UIColor whiteColor ].CGColor );
	//CGContextFillRect(context, rect );
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    /*
    if (self.bWaitingForStop || self.fullyLoaded) {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint location = [recognizer locationInView:self];
        
        self.bWaitingForStop = YES;
        [self setNeedsDisplay];
        
        // if running stop fetching
        [[ NSNotificationCenter defaultCenter ] postNotificationName:@"stopFetchNotification" object:nil userInfo:nil];
        
    }
    */
    
}

@end
