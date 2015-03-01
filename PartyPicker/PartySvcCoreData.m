//
//  PartySvcCoreData.m
//  PartyPicker
//
//  Created by Jason Weber on 2/19/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "PartySvcCoreData.h"
#import "CoreDataMgr.h"
#import "Element.h"

@implementation PartySvcCoreData



// create a managed Party
- (Party *) createManagedParty {
    Party *party = [NSEntityDescription insertNewObjectForEntityForName:@"Party" inManagedObjectContext:[CoreDataMgr getInstance].moc];
    return party;
}


- (Party *) createParty: (NSString *) partyName description: (NSString *) partyDesc elements: (NSSet *) elements {
    Party *managedParty = [self createManagedParty];
    managedParty.name = partyName;
    managedParty.desc = partyDesc;
    
    [managedParty addElements:elements];
    
    NSError *error = nil;
    
    if (![[CoreDataMgr getInstance].moc save:&error]) {
        NSLog(@"Error creating Party! Error: %@", [error localizedDescription]);
    }
    NSLog(@"Created Party: %@", managedParty.name);
    return managedParty;
}

- (NSArray *) retrieveAllParties {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:[CoreDataMgr getInstance].moc];
    
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[CoreDataMgr getInstance].moc executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (NSArray *) retrievePartiesWithElements: (NSSet *) elements {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:[CoreDataMgr getInstance].moc];
    
    [fetchRequest setEntity:entity];

    NSMutableArray *inArray = [[NSMutableArray alloc] init];
    for (Element *element in elements) {
        [inArray addObject:element.name];
    }
    
    /* This works but it returns everything with any matches */
     // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdBindings.html
     // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-215851
     //NSPredicate *inPredicate = [NSPredicate predicateWithFormat: @"ALL elements.name IN %@", inSet];
     //[fetchRequest setPredicate:inPredicate];
    
    /* This works but it returns everything with any matches*/
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdBindings.html
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-215851
    
    // NSPredicate *predicate = [NSPredicate predicateWithFormat: @"ANY elements.name IN %@", inSet];
    //[fetchRequest setPredicate:predicate];
    
    
    
    /* This works but it returns everything with any matches*/
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdBindings.html
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-215851
    // RETURNS NOTHING
    //NSPredicate *predicate = [NSPredicate predicateWithFormat: @"ALL elements.name == %@", inSet];
    //[fetchRequest setPredicate:predicate];
    
    
    
    
    
    // try creating a predicate which only returns parties containing all selected elements
    // create a set of element names for the predicate
    // http://stackoverflow.com/questions/13647089/nscompoundpredicate
    /* ERROR to-many key not allowed here */
    /*
     NSMutableArray *predicateArray = [[NSMutableArray alloc] init];
    for (Element *element in elements) {
        [predicateArray addObject: [NSPredicate predicateWithFormat:@"elements.name == %@", element.name] ];
    }
    NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray];
    
    [fetchRequest setPredicate:predicate];
    */
    
    // try something different
    // http://www.coderexception.com/0363BzN63XUWxPyy/coredata-nspredicate-with-manytomany-relationship
    /* too difficult right now
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Party" inManagedObjectContext:[CoreDataMgr getInstance].moc]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"(SUBQUERY(self.elements, $element, ALL $element.name in %@).count > 0)", inSet]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[CoreDataMgr getInstance].moc executeFetchRequest:request error:&error];
    NSAssert2(error == nil, @"Error fetchings tags: %@\n%@", [error localizedDescription], [error userInfo]);
    */
    
    // the runs without error but doesn't return any results
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(elements, $r, $r.name = %@).@count > 0", inArray];
    //[fetchRequest setPredicate:predicate];
    
    // try a safe bet
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY %K = %@", @"elements.name", @"Sports"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(elements, $r, $r.name IN %@).@count = %d", inArray, inArray.count];
    [fetchRequest setPredicate:predicate];
    
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[CoreDataMgr getInstance].moc executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}



- (Party *) updateParty: (Party *) party {
    
    NSError *error = nil;
    if (![[CoreDataMgr getInstance].moc save:&error]) {
        NSLog(@"Error Saving Party! Error: %@", [error localizedDescription]);
    }
    NSLog(@"Updated Party: %@", party.name);
    return party;
}

- (Party *) deleteParty: (Party *) party {
    
    NSError *error = nil;
    
    [[CoreDataMgr getInstance].moc deleteObject:party];

    // need to save context after deleting objects
    // http://stackoverflow.com/questions/13990294/core-data-deleteobject-not-working
    if (![[CoreDataMgr getInstance].moc save:&error]) {
        NSLog(@"Couldn't save after deletion: %@", error);
    }
    
    NSLog(@"Deleted Party: %@", party.name);
    return party;
}


- (Party *) findPartyByName: (NSString *) partyName {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Party" inManagedObjectContext:[CoreDataMgr getInstance].moc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", partyName];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    
    NSArray *fetchedObjects = [[CoreDataMgr getInstance].moc executeFetchRequest:fetchRequest error:&error];
    
    return [fetchedObjects objectAtIndex:0];
}

@end
