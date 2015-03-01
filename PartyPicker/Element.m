//
//  Element.m
//  PartyPicker
//
//  Created by Jason Weber on 2/19/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "Element.h"
#import "Party.h"


@implementation Element

@dynamic desc;
@dynamic id;
@dynamic name;
@dynamic party;

- (NSString *) description {
    return [NSString stringWithFormat: @"%@: %@", self.name, self.desc];
}

@end
