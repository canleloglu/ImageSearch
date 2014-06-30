//
//  ActivityView.h
//  ImageSearch
//
//  Created by Can Leloglu on 6/29/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

- (void)startAnimating;
- (void)stopAnimating;

@end
