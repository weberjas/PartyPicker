//
//  EditPartyTableViewController.m
//  PartyPicker
//
//  Created by Jason Weber on 2/20/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "EditPartyViewController.h"
#import "AllPartiesTableViewController.h"
#import "ElementSvcCoreData.h"
#import "PartySvcCoreData.h"

@interface EditPartyViewController ()

@end

@implementation EditPartyViewController

@synthesize party;

static NSString *CellIdentifier = @"Cell Identifier";
NSMutableSet *selectedElements = nil;
NSArray *allElements = nil;
ElementSvcCoreData *elementSvcfoobar = nil;
PartySvcCoreData *editPartySvc = nil;


- (void)viewDidLoad {
    [super viewDidLoad];


    elementSvcfoobar = [[ElementSvcCoreData alloc] init];
    editPartySvc = [[PartySvcCoreData alloc] init];
    
    allElements = [elementSvcfoobar retrieveAllElements];
    selectedElements = [[NSMutableSet alloc] init];
    
    // set the text fields if the party is not nil
    
    if (self.party.name != nil) {
        _nameField.text = self.party.name;
        _descField.text = self.party.desc;
    }
    
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
    return [allElements count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //NSString *element = [self.elements objectAtIndex:[indexPath row]];
    //[cell.textLabel setText:element];
    
    Element *element = [allElements objectAtIndex:[indexPath row]];
    [cell.textLabel setText:element.name];
    
    return cell;
}

// select the rows assigned to the current party unless it's nil
// http://stackoverflow.com/questions/19295297/uitableviewcell-set-selected-initially
// There is a problem with preselecting rows like this. It means that further selections are not allowed.
// You have to tell the table to select the cell and not just set the cell as selected.
// http://stackoverflow.com/questions/3968037/how-to-deselect-a-selected-uitableview-cell

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // if the party is not nil
    if (party) {
        // loop through all elements and see if the current cell name is in the list of party elements
        for (Element *element in party.elements) {
            // if there is a match, select the cell
            if ([cell.textLabel.text isEqual:element.name ]) {
                //[cell setSelected:YES animated:NO];
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                // fix for bug where separator line is erased, still not working
                // http://stackoverflow.com/questions/19212476/uitableview-separator-line-disappears-when-selecting-cells-in-ios7
                cell.textLabel.backgroundColor = [UIColor clearColor];
            }
        }
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

}

// need to manage the list of selected elements
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected Row %ld", (long)indexPath.row);
    
    // add the element to the selected elements array
    if (party) {
        [party addElementsObject:[allElements objectAtIndex:indexPath.row]];
    } else {
        [selectedElements addObject:[allElements objectAtIndex:indexPath.row]];
    }
    
    [[tableView cellForRowAtIndexPath:indexPath] setHighlighted:NO];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"Deselected Row %ld", (long)indexPath.row);
    
    if (party) {
        [party removeElementsObject:[allElements objectAtIndex:indexPath.row]];
    } else {
        [selectedElements removeObject:[allElements objectAtIndex:indexPath.row]];
    }
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}



- (IBAction) cancel: (id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// method to handle save button clicks

- (IBAction) save:(id)sender {
    
    // if the party is new, create
    if (self.party.name == nil) {
        self.party = [editPartySvc createParty:_nameField.text description:_descField.text elements:selectedElements];
    
    } else { // otherwise, save the current party
    
        self.party.name = _nameField.text;
        self.party.desc = _descField.text;
        
        [editPartySvc updateParty:self.party];
    }
    
    NSInteger viewCount = [self.navigationController.viewControllers count];
    
    AllPartiesTableViewController *previousController = [self.navigationController.viewControllers objectAtIndex:viewCount -2];
    [previousController refresh];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [segue destinationViewController];
}
*/

@end
