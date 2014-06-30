//
//  ImageDetailView.h
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ActivityView.h"

@protocol ImageDetailViewDelegate <NSObject>

- (void)imageDetailViewDidClose:(id)sender;

@end

@interface ImageDetailView : UIView

@property (strong, nonatomic) UIImage* placeholder;
@property (strong, nonatomic) ImageObject* imgObj;
@property (strong, nonatomic) ActivityView* activityView;

@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UIView* activityContainer;

@property (weak, nonatomic) id<ImageDetailViewDelegate> delegate;


- (void)updateImageViewWithPlaceHolder:(UIImage*)img andImageObject:(ImageObject*)obj;

- (IBAction)close:(id)sender;

@end
