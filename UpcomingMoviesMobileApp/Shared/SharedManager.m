//
//  SharedManager.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "SharedManager.h"

@implementation SharedManager

#pragma mark - Initialize Methods

+ (SharedManager *)sharedManager {
    static SharedManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SharedManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        _searchContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _searchContext.parentContext = DEFAULT_CONTEXT;
    }
    return self;
}

@end
