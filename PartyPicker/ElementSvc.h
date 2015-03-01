//
//  ElementSvc.h
//  PartyPicker
//
//  Created by Jason Weber on 2/7/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Element.h"

@protocol ElementSvc <NSObject>

- (Element *) createElement: (NSString *) elementName description: (NSString *) elementDesc;
- (NSArray *) retrieveAllElements;
- (Element *) updateElement: (Element *) element;
- (Element *) deleteElement: (Element *) element;
- (Element *) findElementByName: (NSString *) elementName;

@end

