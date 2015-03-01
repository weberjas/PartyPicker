//
//  ElementEditorViewController.h
//  PartyPicker
//
//  Created by Jason Weber on 2/8/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElementEditorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)saveElement:(id)sender;
- (IBAction)deleteElement:(id)sender;
@end
