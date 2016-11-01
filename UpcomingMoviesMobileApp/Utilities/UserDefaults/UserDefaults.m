//
//  UserDefaults.m
//  Nin60
//
//  Created by Ali Ehsan on 7/4/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "UserDefaults.h"

// Keys.
#define UPCOMING_PAGE @"upcomingPage"

// Helper Macros.
#define SET_BOOL(key, value) [[NSUserDefaults standardUserDefaults] setBool:value forKey:key]; SYNCHRONIZE
#define GET_BOOL(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define SET_OBJECT(key, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]; SYNCHRONIZE
#define GET_OBJECT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define REMOVE_OBJECT(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]; SYNCHRONIZE
#define SYNCHRONIZE [[NSUserDefaults standardUserDefaults] synchronize]

@implementation UserDefaults

#pragma mark - Singleton

+ (UserDefaults *)sharedInstance {
    static UserDefaults *sharedDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDefaults = [[UserDefaults alloc] init];
    });
    return sharedDefaults;
}

#pragma mark - Getters

- (NSInteger)upcomingPage {
    return [GET_OBJECT(UPCOMING_PAGE) integerValue];
}

#pragma mark - Setters

- (void)setUpcomingPage:(NSInteger)upcomingPage {
    SET_OBJECT(UPCOMING_PAGE, @(upcomingPage));
}

@end
