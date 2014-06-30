//
//  NetworkManager.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/26/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

/*
 * Dedicated initializer - does not have an active request at the beginning
 */
- (id)init
{
    self = [super init];
    if (self)
    {
        self.hasActiveRequest = NO;
    }
    return self;
}

/*
 * Takes search terms and page index as parameters and starts the network request for search
 */
- (void)makeReqWithString:(NSString*)str andIndex:(NSInteger)index
{
    // Once we are here it means we will make a request
    self.hasActiveRequest = YES;
    
    // Forms the search string by using our google api key and search term
    NSString* searchStr = [NSString stringWithFormat:REQUEST_URL_STRING, str];
    if (index > 1)
    {
        // appends an index number to the url if we are trying to get more results on the same search term
        searchStr = [searchStr stringByAppendingString:[NSString stringWithFormat:@"&start=%d", index]];
    }
    NSURL *url = [NSURL URLWithString:searchStr];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    
    __weak NSURLRequest* weakReq = req; // Creates a block safe request object
    __weak NetworkManager* weakSelf = self; // Creates a block safe class instance
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        // The block is done - ready to handle another request
        weakSelf.hasActiveRequest = NO;
        
        // If we have an error we call requestFailed callback
        if (connectionError && [weakSelf.delegate respondsToSelector:@selector(requestFailed:withReason:)])
        {
            [weakSelf.delegate requestFailed:weakReq withReason:[connectionError localizedDescription]];
        }
        else if ([weakSelf.delegate respondsToSelector:@selector(requestFinished:withDict:)])
        {
            // If the request is successful then we parse the result into a json and keep it as a dictionary
            NSError *jsonParsingError = nil;
            NSDictionary* object = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            if (jsonParsingError)
            {
                // Log if there is a problem with parsing
                NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
            }
            else
            {
                NSLog(@"obj %@", object);
                // Call the requestfinished callback to pass the result to the delegate
                [weakSelf.delegate requestFinished:weakReq withDict:object];
            }
        }
    }];
}

@end
