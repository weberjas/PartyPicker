//
//  ElementTableViewController.h
//  PartyPicker
//
//  Created by Jason Weber on 1/31/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElementTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property NSArray *elements;

@end
