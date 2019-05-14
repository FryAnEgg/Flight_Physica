//
//  Location.h
//  Flight Physica
//
//  Created by David Lathrop on 5/5/15.
//  Copyright (c) 2015 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * course;
@property (nonatomic, retain) NSNumber * horizaccur;
@property (nonatomic, retain) NSNumber * vertaccur;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSDate * timestamp;

@end
