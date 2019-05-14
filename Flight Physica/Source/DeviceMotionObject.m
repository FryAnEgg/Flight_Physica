//
//  DeviceMotionObject.m
//  Flight Physica
//
//  Created by David Lathrop on 1/6/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "DeviceMotionObject.h"

@implementation DeviceMotionObject

@dynamic attRoll;
@dynamic attPitch;
@dynamic attYaw;

@dynamic accx;
@dynamic accy;
@dynamic accz;

@dynamic rotx;
@dynamic roty;
@dynamic rotz;

@dynamic gravx;
@dynamic gravy;
@dynamic gravz;

@dynamic timestamp;


- (NSComparisonResult)timestampCompare:(DeviceMotionObject *)aMotion {
    if ( [self.timestamp doubleValue] > [aMotion.timestamp doubleValue] ) {
        return NSOrderedDescending;
    } else if ( [self.timestamp doubleValue] < [aMotion.timestamp doubleValue] ){
        return NSOrderedAscending;
    }
    return NSOrderedSame;
}

/*
 #pragma mark NSCoder
 - (void)encodeWithCoder:(NSCoder *)coder {
 
 [ coder encodeDouble:self.timestamp forKey:@"time" ];
 
 [ coder encodeDouble:accx forKey:@"accx" ];
 [ coder encodeDouble:accy forKey:@"accy" ];
 [ coder encodeDouble:accz forKey:@"accz" ];
 
 [ coder encodeDouble:attRoll forKey:@"attRoll" ];
 [ coder encodeDouble:attPitch forKey:@"attPitch" ];
 [ coder encodeDouble:attYaw forKey:@"attYaw" ];
 
 [ coder encodeDouble:rotx forKey:@"rotx" ];
 [ coder encodeDouble:roty forKey:@"roty" ];
 [ coder encodeDouble:rotz forKey:@"rotz" ];
 
 [ coder encodeDouble:gravx forKey:@"gravx" ];
 [ coder encodeDouble:gravy forKey:@"gravy" ];
 [ coder encodeDouble:gravz forKey:@"gravz" ];
 
 }
 
 - (id)initWithCoder:(NSCoder *)coder {
 self = [super init];
 if (self != nil) {
 if ( [coder containsValueForKey:@"attitude"] ) {
 NSLog(@"coder contains key!");
 } else {
 NSLog(@"coder does not contain key");
 }
 
 self.timestamp = [ coder decodeDoubleForKey:@"time" ];
 
 self.accx = [ coder decodeDoubleForKey:@"accx" ];
 self.accy = [ coder decodeDoubleForKey:@"accy" ];
 self.accz = [ coder decodeDoubleForKey:@"accz" ];
 
 self.attRoll = [ coder decodeDoubleForKey:@"attRoll" ];
 self.attPitch = [ coder decodeDoubleForKey:@"attPitch" ];
 self.attYaw = [ coder decodeDoubleForKey:@"attYaw" ];
 
 self.rotx = [ coder decodeDoubleForKey:@"rotx" ];
 self.roty = [ coder decodeDoubleForKey:@"roty" ];
 self.rotz = [ coder decodeDoubleForKey:@"rotz" ];
 
 self.gravx = [ coder decodeDoubleForKey:@"gravx" ];
 self.gravy = [ coder decodeDoubleForKey:@"gravy" ];
 self.gravz = [ coder decodeDoubleForKey:@"gravz" ];
 
 }
 return self;
 }*/

@end
