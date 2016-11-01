//
//  DateUtility.h
//  DictationApp
//
//  Created by Ali Ehsan on 10/10/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtility : NSObject

+ (NSDate *)dateWithoutTimeFromDate:(NSDate *)date;

+ (NSString *)getStringFromStringFormat:(NSString *)stringFormat date:(NSDate *)date;

+ (NSString *)getStringFromStyle:(NSDateFormatterStyle)dateStyle date:(NSDate *)date;

@end
