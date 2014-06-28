//
//  ImageDetailView.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "ImageDetailView.h"

@implementation ImageDetailView

- (void)updateImageViewWithPlaceHolder:(UIImage*)img andImageObject:(ImageObject*)obj
{
    [self.imageView setImageWithURL:[NSURL URLWithString:obj.largeImageUrlStr]
                   placeholderImage:img];
}

- (IBAction)close:(id)sender
{
    self.placeholder = nil;
    self.imgObj = nil;
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(imageDetailViewDidClose:)])
    {
        [self.delegate imageDetailViewDidClose:self];
    }
}

@end
