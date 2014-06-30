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

/*
 * Reloads the collection view
 */
- (void)reloadData
{
    [self.collectionView reloadData];
}

/*
 * Releases all the items and the array of results
 */
- (void)cleanup
{
    self.allItems = nil;
}

/*
 * Cleans up memory
 */
- (void)dealloc
{
    [self cleanup];
}


#pragma mark - CollectionViewDelegate methods

/*
 * Called when user selects an image from collection view - notifies the delegate
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve the selected cell
    MainScreenCollectionViewCell* cell = (MainScreenCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(controllerDidSelect:thumbnail:imageObj:)])
    {
        // Notify the delegate with image and imageObj
        [self.delegate controllerDidSelect:self
                                 thumbnail:cell.imgView.image
                                  imageObj:cell.imgObj];
    }
}

/*
 * Specifies the size of each cell
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

/*
 * Specifies the number of cells in sections
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.allItems count];
}

/*
 * Specifies the number of sections
 */
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

/*
 * Returns the cells to display in collection view - reuses old ones if it can - creates new cell if necessary
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainScreenCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = (MainScreenCollectionViewCell*)[[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    ImageObject* imgObj = (ImageObject*)self.allItems[indexPath.item];
    
    // setup the cell to show the image
    [cell setupWithImageObj:imgObj];
    return cell;
}


#pragma mark - uiscrollview delegate methods

/*
 * Called whenever user scrolls the collection view
 */
-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;

    // The current content position of scrollview
    float scrollOffset = scrollView.contentOffset.y;
    
    // Calculate if we hit the bottom of collection view - of so notify delegate
    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight &&
        [self.delegate respondsToSelector:@selector(controllerHitTheBottom:)])
    {
        [self.delegate controllerHitTheBottom:self];
    }
}

@end
