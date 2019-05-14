//
//  GraphMarkerObject.m
//  Flight Physica
//
//  Created by David Lathrop on 2/19/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "GraphMarkerObject.h"

@implementation GraphMarkerObject


@dynamic annotation;
@dynamic datatype;
@dynamic markDate;

@dynamic style;
@dynamic value;
@dynamic timestamp;


- (NSComparisonResult)timestampCompare:(GraphMarkerObject *)aMotion {
   // if ( [self.timestamp doubleValue] > [aMotion.timestamp doubleValue] ) {
   //     return NSOrderedDescending;
   // } else if ( [self.timestamp doubleValue] < [aMotion.timestamp doubleValue] ){
    //    return NSOrderedAscending;
    //}
    return NSOrderedSame;
}

@end
