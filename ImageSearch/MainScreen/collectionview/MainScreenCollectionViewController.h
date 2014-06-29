//
//  MainScreenCollectionViewController.h
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MainScreenCollectionViewControllerDelegate <NSObject>

- (void)controllerDidSelect:(id)sender thumbnail:(UIImage*)thumbnail imageObj:(ImageObject*)imageObj;
- (void)controllerHitTheBottom:(id)sender;

@end

@interface MainScreenCollectionViewController : NSObject
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) id<MainScreenCollectionViewControllerDelegate> delegate;

@property (strong, nonatomic) NSArray* allItems;
@property (weak, nonatomic) UICollectionView* collectionView;

- (void)reloadData;
- (void)cleanup;

@end
