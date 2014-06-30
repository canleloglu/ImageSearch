//
//  ActivityView.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/29/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "ActivityView.h"

@implementation ActivityView

/*
 * Called when the view is loaded from the xib file - sets background color
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
}

/*
 * Start the animation of activity indicator and reveals itself
 */
- (void)startAnimating
{
    [self.activityIndicator startAnimating];
    self.hidden = NO;
}

/*
 * Stops the animation of activity indicator and hides itself
 */
- (void)stopAnimating
{
    [self.activityIndicator stopAnimating];
    self.hidden = YES;
}

@end
