//
//  FPh_FlightFileTableController.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlightManagedDocument.h"

@interface FPh_FlightFileTableController : UITableViewController<UIActionSheetDelegate> {
    
    NSMutableArray* _listOfFiles;
    NSURL* containerURL;
    NSURL* localURL;
    NSMutableArray* notifications;
    NSMutableDictionary* _urlsForFileNames;
    NSMutableDictionary* _detailStringsForFileNames;
    
    BOOL _bDisplayingCloud;
    NSString * selectedFilename;
    
    FlightManagedDocument* selectedFMdocument;
    BOOL bLoadingDocument;
}


@property (strong, nonatomic) NSMutableArray* listOfFiles;
@property (readonly, nonatomic) NSURL* containerURL;
@property (readonly, nonatomic) NSURL* localURL;
@property (strong, nonatomic) NSMutableArray* notifications;

@property (strong, nonatomic) NSMutableDictionary* urlsForFileNames;
@property (strong, nonatomic) NSMutableDictionary* detailStringsForFileNames;

@property (nonatomic,assign) BOOL bDisplayingCloud;

// -(void) checkNextDocumentMetaData:(NSTimer*)timer;

-(void)listLocalFiles;

-(void)buildCloudListFromQueryItems:(NSArray*)queryItems;

//-(void)processUpdate:(NSMetadataQuery*)query;
-(void)addNewFilesToList:(NSArray*)queryItems;
-(FlightManagedDocument*)createDocument:(NSString*)fileName;

@end
