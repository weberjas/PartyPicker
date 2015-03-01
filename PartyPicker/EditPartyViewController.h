//
//  EditPartyViewController.h
//  PartyPicker
//
//  Created by Jason Weber on 2/20/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Party.h"

@interface EditPartyViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Party *party;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBtn;

@end
