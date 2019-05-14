//
//  FPh_FlightFileTableController.m
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_FlightFileTableController.h"

#import <CoreData/CoreData.h>

#import "MetaData.h"
#import "FPh_AppDelegate.h"
#import "FPh_GraphViewController.h"

@interface FPh_FlightFileTableController ()
//@property (readonly, nonatomic, getter = isCloudEnabled) BOOL cloudEnabled;
@end

@implementation FPh_FlightFileTableController

@synthesize listOfFiles = _listOfFiles;
@synthesize urlsForFileNames = _urlsForFileNames;
@synthesize detailStringsForFileNames = _detailStringsForFileNames;
@synthesize notifications = _notifications;
@synthesize containerURL;
@synthesize localURL;
@synthesize bDisplayingCloud = _bDisplayingCloud;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSNotificationCenter * noteCen = [ NSNotificationCenter defaultCenter ];
    
    [ noteCen addObserver:self  selector:@selector(reloadTableViewNote:)name:@"reload_ tableview_notification"  object:nil];
    
    self.notifications = [NSMutableArray arrayWithCapacity:3];
    
    self.listOfFiles = [NSMutableArray array];
    
    self.detailStringsForFileNames = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [self listLocalFiles];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // We only have a single section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of entries in our weight history
    return [self.listOfFiles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString * filename = [self.listOfFiles objectAtIndex:indexPath.row ];
    
    // Configure the cell...
    cell.textLabel.text = filename;
    
    FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString * value = [appDelegate.fileData objectForKey:filename];
    if(value) {
        cell.detailTextLabel.text = value;
    } else {
        cell.detailTextLabel.text = @"";//NSLocalizedString(@"", @"");
    }
    
    //NSString * detailString = [self.detailStringsForFileNames valueForKey:filename];
    //if (detailString) {
    //    NSLog(@"detailString = %@",detailString);
    //    cell.detailTextLabel.text = detailString;
    //} else {
    //   cell.detailTextLabel.text = NSLocalizedString(@"", @"");
    //}
    
    cell.imageView.image = [UIImage imageNamed:@"fs_flightTape"];
    // kickoff timer for reading metadata
    
    return cell;
    
    //static NSString *CellIdentifier = @"Document Cell";
    //DocumentCell *cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //NSString* fileName = [self.listOfFiles objectAtIndex:indexPath.row];
    //cell.fileName.text = fileName;
    //return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSString * filename = [self.listOfFiles objectAtIndex:indexPath.row ];
    
    // if this is the activeDocument return NO...
    // self.activeFlightDocument
    
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (self.bDisplayingCloud) { //self.cloudEnabled
            
            NSString * filename = [self.listOfFiles objectAtIndex:indexPath.row ];
            NSURL* url = [self.urlsForFileNames valueForKey:filename];
            // Don't use file coordinators on the app's main queue.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSFileCoordinator *fc = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
                [fc coordinateWritingItemAtURL:url options:NSFileCoordinatorWritingForDeleting
                                         error:nil
                                    byAccessor:^(NSURL *newURL) {
                                        NSFileManager *fm = [[NSFileManager alloc] init];
                                        [fm removeItemAtURL:newURL error:nil];
                                    }];
                
            });
            // Remove from datasource
            NSLog(@"indexPath.row %ld", (long)indexPath.row);
            [ self.listOfFiles removeObjectAtIndex: indexPath.row ];
            
            // Delete the row from tableView
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } else { // cloud not enabled
            
            NSString * filename = [self.listOfFiles objectAtIndex:indexPath.row ];
            
            NSURL* url = [self.urlsForFileNames valueForKey:filename];
            
            // if we don't have a valid URL, create a local url
            if (url == nil) {
                NSLog(@"url == nil");
            } else {
                //Remove the file
                NSError * error;
                BOOL removed = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
                if (!removed) {
                    NSLog(@"!removed");
                }
                // Remove from datasource
                [self.listOfFiles removeObjectAtIndex: indexPath.row];
                
                // Delete the row from tableView
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //FR_AppDelegate* appDelegate = (FR_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //NSArray * keys = [ appDelegate.fileData allKeys ];
    //for ( int i = 0; i<keys.count; i++) {
    //    NSString * key = [ keys objectAtIndex:i ];
    //    NSLog(@"key: %@ value:%@", key, [appDelegate.fileData objectForKey:key]);
    //}
    
    if (bLoadingDocument) return;
    
    selectedFilename = [self.listOfFiles objectAtIndex:indexPath.row ];
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:selectedFilename delegate:self
                                                    cancelButtonTitle: NSLocalizedString(@"Cancel", @"") destructiveButtonTitle: nil otherButtonTitles:NSLocalizedString(@"Graph", @""),nil];
    
    //NSLocalizedString(@"Duplicate", @""),NSLocalizedString(@"Move To Cloud",
    [actionSheet showInView:self.view];
    
}


-(void) openFileGraph {
    
    bLoadingDocument = YES;
    
    // this opens in graph view
    selectedFMdocument = [self createDocument:selectedFilename];
    
    // start the wait indication
    
    [selectedFMdocument openWithCompletionHandler:^(BOOL success) {
        
        if (success == NO) {
            NSLog(@"Could not open the file %@ at %@", selectedFilename, selectedFMdocument.fileURL);
            //[NSException raise:NSGenericException format:@"Could not open the file %@ at %@", selectedFilename, document.fileURL];
        }
        
        // If we have a document, display it.
        if (selectedFMdocument != nil) {
            
            //[self.detailStringsForFileNames setValue:@"wiggy" forKey:filename];
            
            //[self fetchDocumentData : document ];
            
            // send notify to graph selected document
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"open_local_file_notification" object:selectedFMdocument userInfo:nil];
            
            [ self performSegueWithIdentifier:@"OpenGraphSegue" sender:self ];
            
        }
        
        bLoadingDocument = NO;
        
    }];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //FR_AppDelegate* appDelegate = (FR_AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //if (actionSheet.cancelButtonIndex == buttonIndex) {
    //    NSLog(@"actionSheet.cancelButtonIndex == buttonIndex");
    //}
    
    switch (buttonIndex) {
        case 0: // graph file
            [ self openFileGraph ];
            break;
            
        default:
            break;
    }
}

#pragma mark - NavBar Actions

-(IBAction)edit_Action:(id)sender {
    
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}



#pragma mark - iCloud Container URL Methods

- (NSURL*)containerURL {
    
    static NSURL* url = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        url = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    });
    
    return url;
}

- (NSURL*)localURL {
    
    static NSURL* url = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        url = [[NSFileManager defaultManager]
               URLForDirectory:NSDocumentDirectory
               inDomain:NSUserDomainMask
               appropriateForURL:nil
               create:NO
               error:nil];
    });
    
    return url;
}


#pragma mark - Loading Files

- (void)listLocalFiles {
    
    // get all the files
    NSArray* contents =  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:self.localURL
                                                       includingPropertiesForKeys:nil
                                                                          options:0
                                                                            error:nil];
    
    self.listOfFiles =  [NSMutableArray arrayWithCapacity:[contents count]];
    
    self.urlsForFileNames =  [NSMutableDictionary dictionaryWithCapacity: [contents count]];
    
    //FPh_AppDelegate* appDelegate = (FPh_AppDelegate*)[UIApplication sharedApplication].delegate;
    //NSString * activefilename = [ appDelegate.activeDocumentURL lastPathComponent ];
    
    for (NSURL* url in contents) {
        
        NSString* fileName = [url lastPathComponent];
        
        //if ([fileName compare:activefilename] != NSOrderedSame) {
        [self.listOfFiles addObject:fileName];
        [self.urlsForFileNames setValue:url forKey:fileName];
        //} else { // do nothing
        //NSLog(@"Skipping active document");
        //}
        
        
    }
    
    [self.tableView reloadData];
    
    //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(checkNextDocumentMetaData:) userInfo:nil repeats:NO];
}

/*- (void)listCloudFiles {
 
 return;
 // dont do anything here
 
 //self.title = NSLocalizedString(@"Cloud", @"Cloud");
 self.navigationItem.leftBarButtonItem.title = NSLocalizedString(@"Local", @"Local");
 //backBarButtonItem
 
 self.listOfFiles = [NSMutableArray array];
 
 // Arbitrarially chose to start with a capacity of 100.
 self.urlsForFileNames = [NSMutableDictionary dictionaryWithCapacity:100];
 
 NSMetadataQuery* query = [[NSMetadataQuery alloc] init];
 
 [query setSearchScopes: [NSArray arrayWithObject:NSMetadataQueryUbiquitousDataScope]];
 
 // We cannot look for the folder--must look for the contained DocumentMetadata.plist.
 [query setPredicate:[NSPredicate predicateWithFormat:@"%K like %@",
 NSMetadataItemFSNameKey,
 @"DocumentMetadata.plist"]];
 
 NSNotificationCenter* center =  [NSNotificationCenter defaultCenter];
 
 id observer =  [center addObserverForName:NSMetadataQueryDidFinishGatheringNotification object:query queue:nil usingBlock:^(NSNotification* notification) {
 
 NSLog(@"NSMetadataQuery finished gathering, found %d files", [query resultCount]);
 
 // what's in the iCloud container
 NSDirectoryEnumerator* enumerator =  [[NSFileManager defaultManager] enumeratorAtURL:self.containerURL includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:0 errorHandler:nil];
 
 id object;
 
 NSLog(@"iCloud Container Contents:");
 while (object = [enumerator nextObject]) {
 NSLog(@"%@\n\n", object);
 }
 NSLog(@"Done");
 
 
 // if we don't have any results, look at what is actually inside the iCloud container.
 if ([query resultCount] == 0) {
 
 // Now clear the container -- must be done inside a file coordinator
 [[[NSFileCoordinator alloc] initWithFilePresenter:nil] coordinateWritingItemAtURL:self.containerURL
 options:NSFileCoordinatorWritingForDeleting error:nil
 byAccessor:^(NSURL *newURL) {
 
 [[NSFileManager defaultManager]
 removeItemAtURL:newURL
 error:nil];
 }];
 }
 
 [ self buildCloudListFromQueryItems:query.results ];
 
 //[query enableUpdates];
 }];
 
 [self.notifications addObject:observer];
 
 observer = [center addObserverForName:NSMetadataQueryDidUpdateNotification object:query queue:nil
 usingBlock:^(NSNotification *note) {
 
 NSLog(@"Update recieved. %d files found so far", [query resultCount]);
 
 //[self processUpdate:query];
 
 }];
 
 [self.notifications addObject:observer];
 
 
 observer = [center addObserverForName:NSMetadataQueryGatheringProgressNotification object:query queue:nil
 usingBlock:^(NSNotification *note) {
 
 NSLog(@"Progress notification recieved. %d files found so far",
 [query resultCount]);
 
 //[self processUpdate:query];
 
 }];
 
 [self.notifications addObject:observer];
 
 [query startQuery];
 }*/

- (void)addNewFilesToList:(NSArray*)queryItems {
    
    NSUInteger count = [queryItems count];
    if (count == 0) return;
    
    // open the files in a background thread
    dispatch_queue_t queue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:count];
        
        for (NSMetadataItem* item in queryItems) {
            
            NSURL* url = [item valueForAttribute:NSMetadataItemURLKey];
            //NSURL* cloudURL = [url URLByDeletingLastPathComponent];
            
            NSFileCoordinator* coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
            
            // always wrap any read/write operations
            // in an appropriate coordinator
            [coordinator coordinateReadingItemAtURL:url options:NSFileCoordinatorReadingWithoutChanges error:nil byAccessor:^(NSURL *newURL) {
                
                NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:url];
                
                NSString* name =  [dict valueForKey: NSPersistentStoreUbiquitousContentNameKey];
                
                //                 [array addObject:[name substringFromIndex:
                //                                   [KeyPrefix length]]];
                
                [array addObject:name];
                
                //[self.urlsForFileNames setValue:cloudURL forKey:name];
                
            }]; // end of coordinator block
        }
        
        NSUInteger start = [self.listOfFiles count];
        
        self.listOfFiles = array; //[self.listOfFiles arrayByAddingObjectsFromArray:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray* indexPaths = [NSMutableArray arrayWithCapacity:count];
            
            // construct array of index paths.
            for (NSUInteger row = start; row < start + count; row++) {
                
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                
                [indexPaths addObject:indexPath];
            }
            
            // Now update those rows
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            
        });
    }); // end of dispatched block
    
}

- (void)buildCloudListFromQueryItems:(NSArray*)queryItems {
    
    NSUInteger count = [queryItems count];
    if (count == 0) return;
    
    // open the files in a background thread
    dispatch_queue_t queue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        //NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:count];
        
        for (NSMetadataItem* item in queryItems) {
            
            NSURL* url = [item valueForAttribute:NSMetadataItemURLKey];
            //NSURL* cloudURL = [url URLByDeletingLastPathComponent];
            
            NSFileCoordinator* coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
            
            // always wrap any read/write operations
            // in an appropriate coordinator
            [coordinator coordinateReadingItemAtURL:url options:NSFileCoordinatorReadingWithoutChanges error:nil byAccessor:^(NSURL *newURL) {
                
                NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:url];
                
                NSString* name =  [dict valueForKey: NSPersistentStoreUbiquitousContentNameKey];
                
                //                 [array addObject:[name substringFromIndex:
                //                                   [KeyPrefix length]]];
                
                [self.listOfFiles addObject:name];
                //[self.urlsForFileNames setValue:cloudURL forKey:name];
                NSLog(@"self.listOfFiles %@ - %lu",name, (unsigned long)self.listOfFiles.count);
                
            }]; // end of coordinator block
        }
        
        [[ NSNotificationCenter defaultCenter ] postNotificationName:@"reload_ tableview_notification" object:nil userInfo:nil];
        
    }); // end of dispatched block
    
}


-(void) reloadTableViewNote:(NSNotification*) notif {
    
    [ self listLocalFiles];
    
    //[self.tableView reloadData];
    
    [self.tableView setNeedsDisplay];
}

#pragma mark - createDocument

- (FlightManagedDocument*)createDocument:(NSString*)fileName {
    
    // This instantiates a FlightManagedDocument object
    // But does not save or open it (does not create
    // or read the underlying persistent store).
    
    NSDictionary *options;
    
    if (self.bDisplayingCloud) {
        
        options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES],  NSMigratePersistentStoresAutomaticallyOption,
                   [NSNumber numberWithBool:YES],  NSInferMappingModelAutomaticallyOption,
                   fileName,   NSPersistentStoreUbiquitousContentNameKey, self.containerURL,
                   NSPersistentStoreUbiquitousContentURLKey, nil];
    } else {
        
        options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES],  NSMigratePersistentStoresAutomaticallyOption,
                   [NSNumber numberWithBool:YES],  NSInferMappingModelAutomaticallyOption, nil];
        
    }
    
    NSURL* url = [self.urlsForFileNames valueForKey:fileName];
    
    // if we don't have a valid URL, create a local url
    if (url == nil) {
        
        url = [self.localURL URLByAppendingPathComponent:fileName]; // what if it is in the cloud?
        [self.urlsForFileNames setValue:url forKey:fileName];
        ////[[NSFileManager defaultManager] removeItemAtURL:documentURL error:nil];
    }
    
    // Now Create our document
    FlightManagedDocument* document = [[FlightManagedDocument alloc] initWithFileURL:url];
    
    document.persistentStoreOptions = options;
    
    //if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
    
    return document;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"OpenGraphSegue"]) {
        
        //FPh_GraphViewController
        FPh_GraphViewController * graphController = segue.destinationViewController;
        
        //FPh_GraphViewController * graphController = (FPh_GraphViewController *)destination.topViewController;
        
        graphController.flightGraphDocument = selectedFMdocument;
        
    }
    /*
     if ([segue.identifier isEqualToString:@"Open File Segue"]) {
     
    
     
     DocumentCell* cell = sender;
     NSString* fileName = cell.fileName.text;
     
     FlightManagedDocument* document = [self createDocument:fileName];
     
     [document openWithCompletionHandler:^(BOOL success) {
     
     if (success == NO) {
     [NSException
     raise:NSGenericException
     format:@"Could not open the file %@ at %@",
     fileName,
     document.fileURL];
     }
     
     destination.document = document;
     destination.fileName = fileName;
     
     if ([destination isViewLoaded]) {
     [destination fetchDocumentData];
     }
     }];
     
     }
     */
}

 /*
  -(void) openLocalFlightFileNote :(NSNotification*) notif {
  
  FlightManagedDocument * doc = notif.object;
  
  //NSLog(@" lastPathComponent %@",[doc.fileURL lastPathComponent]);
  //NSLog(@" doc.localizedName %@",doc.localizedName);
  //NSLog(@" doc.fileType %@",doc.fileType);
  //NSLog(@" doc.fileModificationDate %@",doc.fileModificationDate );
  
  
  
  
  }
*/
@end




