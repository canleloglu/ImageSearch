//
//  ImageDetailView.h
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageDetailViewDelegate <NSObject>

- (void)imageDetailViewDidClose:(id)sender;

@end

@interface ImageDetailView : UIView

@property (strong, nonatomic) UIImage* image;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) id<ImageDetailViewDelegate> delegate;

- (IBAction)close:(id)sender;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image;

@end
