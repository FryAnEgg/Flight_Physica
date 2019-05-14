//
//  GraphScrollView.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPh_GraphView.h"

@interface GraphScrollView : UIScrollView <UIScrollViewDelegate> {
    FPh_GraphView *  graphView;
}

@property (nonatomic,retain) IBOutlet FPh_GraphView *  graphView;

- (void)setMaxMinZoomScalesForCurrentBounds;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

@end
