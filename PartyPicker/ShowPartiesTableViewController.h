//
//  ShowPartiesTableViewController.h
//  PartyPicker
//
//  Created by Jason Weber on 2/1/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPartiesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *selectedElements;
@property NSArray *parties;

@end
