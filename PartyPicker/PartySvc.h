//
//  PartySvc.h
//  PartyPicker
//
//  Created by Jason Weber on 2/19/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Party.h"

@protocol PartySvc <NSObject>

- (Party *) createParty: (NSString *) partyName description: (NSString *) partyDesc elements: (NSSet *) elements;
- (NSArray *) retrieveAllParties;
- (NSArray *) retrievePartiesWithElements: (NSMutableArray *) elements;
- (Party *) updateParty: (Party *) party;
- (Party *) deleteParty: (Party *) party;
- (Party *) findPartyByName: (NSString *) partyName;

@end

