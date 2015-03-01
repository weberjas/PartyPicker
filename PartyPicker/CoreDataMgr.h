//
//  CoreDataMgr.h
//  PartyPicker
//
//  Created by Jason Weber on 2/19/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataMgr : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectModel *model;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *psc;
@property (readonly, strong, nonatomic) NSManagedObjectContext *moc;

+ (CoreDataMgr *) getInstance;

@end
