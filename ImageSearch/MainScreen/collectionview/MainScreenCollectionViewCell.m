//
//  MainScreenCollectionViewCell.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "MainScreenCollectionViewCell.h"

@implementation MainScreenCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    [self setupWithImageObj:self.imgObj];
}

- (void)setupWithImageObj:(ImageObject*)obj
{
    self.imgObj = obj;
    [self.imgView setImageWithURL:[NSURL URLWithString:obj.thumbnailUrlStr]
                 placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)cleanup
{
}

- (void)prepareForReuse
{
    [self cleanup];
}

@end
