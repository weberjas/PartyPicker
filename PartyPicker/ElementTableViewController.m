//
//  ElementTableViewController.m
//  PartyPicker
//
//  Created by Jason Weber on 1/31/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "ElementTableViewController.h"
#import "ShowPartiesTableViewController.h"
#import "ElementSvcCoreData.h"
#import "Element.h"

@interface ElementTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property IBOutlet UITableView *tableView;

@end

@implementation ElementTableViewController

static NSString *CellIdentifier = @"Cell Identifier";
ElementSvcCoreData *elementSvc;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load the elements array
    elementSvc = [[ElementSvcCoreData alloc] init];
    
    self.elements = [elementSvc retrieveAllElements];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.elements count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Element *element = [self.elements objectAtIndex:[indexPath row]];
    [cell.textLabel setText:element.name];
    [cell.detailTextLabel setText:element.desc];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set the selection style to be None. Add a accessory in the didSelect methods
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected Row %ld", (long)indexPath.row);
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // get a reference to the ShowPartiesTableViewController so we can set the selectedElements array
    
    ShowPartiesTableViewController *showPartiesTableViewController = (ShowPartiesTableViewController *)segue.destinationViewController;
    
    // see if the selectedElements array has been initialized, if not then initialize, if so then empty
    if (showPartiesTableViewController.selectedElements == nil) {
        showPartiesTableViewController.selectedElements = [[NSMutableArray alloc] init];
    } else {
        [showPartiesTableViewController.selectedElements removeAllObjects];
    }
    
    // get an array of IndexPaths for all selections in the table view
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    
    // for every selection, find the value and put it in the selectedElements array of the destination table view controller
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        [showPartiesTableViewController.selectedElements addObject:[self.elements objectAtIndex:[indexPath row]]];
        
        NSLog(@"Added %@ to selectedElements", [self.elements objectAtIndex:[indexPath row]]);
    }
    
    NSLog(@"selectedElements has %lu items", [showPartiesTableViewController.selectedElements count]);
    
}



@end
