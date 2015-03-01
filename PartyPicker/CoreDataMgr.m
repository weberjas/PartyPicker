//
//  CoreDataMgr.m
//  PartyPicker
//
//  Created by Jason Weber on 2/19/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//
// Singleton implementation from: http://www.galloway.me.uk/tutorials/singleton-classes/

#import "CoreDataMgr.h"

@implementation CoreDataMgr

@synthesize model = _model;
@synthesize psc = _psc;
@synthesize moc = _moc;


+ (CoreDataMgr *) getInstance {
    static CoreDataMgr *coreDataMgr = nil;
    static dispatch_once_t once_token; // Grand Central
    dispatch_once(&once_token, ^{
        coreDataMgr = [[self alloc] init];
    });
    
    return coreDataMgr;
}

- (id) init {
    self = [super init];
    
    NSError *error = nil;

    if (self) {
        // load the backing store from the application resources if this is a new install
        NSFileManager *fileMgr = [NSFileManager defaultManager];

        // initialize the persistent store coordinator
        NSURL *docsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        
        //check to see if data store exists
        NSString *writeableStore = [documentsDir stringByAppendingPathComponent:@"pickerCoreData.sqlite"];
        
        if (![fileMgr fileExistsAtPath:writeableStore]) {
            NSLog(@"Data store not found at writeable path! : %@", writeableStore);
            // copy store from resource directory
            NSString *packagedStore = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pickerCoreData.sqlite"];
            NSLog(@"Trying to access packaged version at: %@", packagedStore);
            
            BOOL success = [fileMgr copyItemAtPath:packagedStore toPath:writeableStore error:&error];
            if (success) {
                NSLog(@"Packaged store copied successfully!");
            } else {
                NSLog(@"Copy Failed! : %@", error);
            }
        }
        // load the schema model
        NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"PartyPicker" withExtension:@"momd"];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
        NSURL *storeUrl = [docsDir URLByAppendingPathComponent:@"pickerCoreData.sqlite"];
        
        
        _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        if ([_psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
            _moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_moc setPersistentStoreCoordinator:_psc];
            NSLog(@"Created store: %@", storeUrl);
        } else {
            NSLog(@"CoreData initialization failed! %@", error);
        }
    }
    return self;
}

@end
