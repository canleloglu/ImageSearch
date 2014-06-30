//
//  ImageDetailView.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "ImageDetailView.h"

@implementation ImageDetailView

/*
 * Called when the view is loaded from the xib file - adds the activity view to ui
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.activityView = (ActivityView*)[[[NSBundle mainBundle] loadNibNamed:@"ActivityView" owner:self options:nil] objectAtIndex:0];
    self.activityView.frame = self.activityContainer.bounds;
    [self.activityContainer addSubview:self.activityView];
}

/*
 * Sets the image to be shown in detail - thumbnail is placeholder and it starts the request for large image
 */
- (void)updateImageViewWithPlaceHolder:(UIImage*)img andImageObject:(ImageObject*)obj
{
    [self.activityView startAnimating];
    __weak ImageDetailView* weakself = self;
    [self.imageView setImageWithURL:[NSURL URLWithString:obj.largeImageUrlStr]
                   placeholderImage:img
                            success:^(UIImage *image, BOOL cached)
    {
        [weakself.activityView stopAnimating];
    }
    failure:^(NSError *error)
    {
        [weakself.activityView stopAnimating];
    }];
}

/*
 * Called when user taps on close button - cleans up memory and removes itself from the superview - notifies delegate
 */
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
