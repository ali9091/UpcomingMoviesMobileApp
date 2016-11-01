//
//  MovieGroup.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "MovieGroup.h"
#import "Movie.h"
#import "DateUtility.h"

@implementation MovieGroup

#pragma mark - Copy Methods

- (id)copyWithZone:(NSZone *)zone {
    MovieGroup *movieGroup = [[self.class allocWithZone:zone] init];
    movieGroup->_date = self.date;
    movieGroup->_movies = [self.movies mutableCopy];
    return movieGroup;
}

#pragma mark - Grouping Methods

+ (NSArray *)movieGroupByDay:(NSArray *)movies {
    
    // Sort movies by date.
    NSArray *sortedMovies = [Movie arrayBySortingMovieArray:movies];
    
    NSMutableArray *movieGroups = [NSMutableArray array];
    MovieGroup *currentMovieGroup = nil;
    
    for (Movie *movie in sortedMovies) {
        
        // Get the date without time from date.
        NSDate *date = [DateUtility dateWithoutTimeFromDate:movie.releaseDate];
        
        // If movie group exists then add the movie to this group.
        if (currentMovieGroup && ([currentMovieGroup.date compare:date] == NSOrderedSame)) {
            [currentMovieGroup.movies addObject:movie];
        }
        // Otherwise create a new movie group and add the movie to this new group.
        else {
            MovieGroup *newMovieGroup = [MovieGroup new];
            newMovieGroup.date = date;
            newMovieGroup.movies = [NSMutableArray new];
            [newMovieGroup.movies addObject:movie];
            currentMovieGroup = newMovieGroup;
            [movieGroups addObject:newMovieGroup];
        }
    }
    return movieGroups;
}

+ (NSMutableArray *)mergeMovieGroups:(NSArray *)movieGroups1 withMovieGroups:(NSArray *)movieGroups2 {
    NSMutableArray *mergedMovieGroups = [NSMutableArray arrayWithArray:movieGroups1];
    for (MovieGroup *movieGroup2 in movieGroups2) {
        BOOL found = NO;
        for (MovieGroup *movieGroup1 in movieGroups1) {
            // Merge beacuse of same day.
            if ([movieGroup2.date compare:movieGroup1.date] == NSOrderedSame) {
                [movieGroup1 mergeWithMovieGroup:movieGroup2];
                found = YES;
                break;
            }
        }
        if (!found) {
            // New date so just add it to the merged group.
            [mergedMovieGroups addObject:movieGroup2];
        }
    }
    
    // Sort merged movie groups.
    return [[MovieGroup arrayBySortingMovieGroupArray:mergedMovieGroups] mutableCopy];
}

- (void)mergeWithMovieGroup:(MovieGroup *)movieGroup {
    
    // The API also returns duplicates that we have to remove.
    [self removeDuplicateMovieObjectsWithOrderFromMovieGroup:movieGroup];
    
    [self.movies addObjectsFromArray:movieGroup.movies];
    
    NSArray *sortedMovies = [Movie arrayBySortingMovieArray:self.movies];
    
    self.movies = [sortedMovies mutableCopy];
}

- (void)removeDuplicateMovieObjectsWithOrderFromMovieGroup:(MovieGroup *)movieGroup {
    
    // Find the duplicates
    NSMutableArray *duplicates = [NSMutableArray new];
    for (Movie *movie1 in self.movies) {
        for (Movie *movie2 in movieGroup.movies) {
            if ([movie1.movieID integerValue] == [movie2.movieID integerValue]) {
                [duplicates addObject:movie2];
            }
        }
    }
    
    // Remove the duplicates.
    [movieGroup.movies removeObjectsInArray:duplicates];
}

#pragma mark - Sort Methods

+ (NSArray *)arrayBySortingMovieGroupArray:(NSArray *)movieGroups {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:PROP_STRING(date) ascending:YES];
    NSArray *sortedMovies = [movieGroups sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedMovies;
}

#pragma mark - Count Methods

+ (NSInteger)movieCountFromArray:(NSArray *)movieGroups {
    return [[movieGroups valueForKeyPath:@"self.@unionOfArrays.movies"] count];
}

#pragma mark - Filter Methods

- (void)filterByTitle:(NSString *)title {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.title CONTAINS[cd] %@", title];
    [self.movies filterUsingPredicate:predicate];
}

@end
