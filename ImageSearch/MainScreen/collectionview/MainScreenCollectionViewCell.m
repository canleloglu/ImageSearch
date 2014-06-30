//
//  MainScreenCollectionViewCell.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "MainScreenCollectionViewCell.h"

@implementation MainScreenCollectionViewCell

/*
 * Called when the view loaded from the xib file - sets up the initial look
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    [self setupWithImageObj:self.imgObj];
}

/*
 * Sets the new imgObject and shows the image in imageview - thumbnail is a placeholder until big image is downloaded
 */
- (void)setupWithImageObj:(ImageObject*)obj
{
    self.imgObj = obj;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:obj.thumbnailUrlStr]
                    placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    //[imageView setImageWithURL:[NSURL URLWithString:@"https://graph.facebook.com/olivier.poitrey/picture"]
//placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]
//options:SDWebImageRefreshCached];
}

/*
 * Cleans up the strong referenced objects
 */
- (void)cleanup
{
    self.imgObj = nil;
}

/*
 * Cleans up before reuseing the cell to avoid problems and save memory
 */
- (void)prepareForReuse
{
    [self cleanup];
}

@end
