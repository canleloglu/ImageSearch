//
//  MainScreenCollectionViewController.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "MainScreenCollectionViewController.h"
#import "MainScreenCollectionViewCell.h"

@interface MainScreenCollectionViewController ()

@property (strong, nonatomic) MainScreenCollectionViewCell* reusableCell;

@end

@implementation MainScreenCollectionViewController

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)cleanup
{
    self.allItems = nil;
}

- (void)dealloc
{
    [self cleanup];
}

#pragma mark - CollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainScreenCollectionViewCell* cell = (MainScreenCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(controllerDidSelect:thumbnail:imageObj:)])
    {
        [self.delegate controllerDidSelect:self
                                 thumbnail:cell.imgView.image
                                  imageObj:cell.imgObj];
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
        cell = (MainScreenCollectionViewCell*)[[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    ImageObject* imgObj = (ImageObject*)self.allItems[indexPath.item];
    [cell setupWithImageObj:imgObj];
    return cell;
}

#pragma mark - uiscrollview delegate methods

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight &&
        [self.delegate respondsToSelector:@selector(controllerHitTheBottom:)])
    {
        [self.delegate controllerHitTheBottom:self];
    }
}

@end
