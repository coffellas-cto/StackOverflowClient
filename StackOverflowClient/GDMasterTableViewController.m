//
//  GDMasterTableViewController.m
//  StackOverflowClient
//
//  Created by Alex G on 11.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDMasterTableViewController.h"
#import "GDSplitViewController.h"

@interface GDMasterTableViewController () <UISplitViewControllerDelegate> {
}

@end

@implementation GDMasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MENU_CELL" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *cellName = nil;
    switch (indexPath.row) {
        case 0:
            cellName = @"Questions";
            break;
        case 1:
            cellName = @"Users";
            break;
        case 2:
            cellName = @"Profile";
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = cellName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GDSplitViewController *splitVC = (GDSplitViewController *)self.splitViewController;
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            [splitVC showUsersVC];
            break;
        case 2:
            break;
            
        default:
            break;
    }
}
@end
