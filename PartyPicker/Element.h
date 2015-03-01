//
//  Element.h
//  PartyPicker
//
//  Created by Jason Weber on 2/19/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Party;

@interface Element : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *party;
@end

@interface Element (CoreDataGeneratedAccessors)

- (void)addPartyObject:(Party *)value;
- (void)removePartyObject:(Party *)value;
- (void)addParty:(NSSet *)values;
- (void)removeParty:(NSSet *)values;

@end
