//
//  GraphMarkerObject.h
//  Flight Physica
//
//  Created by David Lathrop on 2/19/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface GraphMarkerObject : NSManagedObject {
    
}

@property(nonatomic, strong)NSString * annotation;
@property(nonatomic, strong)NSNumber * datatype;
@property(nonatomic, strong)NSDate * markDate;

@property(nonatomic, strong)NSNumber * style;
@property(nonatomic, strong)NSNumber * value;

@property(nonatomic, strong) NSNumber * timestamp;

- (NSComparisonResult)timestampCompare:(GraphMarkerObject *)aMotion;

@end
