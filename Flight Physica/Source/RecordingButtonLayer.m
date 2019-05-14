//
//  RecordingButtonLayer.m
//  Flight Physica
//
//  Created by David Lathrop on 4/2/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "RecordingButtonLayer.h"

@implementation RecordingButtonLayer

@synthesize isRunning, mLayer, flashLayer;

-(id) init {
    
    self = [ super init ];
    
	if ( self != nil )
	{
        isRunning = NO;
        
        self.mLayer = [ [CALayer alloc] init];
        self.mLayer.delegate = self;
        self.mLayer.backgroundColor = [ UIColor clearColor ].CGColor;
        self.mLayer.bounds = CGRectMake(0., 0., 10., 10.);
       
        self.flashLayer = [ [CALayer alloc] init];
        self.flashLayer.delegate = self;
        self.flashLayer.backgroundColor = [ UIColor clearColor ].CGColor;
        self.flashLayer.bounds = CGRectMake(0., 0., 100., 100.);
        
    }
    return self;

}

#pragma mark drawing
//////////////////////////////
-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context
 {
 
     if( l == self.mLayer ) {
         
         //CGContextSetStrokeColorWithColor ( context, [UIColor blueColor].CGColor );
         //CGContextStrokeRectWithWidth(context, self.mLayer.bounds, 3.0);
 
         CGContextSetFillColorWithColor ( context, [UIColor darkGrayColor].CGColor );
         //change this color here
         CGContextFillRect( context, self.mLayer.bounds);
         
         NSString * rString = NSLocalizedString(@"Stop", @"");
         CGContextSetFillColorWithColor ( context, [ UIColor whiteColor ].CGColor );
         float fontsize = 14.0;
         if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
             fontsize = 28.0;
         }
         UIFont *font = [ UIFont fontWithName:@"Helvetica" size:fontsize ];
         CGSize sSize = [ rString sizeWithFont:font ];
         
         //CGFloat rx4draw = 0.0;
         //CGFloat ry4draw = 0.0;
         
         CGFloat rx4draw = l.bounds.origin.x+0.5*l.bounds.size.width-0.5*sSize.width;
         CGFloat ry4draw = l.bounds.origin.y+0.5*l.bounds.size.height+0.5*sSize.height;
         
         CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
         CGContextSelectFont(context, "Helvetica", fontsize, kCGEncodingMacRoman);
         CGContextSetTextDrawingMode(context, kCGTextFill);
         
         CGContextShowTextAtPoint(context, rx4draw , ry4draw , [ rString UTF8String ], [ rString length ] );
         
     } else if( l == self.flashLayer ) {
         
         //CGContextSetStrokeColorWithColor ( context, [UIColor blueColor].CGColor );
         //CGContextStrokeRectWithWidth(context, self.flashLayer.bounds, 3.0);
         
         CGContextSetFillColorWithColor ( context, [UIColor redColor].CGColor );
         CGContextAddArc(context, self.flashLayer.bounds.size.width/2., self.flashLayer.bounds.size.height/2., self.flashLayer.bounds.size.height/2., 0., 6.3, 0);
         CGContextFillPath(context);
         
     }
     
 /*   FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
 
 if(self.isSelected){
 
 CGContextSetStrokeColorWithColor ( context, [UIColor blueColor].CGColor );
 
 CGContextStrokeRectWithWidth( context, self.layer.bounds, [self.lineWidth floatValue]);
 
 float gridSize = 100.0;
 float nextLine = 0.0;
 while ( nextLine < self.layer.bounds.size.width) {
 CGContextSetLineWidth(context, 3.0);
 CGContextMoveToPoint(context, nextLine, 0.0);
 CGContextAddLineToPoint(context, nextLine, l.bounds.size.height);
 CGContextStrokePath(context);
 
 nextLine+=gridSize;
 }
 
 nextLine = 0.0;
 while ( nextLine < self.layer.bounds.size.height) {
 CGContextMoveToPoint(context, 0.0, nextLine );
 CGContextAddLineToPoint(context, l.bounds.size.width, nextLine);
 CGContextStrokePath(context);
 
 nextLine+=gridSize;
 }
 }
 
 float scalex = l.bounds.size.width/([self.graphMaxTime floatValue]-[self.graphMinTime floatValue]);
 
 // we need scale and shiftx
 NSTimeInterval oldStamp = 0.0;
 
 //flip it
 //CGContextScaleCTM(context, 1.0, -1.0);
 
 BOOL bFirstPointDrawn = NO;
 
 int  drawCycleLimit = 100;
 int  drawCycleCount = -1;
 
 // draw zero base line
 CGContextSetStrokeColorWithColor ( context, self.lineColor.CGColor );
 CGContextSetLineWidth(context, 3.0);
 CGContextMoveToPoint(context, 0.0, self.zeroPointY );
 CGContextAddLineToPoint( context, l.bounds.size.width, self.zeroPointY );
 CGContextStrokePath(context);
 
 CGContextSetStrokeColorWithColor ( context, self.lineColor.CGColor );
 
 //NSLog(@"[appDelegate.flightData.filteredData count] = %d",[appDelegate.flightData.filteredData count]);
 
 if ([appDelegate.flightData.filteredData count] == 0) {
 //    show fetching graphic
 // or could just be empty ...
 NSString * string = NSLocalizedString(@"fetching...", @"");
 CGContextSetFillColorWithColor ( context, [ UIColor grayColor ].CGColor );
 UIFont * theFont =  [ UIFont fontWithName:@"Helvetica" size:128.0 ];
 CGSize sSize = [ string sizeWithFont:theFont ];
 
 CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
 CGContextSelectFont(context, "Helvetica", 128.0, kCGEncodingMacRoman);
 CGContextSetTextDrawingMode(context, kCGTextFill);
 
 CGContextShowTextAtPoint(context, l.bounds.size.width / 2 - sSize.width/2 , l.bounds.size.height - 25 , [ string UTF8String ], [ string length ] );
 //
 } else {
 
 for (int j=0; j<[appDelegate.flightData.filteredData count]; j++) {
 
 drawCycleCount++;
 
 FPh_GraphData * motionPoint = [appDelegate.flightData.filteredData objectAtIndex:j];
 
 NSTimeInterval stamp = motionPoint.timestamp;
 
 if (oldStamp>stamp) {
 NSLog(@"oldStamp>stamp");
 }
 oldStamp = stamp;
 
 NSNumber * stampNumber = [NSNumber numberWithDouble:stamp ];
 
 if ( stamp < [self.graphMinTime doubleValue]) {
 continue;
 }
 if ( stamp > [self.graphMaxTime doubleValue]) {
 continue;
 }
 
 double yValue = [ self getLayerYValue: motionPoint ];
 
 double graphYValue = yValue * self.scaley + self.zeroPointY;
 
 CGPoint graphPoint = CGPointMake( (stamp-[self.graphMinTime doubleValue]) * scalex, graphYValue );
 
 if (bFirstPointDrawn==NO) {
 CGContextMoveToPoint(context, graphPoint.x, graphPoint.y );
 bFirstPointDrawn = YES;
 } else {
 CGContextAddLineToPoint( context, graphPoint.x, graphPoint.y );
 }
 
 if (drawCycleCount >= drawCycleLimit) {
 drawCycleCount = -1;
 if(self.isSelected){
 CGContextSetLineWidth(context, 2*[self.lineWidth floatValue]);
 } else {
 CGContextSetLineWidth(context, [self.lineWidth floatValue]);
 }
 CGContextStrokePath(context);
 CGContextMoveToPoint(context, graphPoint.x, graphPoint.y );
 }
 }
 
 if(self.isSelected){
 CGContextSetLineWidth(context, 2*[self.lineWidth floatValue]);
 } else {
 CGContextSetLineWidth(context, [self.lineWidth floatValue]);
 }
 CGContextStrokePath(context);
 }
 */
 }


//	doRecordAnimation
///////////////////////////////////////////////////////////
-(CAKeyframeAnimation *) doRecordAnimation {
	
	CATransform3D t1 = CATransform3DRotate( self.mLayer.transform, 1.570796, 0, 0, 1);//PIOVER2
	CATransform3D t2 = CATransform3DRotate( t1, 1.570796, 0, 0, 1);
	CATransform3D t3 = CATransform3DRotate( t2, 1.570796, 0, 0, 1);
	
	NSArray * array = [ NSArray arrayWithObjects :
					   [ NSValue valueWithCATransform3D:self.mLayer.transform],
					   [ NSValue valueWithCATransform3D:t1],
					   [ NSValue valueWithCATransform3D:t2],
					   [ NSValue valueWithCATransform3D:t3],
					   [ NSValue valueWithCATransform3D:self.mLayer.transform], nil ];
	
	CAKeyframeAnimation * theAnimation;
	
	// create the animation object, specifying the position property as the key path
	// the key path is relative to the target animation object (in this case a CALayer)
	theAnimation= [CAKeyframeAnimation animationWithKeyPath:@"transform" ];//@"transform.rotation.z" ];
	theAnimation.values=array;
	
	theAnimation.repeatCount = 1.0;
	theAnimation.duration=2.0; //repeatDuration
	theAnimation.delegate = self;
	theAnimation.removedOnCompletion = NO;
	
	[ self.mLayer addAnimation:theAnimation forKey:@"spinOut" ];
    
	return theAnimation;
    
	/*
	 CABasicAnimation *transformAni = [ CABasicAnimation animation ];
	 transformAni.fromValue = [ NSValue valueWithCATransform3D:layer.transform];
	 
	 transformAni.duration = 2.0;
	 transformAni.repeatCount = 5.0;
	 // We make ourselves the delegate to get notified when the animation ends
	 transformAni.delegate = self;
	 layer.transform = CATransform3DMakeRotation (20.0, 0, 0, 1.0); //CATransform3DIdentity;
	 [layer addAnimation:transformAni forKey:@"transform"];
	 */
	
}

//	doRecordAnimation
///////////////////////////////////////////////////////////
-(CAKeyframeAnimation *) doFlashAnimation {
   
    NSArray * array = [NSArray arrayWithObjects :
					   [NSNumber numberWithFloat:0.0],
					   [NSNumber numberWithFloat:0.1],
					   [NSNumber numberWithFloat:0.2],
					   [NSNumber numberWithFloat:0.3],
                       [NSNumber numberWithFloat:0.4],
                       [NSNumber numberWithFloat:0.1],
                       [NSNumber numberWithFloat:0.0],
                       nil ];
	
	
	
	// create the animation object, specifying the position property as the key path
	// the key path is relative to the target animation object (in this case a CALayer)
	CAKeyframeAnimation * fadeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity" ];//@"transform.rotation.z" ];
	fadeAnimation.values=array;
	fadeAnimation.repeatCount = 1.0;
	fadeAnimation.duration=1.0; //repeatDuration
	fadeAnimation.delegate = self;
	fadeAnimation.removedOnCompletion = NO;
    
    [self.flashLayer addAnimation:fadeAnimation forKey:@"flashOut"];
    
    //[CATransaction begin];
    //[CATransaction setValue:[NSNumber numberWithFloat:0.0f]
    //                 forKey:kCATransactionAnimationDuration];
    
    //self.flashLayer.opacity = 0.0; // animate to not animate
    //[CATransaction commit];
	
	//[ self.flashLayer addAnimation:theAnimation forKey:@"flashOut" ];
	return fadeAnimation;
    
	/*
	 CABasicAnimation *transformAni = [ CABasicAnimation animation ];
	 transformAni.fromValue = [ NSValue valueWithCATransform3D:layer.transform];
	 
	 transformAni.duration = 2.0;
	 transformAni.repeatCount = 5.0;
	 // We make ourselves the delegate to get notified when the animation ends
	 transformAni.delegate = self;
	 layer.transform = CATransform3DMakeRotation (20.0, 0, 0, 1.0); //CATransform3DIdentity;
	 [layer addAnimation:transformAni forKey:@"transform"];
	 */
	
}


#pragma mark - CAAnimation delegate

//- (void)animationDidStart:(CAAnimation *)theAnimation {
    
//}

//	animationDidStop
////////////////////////
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {

    if ( [ self.mLayer animationForKey : @"spinOut" ] == theAnimation ) {
        if (isRunning){
            [self doRecordAnimation];
        }
    }
    
     else if ( [ self.flashLayer animationForKey : @"flashOut" ] == theAnimation ) {
        if (isRunning){
            [self doFlashAnimation];
        }
    }
   
    //[ super animationDidStop:theAnimation finished:flag ];
    
  /*  if ( [ self.layer animationForKey : @"spinOut" ] == theAnimation ) {
        if(bSpinningOut) {
            [self doSpinAnimation];
        } else {
            //resume motion
            self.movementDuration = 0.5;
            
        }
        return;
    }
    
    _pathIndex ++;
    if (_pathIndex >= self.currentPath.count) {
        //NSLog(@"animationDidStop EOP");
        return;
    }
    
    SquareCell * newCell = [ self.currentPath objectAtIndex:_pathIndex ];
    SquareCell * oldCell = (SquareCell*) self.cell;
    
    [self.cell.monsterArray removeObject:self];
    [ newCell.monsterArray addObject:self];
    
    self.cell = newCell;
    
    if (_pathIndex + 1 < self.currentPath.count) {
        self.nextCell = [ self.currentPath objectAtIndex:_pathIndex+1 ];
        [ self spinLayer ]; // still have a path
    } else { // keep moving to new adjacent cell
        
        SquareCell* nextCell = [ self decideNextPathCell:newCell previous:oldCell ];
        
        if(nextCell){
            [self.currentPath addObject:nextCell];
            [ self spinLayer ];
        }
    }
    
    //CABasicAnimation *posAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    // set the fromValue and toValue to the appropriate points
    //posAnimation.fromValue=[NSValue valueWithPoint:NSMakePoint(74.0,74.0)];
    //posAnimation.toValue=[NSValue valueWithPoint:newCell.screenCenter];
    // set the duration to 3.0 seconds
    //posAnimation.duration=0.0;
    
    //[self.layer addAnimation:posAnimation forKey:@"position"];
    
    //CABasicAnimation* anim1 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    //CGRect f = v2.layer.bounds;
    //f.size.width = v.layer.bounds.size.width;
    //v2.layer.bounds = f;
    //[v2.layer addAnimation: anim1 forKey: nil];
   */
}

@end
