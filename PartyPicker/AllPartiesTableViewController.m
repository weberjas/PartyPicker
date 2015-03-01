//
//  AllPartiesTableViewController.m
//  PartyPicker
//
//  Created by Jason Weber on 2/20/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//


#import "AllPartiesTableViewController.h"
#import "EditPartyViewController.h"
#import "PartySvcCoreData.h"
#import "Party.h"

@interface AllPartiesTableViewController ()

@end

@implementation AllPartiesTableViewController

static NSString *CellIdentifier = @"Cell Identifier";
PartySvcCoreData *partySvc = nil;

Party *selectedParty = nil;


- (void)viewDidLoad {
    [super viewDidLoad];
    // create a new instance of PartySvc
    partySvc = [[PartySvcCoreData alloc] init];
    
    self.parties = [partySvc retrieveAllParties];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*
    //https://userflex.wordpress.com/2012/01/26/info-button-uinavigationitem/
    UIBarButtonItem *btnAddParty = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addParty:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = btnAddParty;
    btnAddParty.enabled=TRUE;
    btnAddParty.style=UIBarButtonSystemItemAdd;
     */
    
    // CRAZY BUG in navigation bar - BEWARE!!
    // http://stackoverflow.com/questions/24983629/xcode-storyboard-issue-button-bar-button-only-appears-at-the-bottom-of-a-table
    // nav bars must be added manually in the storyboard to interact with them!
}

// refresh the the parties from the store
- (void) refresh {
    self.parties = [partySvc retrieveAllParties];
    [self.tableView reloadData];
}

- (IBAction) addParty:(id)sender {
    NSLog(@"Add Button Pressed");
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
    return [self.parties count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Party *party = [self.parties objectAtIndex:[indexPath row]];
    [cell.textLabel setText:party.name];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected Row %ld", (long)indexPath.row);
    // set the selected party
    selectedParty = [self.parties objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"Show Party" sender:self];
}
/*
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setEditing:NO animated:YES];

}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Party *deleteParty = [self.parties objectAtIndex:indexPath.row];
        [partySvc deleteParty:deleteParty];
        [self refresh];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    EditPartyViewController *destinationViewController = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"Show Party"]) {
        destinationViewController.party = selectedParty;
    } else {
        destinationViewController.party = nil;
    }
    
}


@end
