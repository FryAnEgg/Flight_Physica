//
//  MetaData.h
//  Flight Physica
//
//  Created by David Lathrop on 4/25/15.
//  Copyright (c) 2015 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MetaData : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * gpsInterval;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * motionInterval;
@property (nonatomic, retain) NSNumber * pictureInterval;
@property (nonatomic, retain) NSString * pilot;
@property (nonatomic, retain) NSString * plane;
@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) NSNumber * stopTime;

@end
