//
//  ElementSvcCoreData.m
//  PartyPicker
//
//  Created by Jason Weber on 2/18/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "ElementSvcCoreData.h"
#import <CoreData/CoreData.h>
#import "CoreDataMgr.h"


@implementation ElementSvcCoreData


// create a managed Element
- (Element *) createManagedElement {
    Element *element = [NSEntityDescription insertNewObjectForEntityForName:@"Element" inManagedObjectContext:[CoreDataMgr getInstance].moc];
    return element;
}

- (Element *) createElement: (NSString *) elementName description: (NSString *) elementDesc {
    
    Element *managedElement = [self createManagedElement];
    managedElement.name = elementName;
    managedElement.desc = elementDesc;
    
    NSError *error = nil;
    
    if (![[CoreDataMgr getInstance].moc save:&error]) {
        NSLog(@"Error creating Element! Error: %@", [error localizedDescription]);
    }
    return managedElement;
}


- (NSArray *) retrieveAllElements {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Element" inManagedObjectContext:[CoreDataMgr getInstance].moc];
    
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[CoreDataMgr getInstance].moc executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}


- (Element *) updateElement: (Element *) element {
    
    NSError *error = nil;
    if (![[CoreDataMgr getInstance].moc save:&error]) {
        NSLog(@"Error Saving Element! Error: %@", [error localizedDescription]);
    }
    return element;
}


- (Element *) deleteElement: (Element *) element {
    
    [[CoreDataMgr getInstance].moc deleteObject:element];
    
    return element;
}


- (Element *) findElementByName: (NSString *) elementName {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Element" inManagedObjectContext:[CoreDataMgr getInstance].moc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", elementName];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[CoreDataMgr getInstance].moc executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] > 0) {
        return [fetchedObjects objectAtIndex:0];
    } else {
        return nil;
    }
    
    
}


@end
