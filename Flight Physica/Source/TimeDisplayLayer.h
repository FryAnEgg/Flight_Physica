//
//  TimeDisplayLayer.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TimeDisplayLayer : NSObject <CALayerDelegate>{
    CALayer * _layer;
    NSString *_timeString;
    NSTimeInterval _seconds;
    
    UIColor * theColor;
    UIFont * theFont;
    
}
@property (nonatomic, retain) CALayer * layer;
@property (nonatomic, retain) NSString *timeString;
@property (nonatomic, assign) NSTimeInterval seconds;

@property (nonatomic, retain)UIColor * theColor;
@property (nonatomic, retain)UIFont * theFont;
@end

