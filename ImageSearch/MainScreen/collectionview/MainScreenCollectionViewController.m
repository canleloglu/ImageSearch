//
//  MainScreenCollectionViewController.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "MainScreenCollectionViewController.h"
#import "MainScreenCollectionViewCell.h"

@implementation MainScreenCollectionViewController

- (void)reloadData
{
    [self.collectionView reloadData];
}

#pragma mark - CollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainScreenCollectionViewCell* cell = (MainScreenCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(controllerDidSelect:image:)])
    {
        [self.delegate controllerDidSelect:self image:cell.imgView.image];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.allItems count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainScreenCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[MainScreenCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    }
    [cell setupWithImageUrl:self.allItems[indexPath.item]];
    return cell;
}

@end
