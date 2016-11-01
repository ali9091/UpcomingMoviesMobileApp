//
//  DateUtility.m
//  DictationApp
//
//  Created by Ali Ehsan on 10/10/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

+ (NSDate *)dateWithoutTimeFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    return [calendar dateFromComponents:components];
}

+ (NSString *)getStringFromStringFormat:(NSString *)stringFormat date:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:stringFormat];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getStringFromStyle:(NSDateFormatterStyle)dateStyle date:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:dateStyle];
    return [dateFormatter stringFromDate:date];
}

@end
