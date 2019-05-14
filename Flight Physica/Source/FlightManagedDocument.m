//
//  FlightManagedDocument.m
//  Flight Physica
//
//  Created by David Lathrop on 1/9/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FlightManagedDocument.h"
#import "FlightAppConstants.h"
#import "GraphMarkerObject.h"


@implementation FlightManagedDocument

-(MetaData *)fetchMetaData {
    
    NSManagedObjectContext* moc = self.managedObjectContext;
    moc.mergePolicy = NSRollbackMergePolicy;
    
    NSFetchRequest* metaDataRequest =  [NSFetchRequest fetchRequestWithEntityName:@"MetaData"];
    NSArray* mdResult = [moc executeFetchRequest:metaDataRequest error:nil];
    
    MetaData * fmd;
    
    if ([mdResult count] >= 1) {
        
        fmd = (MetaData *)[mdResult objectAtIndex:0];
        
        //NSLog(@"**** metadata *****");
        //NSLog(@"name:%@",fmd.pilot);
        //NSLog(@"plane:%@",fmd.plane);
        //NSLog(@"start %4.2f",[fmd.startTime floatValue]);
        //NSLog(@"stop %4.2f",[fmd.stopTime floatValue]);
        //NSLog(@"date:%@",[fmd.date description]);
        //NSLog(@"stop %4.2f",[fmd.motionInterval floatValue]);
        //NSLog(@"*******************");
        
        //self.graphStartTime = [fmd.startTime doubleValue];
        //self.graphStopTime = [fmd.stopTime doubleValue];
        
        //self.graphScrollView.graphView.graphMinTime =  [NSNumber numberWithDouble:self.graphStartTime];
        //self.graphScrollView.graphView.startTime;
        //self.graphScrollView.graphView.graphMaxTime = [NSNumber numberWithDouble:self.graphStopTime];
        //self.graphScrollView.graphView.stopTime;
        
        // can we test change fmd.pilot here
    }
    else {
        NSLog(@"No Metadata");
        // have demonstrated that this works
        //[ self saveContext : doc ];
        return nil;
    }
    
    return fmd;
}

-(void) addGraphMarker {
    
}

-(NSArray *)fetchGraphMarkerPoints {
    
    NSManagedObjectContext* moc = self.managedObjectContext;
    moc.mergePolicy = NSRollbackMergePolicy;
    
    NSFetchRequest* markerRequest =  [NSFetchRequest fetchRequestWithEntityName:@"GraphMarker"];
    NSArray* markerResults = [moc executeFetchRequest:markerRequest error:nil];
    
    return markerResults;
}

-(NSArray *)fetchLocations {
    
    NSManagedObjectContext* moc = self.managedObjectContext;
    moc.mergePolicy = NSRollbackMergePolicy;
    
    NSFetchRequest* locationRequest =  [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    NSArray* fetchResults = [moc executeFetchRequest:locationRequest error:nil];
    
    return fetchResults;
}

-(NSArray *)fetchAltitudes {
    
    NSManagedObjectContext* moc = self.managedObjectContext;
    moc.mergePolicy = NSRollbackMergePolicy;
    
    NSFetchRequest* locationRequest =  [NSFetchRequest fetchRequestWithEntityName:@"Altitude"];
    NSArray* fetchResults = [moc executeFetchRequest:locationRequest error:nil];
    
    return fetchResults;
}





@end
