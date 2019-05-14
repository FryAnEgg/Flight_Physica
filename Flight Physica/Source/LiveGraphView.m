//
//  LiveGraphView.m
//  Flight Physica
//
//  Created by David Lathrop on 1/6/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "LiveGraphView.h"

#import "FlightAppConstants.h"

#pragma mark - Overview of operation

// The GraphView class needs to be able to update the scene quickly in order to track the accelerometer data
// at a fast enough frame rate. The naive implementation tries to draw the entire graph every frame,
// but unfortunately that is too much content to sustain a high framerate. As such this class uses CALayers
// to cache previously drawn content and arranges them carefully to create an illusion that we are
// redrawing the entire graph every frame.

#pragma mark - Quartz Helpers

// Functions used to draw all content

CGColorRef CreateDeviceGrayColor(CGFloat w, CGFloat a)
{
	CGColorSpaceRef gray = CGColorSpaceCreateDeviceGray();
	CGFloat comps[] = {w, a};
	CGColorRef color = CGColorCreate(gray, comps);
	CGColorSpaceRelease(gray);
	return color;
}

CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat comps[] = {r, g, b, a};
	CGColorRef color = CGColorCreate(rgb, comps);
	CGColorSpaceRelease(rgb);
	return color;
}

CGColorRef graphBackgroundColor()
{
	static CGColorRef c = NULL;
	if(c == NULL)
	{
		c = CreateDeviceGrayColor(0.05, 1.0);
	}
	return c;
}

CGColorRef graphLineColor()
{
	static CGColorRef c = NULL;
	if(c == NULL)
	{
		c = CreateDeviceGrayColor(0.5, 1.0);
	}
	return c;
}

CGColorRef graphXColor()
{
	static CGColorRef c = NULL;
	if(c == NULL)
	{
		c = CreateDeviceRGBColor(1.0, 0.0, 0.0, 1.0);
	}
	return c;
}

CGColorRef graphYColor()
{
	static CGColorRef c = NULL;
	if(c == NULL)
	{
		c = CreateDeviceRGBColor(0.0, 1.0, 0.0, 1.0);
	}
	return c;
}

CGColorRef graphZColor()
{
	static CGColorRef c = NULL;
	if(c == NULL)
	{
		c = CreateDeviceRGBColor(0.0, 0.0, 1.0, 1.0);
	}
	return c;
}

void DrawGridlines(CGContextRef context, CGFloat x, CGFloat width)
{
	for(CGFloat y = -60.0; y <= 60.0; y += 30.0)
	{
		CGContextMoveToPoint(context, x, y);
		CGContextAddLineToPoint(context, x + width, y);
	}
	CGContextSetStrokeColorWithColor(context, graphLineColor());
	CGContextStrokePath(context);
}

#pragma mark - GraphViewSegment

// The GraphViewSegment manages up to 32 accelerometer values and a CALayer that it updates with
// the segment of the graph that those values represent.

@interface GraphViewSegment : NSObject <CALayerDelegate>
{
	CALayer *layer;
	// Need 33 values to fill 32 pixel width.
	double xhistory[33];
	double yhistory[33];
	double zhistory[33];
	int index;
}

-(id)initWithHeight:(float)height;
// returns true if adding this value fills the segment, which is necessary for properly updating the segments
-(BOOL)addX:(double)x y:(double)y z:(double)z;

// When this object gets recycled (when it falls off the end of the graph)
// -reset is sent to clear values and prepare for reuse.
-(void)reset;

// Returns true if this segment has consumed 32 values.
-(BOOL)isFull;

// Returns true if the layer for this segment is visible in the given rect.
-(BOOL)isVisibleInRect:(CGRect)r;

// The layer that this segment is drawing into
@property(nonatomic, readonly) CALayer *layer;

@end

@implementation GraphViewSegment

@synthesize layer;

-(id)initWithHeight:(float)height
{
	self = [super init];
	if(self != nil)
	{
		layer = [[CALayer alloc] init];
		// the layer will call our -drawLayer:inContext: method to provide content
		// and our -actionForLayer:forKey: for implicit animations
		layer.delegate = self;
        
		layer.bounds = CGRectMake(0.0, -height/2, 32.0, height); //112.0);
		// Disable blending as this layer consists of non-transperant content.
		// Unlike UIView, a CALayer defaults to opaque=NO
		layer.opaque = YES;
		// Index represents how many slots are left to be filled in the graph,
		// which is also +1 compared to the array index that a new entry will be added
		index = 33;
	}
	return self;
}

-(void)reset
{
	// Clear out our components and reset the index to 33 to start filling values again...
	memset(xhistory, 0, sizeof(xhistory));
	memset(yhistory, 0, sizeof(yhistory));
	memset(zhistory, 0, sizeof(zhistory));
	index = 33;
	// Inform Core Animation that we need to redraw this layer.
	[layer setNeedsDisplay];
}

-(BOOL)isFull
{
	// Simple, this segment is full if there are no more space in the history.
	return index == 0;
}

-(BOOL)isVisibleInRect:(CGRect)r
{
	// Just check if there is an intersection between the layer's frame and the given rect.
	return CGRectIntersectsRect(r, layer.frame);
}

-(BOOL)addX:(double)x y:(double)y z:(double)z
{
	//double shiftValue = 0.5;
    // If this segment is not full, then we add a new acceleration value to the history.
	if(index > 0)
	{
		// First decrement, both to get to a zero-based index and to flag one fewer position left
		--index;
		xhistory[index] = x; //+ shiftValue;
		yhistory[index] = y;
		zhistory[index] = z; // - shiftValue;
		// And inform Core Animation to redraw the layer.
		[layer setNeedsDisplay];
	}
	// And return if we are now full or not (really just avoids needing to call isFull after adding a value).
	return index == 0;
}

-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
{
	float lineSeparation = l.frame.size.height / 6; //32.0;
    float yGraphScale = l.frame.size.height / 8 ;//24.0;
    
    // Fill in the background
	CGContextSetFillColorWithColor(context, graphBackgroundColor());
	CGContextFillRect(context, layer.bounds);
	
	// Draw the grid lines
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, 32.0, 0.0);
    CGContextSetStrokeColorWithColor(context, graphLineColor());
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0.0, lineSeparation);
    CGContextAddLineToPoint(context, 32.0, lineSeparation);
    CGContextSetStrokeColorWithColor(context, graphLineColor());
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0.0, -lineSeparation);
    CGContextAddLineToPoint(context, 32.0, -lineSeparation);
    CGContextSetStrokeColorWithColor(context, graphLineColor());
    CGContextStrokePath(context);
    
	// Draw the graph
	CGPoint lines[64];
	int i;
	
    
	// X
	for(i = 0; i < 32; ++i)
	{
		lines[i*2].x = i;
		lines[i*2].y = -xhistory[i] * yGraphScale -lineSeparation;
		lines[i*2+1].x = i + 1;
		lines[i*2+1].y = -xhistory[i+1] * yGraphScale -lineSeparation;
	}
	CGContextSetStrokeColorWithColor(context, graphXColor());
	CGContextStrokeLineSegments(context, lines, 64);
    
	// Y
	for(i = 0; i < 32; ++i)
	{
		lines[i*2].y = -yhistory[i] * yGraphScale;
		lines[i*2+1].y = -yhistory[i+1] * yGraphScale;
	}
	CGContextSetStrokeColorWithColor(context, graphYColor());
	CGContextStrokeLineSegments(context, lines, 64);
    
	// Z
	for(i = 0; i < 32; ++i)
	{
		lines[i*2].y = -zhistory[i] * yGraphScale + lineSeparation;
		lines[i*2+1].y = -zhistory[i+1] * yGraphScale + lineSeparation;
	}
	CGContextSetStrokeColorWithColor(context, graphZColor());
	CGContextStrokeLineSegments(context, lines, 64);
}

-(id)actionForLayer:(CALayer *)layer forKey :(NSString *)key
{
	// We disable all actions for the layer, so no content cross fades, no implicit animation on moves, etc.
	return [NSNull null];
}

// The accessibilityValue of this segment should be the x,y,z values last added.
- (NSString *)accessibilityValue
{
	return [NSString stringWithFormat:NSLocalizedString(@"graphSegmentFormat", @""), xhistory[index], yhistory[index], zhistory[index]];
}

@end

#pragma mark - GraphTextView

@implementation GraphTextView

@synthesize stringA, stringB, stringC;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        stringA = @"x";
        stringB = @"y";
        stringC = @"z";
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    float lineSeparation = self.frame.size.height / 6; //32.0;
    //float yGraphScale = self.frame.size.height / 8 ;//24.0;
    
	// Fill in the background
	CGContextSetFillColorWithColor(context, graphBackgroundColor());
	CGContextFillRect(context, self.bounds);
	
	CGContextTranslateCTM(context, 0.0, self.frame.size.height/2);
    
    // Draw the text
    UIFont *font = [UIFont systemFontOfSize:14.0];
    NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle];
    NSDictionary *attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor redColor]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:stringA attributes:attributes];
    [attributedString drawInRect:CGRectMake(2.0, -10.0-lineSeparation, 28.0, 16.0)];
    
    attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor greenColor]};
    attributedString = [[NSAttributedString alloc] initWithString:stringB attributes:attributes];
    [attributedString drawInRect:CGRectMake(2.0, -10.0, 28.0, 16.0)];

    attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor blueColor]};
    attributedString = [[NSAttributedString alloc] initWithString:stringC attributes:attributes];
    [attributedString drawInRect:CGRectMake(2.0, -10.0+lineSeparation, 28.0, 16.0)];
    
}

@end

#pragma mark - LiveGraphView

@interface LiveGraphView()


// A common init routine for use with -initWithFrame: and -initWithCoder:
-(void)commonInit;

-(GraphViewSegment*)addSegment;

// Recycles a segment from 'segments' into  'current'
-(void)recycleSegment;

@end

@implementation LiveGraphView

@synthesize segments, graphTextView, current;

// Designated initializer
-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		[self commonInit];
	}
	return self;
}

// Designated initializer
-(id)initWithCoder:(NSCoder*)decoder
{
	self = [super initWithCoder:decoder];
	if(self != nil)
	{
		[self commonInit];
	}
	return self;
}

-(void)commonInit
{
	
}

-(void) clearGraph {
    
    if(!self.graphTextView){
        //CGRect rect = self.frame;
        self.graphTextView = [[GraphTextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, self.frame.size.height)];
        [self addSubview:graphTextView];
        [self.graphTextView setNeedsDisplay];
    }
    else {
        self.graphTextView.frame = CGRectMake(0.0, 0.0, 32.0, self.frame.size.height);
        [self.graphTextView setNeedsDisplay];
        [self.graphTextView setNeedsDisplay];
    }
    
    for (int i=0; i<segments.count; i++) {
        GraphViewSegment * segment = [ segments objectAtIndex:i ];
        [ segment.layer removeFromSuperlayer ];
    }
    
    // Create a mutable array to store segments, which is required by -addSegment
	segments = [[NSMutableArray alloc] init];
	current = [self addSegment];
}

-(void)addX:(double)x y:(double)y z:(double)z
{
	//NSLog(@"addXYZ");
    
    // First, add the new acceleration value to the current segment
	if([current addX:x y:y z:z])
	{
		// If after doing that we've filled up the current segment, then we need to
		// determine the next current segment
		[self recycleSegment];
		// And to keep the graph looking continuous, we add the acceleration value to the new segment as well.
		[current addX:x y:y z:z];
	}
	// After adding a new data point, we need to advance the x-position of all the segment layers by 1 to
	// create the illusion that the graph is advancing.
	for(GraphViewSegment * s in segments)
	{
		CGPoint position = s.layer.position;
		position.x += 1.0;
		s.layer.position = position;
	}
}

// The initial position of a segment that is meant to be displayed on the left side of the graph.
// This positioning is meant so that a few entries must be added to the segment's history before it becomes
// visible to the user. This value could be tweaked a little bit with varying results, but the X coordinate
// should never be larger than 16 (the center of the text view) or the zero values in the segment's history
// will be exposed to the user.
#define kSegmentInitialPosition CGPointMake(14.0, 60.0);

-(GraphViewSegment*)addSegment
{
    //CGRect rect = self.frame;
    // Create a new segment and add it to the segments array.
	GraphViewSegment * segment = [[GraphViewSegment alloc] initWithHeight:self.frame.size.height];
	// We add it at the front of the array because -recycleSegment expects the oldest segment
	// to be at the end of the array. As long as we always insert the youngest segment at the front
	// this will be true.
	[segments insertObject:segment atIndex:0];
	
	// Ensure that newly added segment layers are placed after the text view's layer so that the text view
	// always renders above the segment layer.
	[self.layer insertSublayer:segment.layer below:graphTextView.layer];
    
    initialSegmentPosition = CGPointMake(14.0, self.frame.size.height/2);
	segment.layer.position = initialSegmentPosition;
	
	return segment;
}

-(void)recycleSegment
{
	GraphViewSegment * last = [segments lastObject];
    
	if(/* DISABLES CODE */ (YES)==YES)//([last isVisibleInRect:self.layer.bounds])
	{
		current = [self addSegment];
	}
	else
	{
		[last reset];
		last.layer.position = initialSegmentPosition;
		// Move the segment from the last position in the array to the first position in the array
		[segments insertObject:last atIndex:0];
		[segments removeLastObject];
		// And make it our current segment
		current = last;
	}
}

-(void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Fill in the background
	CGContextSetFillColorWithColor(context, graphBackgroundColor());
	CGContextFillRect(context, self.bounds);
	
	//CGFloat width = self.bounds.size.width;
	//CGContextTranslateCTM(context, 0.0, 120.0); // shifts y axis
    
	// Draw the grid lines
	//DrawGridlines(context, 0.0, width);
}


// Return an up-to-date value for the graph.
- (NSString *)accessibilityValue
{
	if (segments.count == 0)
	{
		return nil;
	}
	
	// Let the GraphViewSegment handle its own accessibilityValue;
	GraphViewSegment *graphViewSegment = [segments objectAtIndex:0];
	return [graphViewSegment accessibilityValue];
}

-(void)selectFilter:(int)tabIndex
{
    
    switch (tabIndex) {
        case 0: //acceleration
            self.graphTextView.stringA = @"X";
            self.graphTextView.stringB = @"Y";
            self.graphTextView.stringC = @"Z";
            break;
        case 1: // attitude
            self.graphTextView.stringA = @"R";
            self.graphTextView.stringB = @"P";
            self.graphTextView.stringC = @"Y";
            break;
        case 2: //rotation
            self.graphTextView.stringA = @"X";
            self.graphTextView.stringB = @"Y";
            self.graphTextView.stringC = @"Z";
            break;
        case 3: // heading
            
            break;
        case 4: //gravity
            
            break;
        default:
            NSLog(@"unexpected tab selection %d", tabIndex);
            break;
    }
    
    [self.graphTextView setNeedsDisplay];
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
	[application_Defaults setObject:[NSNumber numberWithInt:tabIndex] forKey:DEFAULTS_REC_GRAPH_TYPE_SETTING];
	[application_Defaults synchronize];
    //default_RecorderGraphViewType,
    
	// Inform accessibility clients that the filter has changed.
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

@end
