//
//  NetworkManager.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/26/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.hasActiveRequest = NO;
    }
    return self;
}

- (void)makeReqWithString:(NSString*)str andIndex:(NSInteger)index
{
    self.hasActiveRequest = YES;
    NSString* searchStr = [NSString stringWithFormat:REQUEST_URL_STRING, str];
    if (index > 1)
    {
        searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"&start=%d", index]];
    }
    NSURL *url = [NSURL URLWithString:searchStr];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    __weak NSURLRequest* weakReq = req;
    __weak NetworkManager* weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError && [weakSelf.delegate respondsToSelector:@selector(requestFailed:)])
        {
            [weakSelf.delegate requestFailed:weakReq];
        }
        else if ([weakSelf.delegate respondsToSelector:@selector(requestFinished:withDict:)])
        {
            NSError *jsonParsingError = nil;
            NSDictionary* object = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            if (jsonParsingError) {
                NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
            } else {
                NSLog(@"OBJECT: %@", object);
                [weakSelf.delegate requestFinished:weakReq withDict:object];
            }
        }
        weakSelf.hasActiveRequest = NO;
    }];
}

- (void)loadFromJson
{
    NSString* filePath = @"img";
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:filePath ofType:@"png"];
    NSData *JSONData = [NSData dataWithContentsOfFile:fileRoot options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", jsonObject);
}

@end
