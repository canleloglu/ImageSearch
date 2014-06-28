//
//  MainScreenCollectionViewCell.h
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainScreenCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView* imgView;

- (void)setupWithImageUrl:(NSString*)urlStr;

@end
