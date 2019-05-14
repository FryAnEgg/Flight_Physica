//
//  Altitude.h
//  Flight Physica
//
//  Created by David Lathrop on 5/5/15.
//  Copyright (c) 2015 Fry An Egg Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Altitude : NSManagedObject

@property (nonatomic, retain) NSNumber * relativeAltitude;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) NSNumber * timestamp;

@end
