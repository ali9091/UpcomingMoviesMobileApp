//
//  MoviesNetworkManager.h
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetworkManager.h"

@interface MoviesNetworkManager : BaseNetworkManager

// Initialization methods.
+ (MoviesNetworkManager *)sharedManager;

// API calls.
- (void)getUpcomingMoviesWithPage:(NSInteger)page success:(void(^)(NSDictionary *json))successBlock error:(void(^)(NSError *error))errorBlock;

- (void)getSearchMoviesWithQuery:(NSString *)query page:(NSInteger)page success:(void(^)(NSDictionary *json))successBlock error:(void(^)(NSError *error))errorBlock;

- (void)getAllGenresWithSuccess:(void(^)(NSDictionary *json))successBlock error:(void(^)(NSError *error))errorBlock;

@end
