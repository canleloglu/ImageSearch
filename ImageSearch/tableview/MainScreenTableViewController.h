//
//  MainScreenTableViewController.h
//  ImageSearch
//
//  Created by Can Leloglu on 6/29/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MainScreenTableViewControllerDelegate <NSObject>

- (void)tableControllerDidSelect:(id)sender searchTerm:(NSString*)searchTerm;

@end

@interface MainScreenTableViewController : NSObject
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<MainScreenTableViewControllerDelegate> delegate;

@property (weak, nonatomic) UITableView* tableView;

- (void)pushSearchToPast:(NSString*)searchTerm;
- (void)reloadData;

@end
