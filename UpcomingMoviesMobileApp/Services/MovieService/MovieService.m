//
//  MovieService.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "MovieService.h"
#import "MoviesNetworkManager.h"
#import "Movie.h"
#import "MovieGroup.h"
#import "Genre.h"

@interface MovieService ()

+ (void)handleMoviesWithPage:(NSInteger)page shouldDeleteAllOtherMovies:(BOOL)shouldDeleteAllOtherMovies success:(void(^)(NSMutableArray *movieGroups))successBlock error:(void(^)(NSError *error))errorBlock;

@end

@implementation MovieService

#pragma mark - Upcoming Movies Methods

+ (void)getUpcomingMoviesWithSuccess:(void(^)(NSMutableArray *movieGroups))successBlock error:(void(^)(NSError *error))errorBlock {
    
    if (!IS_NETWORK_AVALIABLE) {
        NSMutableArray *movies = [[Movie findAllMovies] mutableCopy];
        NSMutableArray *movieGroups = [[MovieGroup movieGroupByDay:movies] mutableCopy];
        successBlock(movieGroups);
        return;
    }
    
    // Get genres then get upcoming movies.
    [MovieService getAllGenresWithSuccess:^(NSArray *genreList) {
        [MovieService handleMoviesWithPage:1 shouldDeleteAllOtherMovies:YES success:successBlock error:errorBlock];
    } error:^(NSError *error) {
        errorBlock(error);
    }];
    
    
}

+ (void)loadMoreUpcomingMoviesWithPage:(NSInteger)page success:(void(^)(NSMutableArray *movieGroups))successBlock error:(void(^)(NSError *error))errorBlock {
    if (!IS_NETWORK_AVALIABLE) {
        errorBlock(CREATE_ERROR(kNoInternetConnectionErrorMessage));
        return;
    }
    
    [MovieService handleMoviesWithPage:page shouldDeleteAllOtherMovies:NO success:successBlock error:errorBlock];
}

+ (void)handleMoviesWithPage:(NSInteger)page shouldDeleteAllOtherMovies:(BOOL)shouldDeleteAllOtherMovies success:(void(^)(NSMutableArray *movieGroups))successBlock error:(void(^)(NSError *error))errorBlock {
    
    [[MoviesNetworkManager sharedManager] getUpcomingMoviesWithPage:page success:^(NSDictionary *json) {
        NSArray *movies = [Movie insertUpdateMoviesFromArray:json[@"results"]];
        
        // Set the count.
        [SharedManager sharedManager].upcomingMaxPageCount = [json[@"total_pages"] integerValue];
        
        // Remove all previous enteries.
        if (shouldDeleteAllOtherMovies) {
            NSPredicate *relativeComplementPredicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", movies];
            [Movie MR_deleteAllMatchingPredicate:relativeComplementPredicate];
        }
        
        NSMutableArray *movieGroups = [[MovieGroup movieGroupByDay:movies] mutableCopy];
        
        successBlock(movieGroups);
    } error:^(NSError *error) {
        errorBlock(error);
    }];
}

#pragma mark - Genre Methods

+ (void)getAllGenresWithSuccess:(void (^)(NSMutableArray *genreList))successBlock error:(void (^)(NSError *error))errorBlock {
    
    if (!IS_NETWORK_AVALIABLE) {
        // Load genres from Database.
        NSMutableArray *genreList = [[Genre MR_findAll] mutableCopy];
        successBlock(genreList);
        return;
    }
    [[MoviesNetworkManager sharedManager] getAllGenresWithSuccess:^(NSDictionary *json) {
        // Create genre list.
        NSMutableArray *serverGenreList = [NSMutableArray new];
        
        // Insert/Update the server genres.
        [serverGenreList addObjectsFromArray:[Genre insertUpdateGenresFromArray:json[@"genres"]]];
        
        // Get all genres.
        NSMutableArray *removeGenreList = [[Genre MR_findAll] mutableCopy];
        
        // Remove the categories that are in database but not on the server.
        [removeGenreList removeObjectsInArray:serverGenreList];
        
        for (Genre *genre in removeGenreList) {
            [genre MR_deleteEntity];
        }
        
        successBlock(serverGenreList);
        
    } error:^(NSError *error) {
        // Load category from Database.
        NSMutableArray *genreList = [[Genre MR_findAll] mutableCopy];
        successBlock(genreList);
        return;
    }];
}

#pragma mark - Search Methods

+ (void)getSearchMoviesWithQuery:(NSString *)query page:(NSInteger)page success:(void(^)(NSMutableArray *movies))successBlock error:(void(^)(NSError *error))errorBlock {
    if (!IS_NETWORK_AVALIABLE) {
        errorBlock(CREATE_ERROR(kNoInternetConnectionErrorMessage));
        return;
    }
    
    // Get search context so that we can reset it later. This is help us keep search data temporary.
    NSManagedObjectContext *searchContext = [SharedManager sharedManager].searchContext;
    
    [[MoviesNetworkManager sharedManager] getSearchMoviesWithQuery:query page:page success:^(NSDictionary *json) {
        
        // Set the count.
        [SharedManager sharedManager].searchMaxPageCount = [json[@"total_pages"] integerValue];
        
        NSMutableArray *movies = [[Movie getMoviesFromArray:json[@"results"] context:searchContext] mutableCopy];
        successBlock(movies);
    } error:^(NSError *error) {
        errorBlock(error);
    }];
    
    
}

@end
