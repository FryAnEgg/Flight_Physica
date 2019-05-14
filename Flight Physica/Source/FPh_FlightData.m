//
//  FPh_FlightData.m
//  Flight Physica
//
//  Created by David Lathrop on 1/9/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_FlightData.h"

#import "DeviceMotionObject.h"
#import "FPh_GraphData.h"

@implementation FPh_FlightData

@synthesize motionData = _motionData;
@synthesize filteredData = _filteredData;

-(void) filterData :(BOOL)addResults compression:(int)compression {
    
    NSMutableArray * fArray = [ NSMutableArray arrayWithCapacity:1000 ];
    int ctr1 = 0;
    //double divBy = 4.0;
    
    FPh_GraphData * accData = [[ FPh_GraphData alloc ] init ];
    
    //FPh_GraphData * lastData = [[ FPh_GraphData alloc ] init ];
    
    for (int i=0; i<self.motionData.count; i++) {
        
        DeviceMotionObject * motionPoint = [self.motionData objectAtIndex:i];
        
        FPh_GraphData * fData = [[ FPh_GraphData alloc ] init ];
        
        fData.attRoll = [motionPoint.attRoll doubleValue];
        fData.attPitch = [motionPoint.attPitch doubleValue];
        fData.attYaw = [motionPoint.attYaw doubleValue];
        fData.accx = [motionPoint.accx doubleValue];
        fData.accy = [motionPoint.accy doubleValue];
        fData.accz = [motionPoint.accz doubleValue];
        fData.rotx = [motionPoint.rotx doubleValue];
        fData.roty = [motionPoint.roty doubleValue];
        fData.rotz = [motionPoint.rotz doubleValue];
        fData.gravx = [motionPoint.gravx doubleValue];
        fData.gravy = [motionPoint.gravy doubleValue];
        fData.gravz = [motionPoint.gravz doubleValue];
        fData.timestamp = [motionPoint.timestamp doubleValue];
        
        // filters for near identical timestamps (if needed)
        /*
         if(i>0) { // compare to last timestamp
         //NSLog(@" TS 1 %6.4F %6.4F",(float)fData.timestamp, (float)lastData.timestamp);
         if ( fData.timestamp - lastData.timestamp < 0.01) {
         ctr1++;
         NSLog(@"filterData timestamp match - %d", ctr1);
         // average with last
         lastData.attRoll = (fData.attRoll + lastData.attRoll)/2.0;
         lastData.attPitch = (fData.attPitch + lastData.attPitch)/2.0;
         lastData.attYaw = (fData.attYaw + lastData.attYaw)/2.0;
         lastData.accx = (fData.accx + lastData.accx)/2.0;
         lastData.accy = (fData.accy + lastData.accy)/2.0;
         lastData.accz = (fData.accz + lastData.accz)/2.0;
         lastData.rotx = (fData.rotx + lastData.rotx)/2.0;
         lastData.roty = (fData.roty + lastData.roty)/2.0;
         lastData.rotz = (fData.rotz + lastData.rotz)/2.0;
         lastData.gravx = (fData.gravx + lastData.gravx)/2.0;
         lastData.gravy = (fData.gravy + lastData.gravy)/2.0;
         lastData.gravz = (fData.gravz + lastData.gravz)/2.0;
         
         } else {
         
         FPh_GraphData * listData = [[ FPh_GraphData alloc ] init ];
         listData.attRoll = lastData.attRoll;
         listData.attPitch = lastData.attPitch;
         listData.attYaw = lastData.attYaw;
         listData.accx = lastData.accx;
         listData.accy = lastData.accy;
         listData.accz = lastData.accz;
         listData.rotx = lastData.rotx;
         listData.roty = lastData.roty;
         listData.rotz = lastData.rotz;
         listData.gravx = lastData.gravx;
         listData.gravy = lastData.gravy;
         listData.gravz = lastData.gravz;
         listData.timestamp = lastData.timestamp;
         
         [ fArray addObject:listData ];
         
         }
         }
         */
        
        /*lastData.attRoll = [motionPoint.attRoll doubleValue];
         lastData.attPitch = [motionPoint.attPitch doubleValue];
         lastData.attYaw = [motionPoint.attYaw doubleValue];
         lastData.accx = [motionPoint.accx doubleValue];
         lastData.accy = [motionPoint.accy doubleValue];
         lastData.accz = [motionPoint.accz doubleValue];
         lastData.rotx = [motionPoint.rotx doubleValue];
         lastData.roty = [motionPoint.roty doubleValue];
         lastData.rotz = [motionPoint.rotz doubleValue];
         lastData.gravx = [motionPoint.gravx doubleValue];
         lastData.gravy = [motionPoint.gravy doubleValue];
         lastData.gravz = [motionPoint.gravz doubleValue];
         lastData.timestamp = [motionPoint.timestamp doubleValue];
         */
        
        if (compression == 1){
            
            fData.attRoll = [motionPoint.attRoll doubleValue];
            fData.attPitch = [motionPoint.attPitch doubleValue];
            fData.attYaw = [motionPoint.attYaw doubleValue];
            fData.accx = [motionPoint.accx doubleValue];
            fData.accy = [motionPoint.accy doubleValue];
            fData.accz = [motionPoint.accz doubleValue];
            fData.rotx = [motionPoint.rotx doubleValue];
            fData.roty = [motionPoint.roty doubleValue];
            fData.rotz = [motionPoint.rotz doubleValue];
            fData.gravx = [motionPoint.gravx doubleValue];
            fData.gravy = [motionPoint.gravy doubleValue];
            fData.gravz = [motionPoint.gravz doubleValue];
            fData.timestamp = [motionPoint.timestamp doubleValue];
            
            [ fArray addObject:fData ];
            
        } else {
            
            ctr1++;
            
            if (ctr1 <= compression) {
                
                accData.attRoll += [motionPoint.attRoll doubleValue];
                accData.attPitch += [motionPoint.attPitch doubleValue];
                accData.attYaw += [motionPoint.attYaw doubleValue];
                accData.accx += [motionPoint.accx doubleValue];
                accData.accy += [motionPoint.accy doubleValue];
                accData.accz += [motionPoint.accz doubleValue];
                accData.rotx += [motionPoint.rotx doubleValue];
                accData.roty += [motionPoint.roty doubleValue];
                accData.rotz += [motionPoint.rotz doubleValue];
                accData.gravx += [motionPoint.gravx doubleValue];
                accData.gravy += [motionPoint.gravy doubleValue];
                accData.gravz += [motionPoint.gravz doubleValue];
                accData.timestamp += [motionPoint.timestamp doubleValue];
                
            } else {
                
                double numberOfRecords = [[ NSNumber numberWithInt:compression ] doubleValue ];
                
                fData.attRoll = accData.attRoll / numberOfRecords;
                fData.attPitch = accData.attPitch / numberOfRecords;
                fData.attYaw = accData.attYaw / numberOfRecords;
                fData.accx = accData.accx / numberOfRecords;
                fData.accy = accData.accy / numberOfRecords;
                fData.accz = accData.accz / numberOfRecords;
                fData.rotx = accData.rotx / numberOfRecords;
                fData.roty = accData.roty / numberOfRecords;
                fData.rotz = accData.rotz / numberOfRecords;
                fData.gravx = accData.gravx / numberOfRecords;
                fData.gravy = accData.gravy / numberOfRecords;
                fData.gravz = accData.gravz / numberOfRecords;
                fData.timestamp = accData.timestamp / numberOfRecords;
                
                [ fArray addObject:fData ];
                
                accData.attRoll = 0.0;
                accData.attPitch = 0.0;
                accData.attYaw = 0.0;
                accData.accx = 0.0;
                accData.accy = 0.0;
                accData.accz = 0.0;
                accData.rotx = 0.0;
                accData.roty = 0.0;
                accData.rotz = 0.0;
                accData.gravx = 0.0;
                accData.gravy = 0.0;
                accData.gravz = 0.0;
                accData.timestamp = 0.0;
                
                ctr1 = 0;
                
            }
        }
    }
    
    if (!addResults) {
        self.filteredData = [ NSArray   array ];
    }
    
    self.filteredData = [ self.filteredData arrayByAddingObjectsFromArray:fArray ];
    
    //NSLog(@"ZZFlightData-filterData count = %d - %d", fArray.count, self.filteredData.count);
    
}


-(void) removeDataBeforeTime : (NSTimeInterval)time  aftertime:(NSTimeInterval)aftertime {
    
    NSMutableArray * array = [ NSMutableArray array ];
    
    for (int i=0; i<self.filteredData.count; i++) {
        FPh_GraphData * fData = [ self.filteredData objectAtIndex:i ];
        
        if (fData.timestamp >=  time && fData.timestamp <= aftertime
            ) {
            [array insertObject:fData atIndex:[array count] ];
        } else {
            //NSLog(@"removing point");
        }
    }
    
    self.filteredData = [ NSArray arrayWithArray:array ];
    
}

-(NSTimeInterval) firstTime {
    if (self.filteredData.count > 0) {
        FPh_GraphData * fData = [ self.filteredData objectAtIndex:0 ];
        return fData.timestamp;
    } else {
        return 0.0;
    }
}

-(NSTimeInterval) lastTime {
    if (self.filteredData.count > 0) {
        FPh_GraphData * fData = [ self.filteredData objectAtIndex:self.filteredData.count-1 ];
        return fData.timestamp;
    } else {
        return 0.0;
    }
}
@end

