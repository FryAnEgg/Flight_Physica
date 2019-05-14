//
//  LiveGraphView.h
//  Flight Physica
//
//  Created by David Lathrop on 1/6/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GraphViewSegment;

@interface GraphTextView : UIView <CALayerDelegate>
{
    NSString * stringA;
    NSString * stringB;
    NSString * stringC;
}

@property (nonatomic,retain) NSString * stringA;
@property (nonatomic,retain) NSString * stringB;
@property (nonatomic,retain) NSString * stringC;

@end

@interface LiveGraphView : UIView {
    
	NSMutableArray *segments;
	GraphViewSegment *current;
	GraphTextView *graphTextView;
    
    CGPoint initialSegmentPosition;
}

-(void)addX:(double)x y:(double)y z:(double)z;
-(void) clearGraph;
-(void)selectFilter:(int)tabIndex;

@property(nonatomic, retain) NSMutableArray *segments;
@property(nonatomic, retain) GraphViewSegment *current;
@property(nonatomic, retain) GraphTextView *graphTextView;



@end
