//
//  MovieService.h
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface MovieService : BaseService

// Upcoming movies methods.
+ (void)getUpcomingMoviesWithSuccess:(void(^)(NSMutableArray *movieGroups))successBlock error:(void(^)(NSError *error))errorBlock;

+ (void)loadMoreUpcomingMoviesWithPage:(NSInteger)page success:(void(^)(NSMutableArray *movieGroups))successBlock error:(void(^)(NSError *error))errorBlock;

// Genres methods.
+ (void)getAllGenresWithSuccess:(void (^)(NSMutableArray *genreList))successBlock error:(void (^)(NSError *error))errorBlock;

// Search methods.
+ (void)getSearchMoviesWithQuery:(NSString *)query page:(NSInteger)page success:(void(^)(NSMutableArray *movies))successBlock error:(void(^)(NSError *error))errorBlock;

@end
