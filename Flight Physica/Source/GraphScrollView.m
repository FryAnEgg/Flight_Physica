//
//  GraphScrollView.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "GraphScrollView.h"

#import "FlightAppConstants.h"

@implementation GraphScrollView

@synthesize graphView;

-(void) awakeFromNib {
    
    [super awakeFromNib];
    
    //self.showsVerticalScrollIndicator = NO;
    //self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate = self;  // or leave with controller
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSUserDefaults		*application_Defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * width = [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_WIDTH];
    NSNumber *  height= [application_Defaults objectForKey:DEFAULTS_GRAPH_SIZE_HEIGHT];
    
    self.graphView = [[FPh_GraphView alloc] initWithFrame:CGRectMake(0, 0, [width floatValue], [height floatValue])];
    
    [self.graphView initGraphLayers];
    
    [self addSubview:self.graphView];
    
    [self setContentSize: CGSizeMake ([width floatValue],[height floatValue])];
    
     //CGMakeSize( [width floatValue],[height floatValue] )];
    
    //UIGestureRecognizer *recognizer = [[ UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    //[self.graphView addGestureRecognizer:recognizer];
    
    //self.zoomScale = self.minimumZoomScale;
    
}

- (id)initWithFrame:(CGRect)frame
{ // not called with xib loading
    if ((self = [super initWithFrame:frame])) {
        //self.showsVerticalScrollIndicator = NO;
        //self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}


- (void) handleLongPress :(UILongPressGestureRecognizer *)recognizer {
    NSLog(@"handleLongPress");
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark -
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews
{
    [super layoutSubviews];
    /*
    // center the image as it becomes smaller than the size of the screen
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.graphView.frame;
    //CGRect boundsToCenter = self.graphView.bounds;
    //BOOL arsv = self.autoresizesSubviews;
    
    CGSize size = self.contentSize;
    //- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
    
    self.graphView.frame = frameToCenter;
    
    //if ([mapView isKindOfClass:[TilingView class]]) {
    // to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
    // tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
    // which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
    //    mapView.contentScaleFactor = 1.0;
    //}
     */
    
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.graphView;
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
    //CGPoint offset = scrollView.contentOffset;
    ;
    //NSLog(@"scrollViewDidEndZooming scale=%4.2f ox=%4.2f oy=%4.2f ", scale,offset.x,offset.y);
    //NSLog(@"*********************** cWidth=%4.2f cHeight=%4.2f", scrollView.contentSize.width ,scrollView.contentSize.height);
    
//}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = self.graphView.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / (imageSize.width);    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / (imageSize.height);  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    //CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    CGFloat maxScale = 1.0;
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    if (minScale<0.2) {
        minScale = 0.2;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    
    self.zoomScale = self.minimumZoomScale;
    
}


-(void) centerOnPoint:(CGPoint)point {
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint boundsLowRight = CGPointMake(self.bounds.origin.x+self.bounds.size.width,self.bounds.origin.y+self.bounds.size.height);
    CGPoint bgdCenter = [self convertPoint:boundsCenter toView:self.graphView];
    CGPoint bgdUpLeft = [self convertPoint:self.bounds.origin toView:self.graphView];
    CGPoint bgdLowRight = [self convertPoint:boundsLowRight toView:self.graphView];
    
    BOOL bPointOffscreen = YES; // offscreen or close to edge
    float edgeInset = 200.0;
    if (point.x > bgdUpLeft.x+edgeInset && point.y > bgdUpLeft.y+edgeInset) {
        if (point.x < bgdLowRight.x-edgeInset && point.y < bgdLowRight.y-edgeInset) {
            bPointOffscreen = NO;
        }
    }
    
    if(bPointOffscreen){
        float offset_x = self.contentOffset.x - bgdCenter.x+point.x;
        float maxOffsetX =  self.graphView.frame.size.width - self.bounds.size.width;
        if (offset_x < 0.0) {
            offset_x = 0.0;
        } else if (offset_x > maxOffsetX) {
            offset_x = maxOffsetX;
        }
        float offset_y = self.contentOffset.y - bgdCenter.y+point.y;
        float maxOffsetY =  self.graphView.frame.size.height - self.bounds.size.height;
        if (offset_y < 0.0) {
            offset_y = 0.0;
        } else if (offset_y > maxOffsetY) {
            offset_y = maxOffsetY;
        }
        
        CGPoint newOffset = CGPointMake( offset_x,offset_y   );
        
        // we should animate tbi
        self.contentOffset = newOffset;
    }
    
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

// returns the center point, in image coordinate space, to try to restore after rotation.
- (CGPoint)pointToCenterAfterRotation
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:self.graphView];
}

// returns the zoom scale to attempt to restore after rotation.
- (CGFloat)scaleToRestoreAfterRotation
{
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (contentScale <= self.minimumZoomScale + FLT_EPSILON)
        contentScale = 0;
    
    return contentScale;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale
{
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:self.graphView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    self.contentOffset = offset;
}

#pragma mark - UIScrollView overrides
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    //NSLog(@"touchesShouldBegin");
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    //NSLog(@"touchesShouldCancelInContentView");
    return NO;
}

@end
