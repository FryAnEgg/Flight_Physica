//
//  FPh_FlightData.h
//  Flight Physica
//
//  Created by David Lathrop on 1/9/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPh_FlightData : NSObject
{
    NSArray * _motionData;
    NSArray * _filteredData;
}

@property(nonatomic, retain) NSArray * motionData;

@property(nonatomic, retain) NSArray * filteredData;

-(void) filterData : (BOOL) bContinue compression:(int)compression;

-(void) removeDataBeforeTime : (NSTimeInterval)time  aftertime:(NSTimeInterval)aftertime;
-(NSTimeInterval) firstTime;
-(NSTimeInterval) lastTime;

@end
