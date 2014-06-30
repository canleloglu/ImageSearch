//
//  MainScreenTableViewController.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/29/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "MainScreenTableViewController.h"

@implementation MainScreenTableViewController

/*
 * Gets the array of past searches
 */
- (NSMutableArray*)getPastArray
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:pastKey] mutableCopy];
}

/*
 * Pushes the search term to history - if search term already exists then we moves it to the top
 */
- (void)pushSearchToPast:(NSString*)searchTerm
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* pastArray = [self getPastArray];
    if (!pastArray)
    {
        // Create the array if there is no history yet
        pastArray = [[NSMutableArray alloc] init];
    }
    
    // Search for string in the history array
    NSInteger objIndex = [pastArray indexOfObject:searchTerm];
    if (objIndex != NSNotFound)
    {
        // If the term is already in the array remove it
        [pastArray removeObjectAtIndex:objIndex];
    }
    // Add the term to the top
    [pastArray addObject:searchTerm];
    
    // Sets the history array to userdefaults
    [defaults setObject:pastArray forKey:pastKey];
    [defaults synchronize];
}

/*
 * Reloads the table view
 */
- (void)reloadData
{
    [self.tableView reloadData];
}

/*
 * Cleans up memory
 */
- (void)dealloc
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    while (cell != nil)
    {
        cell = nil;
        cell = [self.tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    }
}

#pragma mark - tableview delegate methods

/*
 * Called when user selects an entry from history table - notifies delegate
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(tableControllerDidSelect:searchTerm:)])
    {
        [self.delegate tableControllerDidSelect:self searchTerm:cell.textLabel.text];
    }
}

/*
 * Specifies how many rows are going to be in the table view
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getPastArray] count];
}

/*
 * Returns the cells for history table view - creates them if necessary
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* pastArray = [self getPastArray];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    // We show the history from newest to oldest
    cell.textLabel.text = (NSString*)pastArray[[pastArray count] - indexPath.row - 1];
    return cell;
}

@end
