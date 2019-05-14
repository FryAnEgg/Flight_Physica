//
//  FlightManagedDocument.h
//  Flight Physica
//
//  Created by David Lathrop on 1/9/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "MetaData.h"

@interface FlightManagedDocument : UIManagedDocument

-(MetaData *)fetchMetaData;

-(void) addGraphMarker;
-(NSArray *)fetchGraphMarkerPoints;

-(NSArray *)fetchLocations;

-(NSArray *)fetchAltitudes;

@end
