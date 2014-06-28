//
//  NSString+Extension.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/28/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString*)searchString
{
    NSMutableString *trimmedString =
    [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] mutableCopy];
    [trimmedString replaceOccurrencesOfString:@" "
                                   withString:@"+"
                                      options:0
                                        range:NSMakeRange(0, trimmedString.length)];
    return trimmedString;
}

@end
