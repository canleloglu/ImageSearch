//
//  ImageDetailView.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "ImageDetailView.h"

@implementation ImageDetailView

- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        _image = nil;
        _image = image;
        if (self.imageView)
        {
            self.imageView.image = _image;
        }
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageView.image = self.image;
}

- (IBAction)close:(id)sender
{
    self.image = nil;
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(imageDetailViewDidClose:)])
    {
        [self.delegate imageDetailViewDidClose:self];
    }
}

@end
