//
//  ElementEditorViewController.m
//  PartyPicker
//
//  Created by Jason Weber on 2/8/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "ElementEditorViewController.h"
#import "Element.h"
#import "ElementSvcCoreData.h"

@interface ElementEditorViewController ()

@end

@implementation ElementEditorViewController

ElementSvcCoreData *elementSvc = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    elementSvc = [[ElementSvcCoreData alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// return the number of rows in the section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[elementSvc retrieveAllElements] count];
}

// return a cell for the given element at the indexpath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Element *element = [[elementSvc retrieveAllElements] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [element description]; return cell;
}

// respond to a row of the table being selected
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Row clicked");
    Element *element = [[elementSvc retrieveAllElements] objectAtIndex:indexPath.row];
    
    _nameField.text = element.name;
    _descriptionField.text = element.desc;

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveElement:(id)sender {
    
    // hide the keyboard
    [self.view endEditing:YES];
    
    // if the element is not already in the archive, create a new one
    Element *element = [elementSvc findElementByName:_nameField.text];
    if (!element) {
        NSLog(@"Create a new element");
        [elementSvc createElement:_nameField.text description:_descriptionField.text];

    } else { // otherwise, update the existing item
        NSLog(@"Update an existing element");
        [element setValue:_nameField.text forKey:@"name"];
        [element setValue:_descriptionField.text forKey:@"desc"];
        [elementSvc updateElement:element];
    }
    [self.tableView reloadData];
    NSLog(@"Save Element");
}

- (IBAction)deleteElement:(id)sender {
    NSLog(@"Delete Element");
    long elementIdx = [[self.tableView indexPathForSelectedRow] row];
    
    [elementSvc deleteElement:[[elementSvc retrieveAllElements] objectAtIndex:elementIdx]];
    
    _nameField.text = @"";
    _descriptionField.text = @"";
    
    [self.tableView reloadData];
 

}
@end
