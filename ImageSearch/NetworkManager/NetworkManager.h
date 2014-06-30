//
//  NetworkManager.h
//  ImageSearch
//
//  Created by Can Leloglu on 6/26/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkManagerDelegate <NSObject>

- (void)requestFinished:(NSURLRequest*)req withDict:(NSDictionary*)dict;
- (void)requestFailed:(NSURLRequest*)req withReason:(NSString*)reason;

@end

@interface NetworkManager : NSObject
<NSURLConnectionDelegate>

@property (weak, nonatomic) id<NetworkManagerDelegate> delegate;
@property (atomic) BOOL hasActiveRequest;

- (void)makeReqWithString:(NSString*)str andIndex:(NSInteger)index;

@end
