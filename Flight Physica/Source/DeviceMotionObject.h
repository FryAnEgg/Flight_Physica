//
//  DeviceMotionObject.h
//  Flight Physica
//
//  Created by David Lathrop on 1/6/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DeviceMotionObject : NSManagedObject {
    
}

@property(nonatomic, strong)NSNumber * attRoll;
@property(nonatomic, strong)NSNumber * attPitch;
@property(nonatomic, strong)NSNumber * attYaw;

@property(nonatomic, strong)NSNumber * accx;
@property(nonatomic, strong)NSNumber * accy;
@property(nonatomic, strong)NSNumber * accz;

@property(nonatomic, strong)NSNumber * rotx;
@property(nonatomic, strong)NSNumber * roty;
@property(nonatomic, strong)NSNumber * rotz;

@property(nonatomic, strong)NSNumber * gravx;
@property(nonatomic, strong)NSNumber * gravy;
@property(nonatomic, strong)NSNumber * gravz;

@property(nonatomic, strong) NSNumber * timestamp;

- (NSComparisonResult)timestampCompare:(DeviceMotionObject *)aMotion;

@end
