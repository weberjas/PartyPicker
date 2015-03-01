//
//  AllPartiesTableViewController.h
//  PartyPicker
//
//  Created by Jason Weber on 2/20/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllPartiesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *parties;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void) refresh;

@end
