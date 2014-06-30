//
//  ImageObject.h
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageObject : NSObject

// Thumbnail url string for collection view
@property (strong, nonatomic) NSString* thumbnailUrlStr;
// Large image url string for image detail view
@property (strong, nonatomic) NSString* largeImageUrlStr;

@end
