//
//  ValidationUtility.m
//  Nin60
//
//  Created by Ali Ehsan on 7/3/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "ValidationUtility.h"

@implementation ValidationUtility

+ (BOOL)isBlankLine:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

@end
