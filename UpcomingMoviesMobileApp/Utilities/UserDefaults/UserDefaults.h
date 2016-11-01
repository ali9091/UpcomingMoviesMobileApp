//
//  UserDefaults.h
//  Nin60
//
//  Created by Ali Ehsan on 7/4/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_DEFAULTS [UserDefaults sharedInstance]

@interface UserDefaults : NSObject

+ (UserDefaults *)sharedInstance;

@property (nonatomic) NSInteger upcomingPage;

@end
