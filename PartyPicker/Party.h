//
//  Party.h
//  PartyPicker
//
//  Created by Jason Weber on 2/19/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Element;

@interface Party : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSSet *elements;
@end

@interface Party (CoreDataGeneratedAccessors)

- (void)addElementsObject:(Element *)value;
- (void)removeElementsObject:(Element *)value;
- (void)addElements:(NSSet *)values;
- (void)removeElements:(NSSet *)values;

@end
