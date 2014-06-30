//
//  MainScreenTableViewController.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/29/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "MainScreenTableViewController.h"

@implementation MainScreenTableViewController

- (NSMutableArray*)getPastArray
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:pastKey];
}

- (void)pushSearchToPast:(NSString*)searchTerm
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* pastArray = [[self getPastArray] mutableCopy];
    if (!pastArray)
    {
        pastArray = [[NSMutableArray alloc] init];
    }
    
    NSInteger objIndex = [pastArray indexOfObject:searchTerm];
    if (objIndex != NSNotFound)
    {
        [pastArray removeObjectAtIndex:objIndex];
    }
    [pastArray addObject:searchTerm];
    
    [defaults setObject:pastArray forKey:pastKey];
    [defaults synchronize];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark - tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(tableControllerDidSelect:searchTerm:)])
    {
        [self.delegate tableControllerDidSelect:self searchTerm:cell.textLabel.text];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getPastArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* pastArray = [self getPastArray];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    cell.textLabel.text = (NSString*)pastArray[[pastArray count] - indexPath.row - 1];
    return cell;
}

@end
