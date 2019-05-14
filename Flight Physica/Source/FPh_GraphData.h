//
//  FPh_GraphData.h
//  Flight Physica
//
//  Created by David Lathrop on 1/9/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPh_GraphData : NSObject
{
    NSTimeInterval _timestamp;
    
    double _accx;
    double _accy;
    double _accz;
    
    double _attRoll;
    double _attPitch;
    double _attYaw;
    
    double _rotx;
    double _roty;
    double _rotz;
    
    double _gravx;
    double _gravy;
    double _gravz;
}

@property(nonatomic,assign) NSTimeInterval timestamp;

@property(nonatomic,assign) double accx;
@property(nonatomic,assign) double accy;
@property(nonatomic,assign) double accz;

@property(nonatomic,assign) double attRoll;
@property(nonatomic,assign) double attPitch;
@property(nonatomic,assign) double attYaw;

@property(nonatomic,assign) double rotx;
@property(nonatomic,assign) double roty;
@property(nonatomic,assign) double rotz;

@property(nonatomic,assign) double gravx;
@property(nonatomic,assign) double gravy;
@property(nonatomic,assign) double gravz;


@end
