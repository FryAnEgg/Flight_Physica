//
//  FPh_AppDelegate.h
//  Flight Physica
//
//  Created by David Lathrop on 1/5/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FPh_FlightData.h"
#import "MotionRecorder.h"

@interface FPh_AppDelegate : UIResponder <UIApplicationDelegate> {
    
    NSURL* _activeDocumentURL;
    NSMutableDictionary* _fileData;
    
    MotionRecorder * _motionRecorder;
    FPh_FlightData * _flightData;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) NSURL* activeDocumentURL;

@property (nonatomic, retain) NSMutableDictionary* fileData;

@property(nonatomic, retain) MotionRecorder * motionRecorder;

@property(nonatomic, retain) FPh_FlightData * flightData;

- (NSUInteger)calculateNextFileIndex:(BOOL)updateIndex;
- (NSString *) nextDefaultFileName :(BOOL)updateIndex;
- (void) createManagedDocument:(NSString*) filename;

- (void) addMetaData;
- (void)saveContext:(FlightManagedDocument *) document;

//-(NSURL*) expCloudURL;
-(NSURL*) expLocalURL;

//-(NSURL*) cloudURL;
-(NSURL*) localURL;

@end
