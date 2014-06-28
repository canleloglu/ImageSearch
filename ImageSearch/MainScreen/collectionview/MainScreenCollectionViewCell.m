//
//  MainScreenCollectionViewCell.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "MainScreenCollectionViewCell.h"

@implementation MainScreenCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)setupWithImageUrl:(NSString*)urlStr
{
    [self.imgView removeFromSuperview];
    [self.imgView setImageWithURL:[NSURL URLWithString:urlStr]
                 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self addSubview:self.imgView];
}

- (void)cleanup
{
    self.imgView = nil;
}

@end
