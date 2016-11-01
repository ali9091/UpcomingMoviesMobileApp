//
//  Movie.m
//  
//
//  Created by Ali Ehsan on 10/27/16.
//
//

#import "Movie.h"
#import "Genre.h"

@implementation Movie

// Insert code here to add functionality to your managed object subclass

#pragma mark - Insert or update Methods

+ (Movie *)insertUpdateMovieWithoutSavingFromDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context {
    Movie *movie = [Movie MR_findFirstByAttribute:PROP_STRING(movieID) withValue:dictionary[@"id"] inContext:context];
    
    // If movie is not found then create the movie.
    if (!movie) {
        movie = [Movie MR_createEntityInContext:context];
    }
    
    // Update or insert values from dictionary.
    [movie MR_importValuesForKeysWithObject:dictionary];
    
    // Set the image URLs
    if (movie.posterPath) {
        movie.posterPath = [kImageBaseURL stringByAppendingString:movie.posterPath];
    }
    if (movie.backdropPath) {
        movie.backdropPath = [kImageBaseURL stringByAppendingString:movie.backdropPath];
    }
    
    // Associate the movie with categories.
    for (NSNumber *genreID in movie.genreIDs) {
        Genre *genre = [Genre MR_findFirstByAttribute:PROP_STRING(genreID) withValue:genreID inContext:context];
        if (genre) {
            [genre addMoviesObject:movie];
        }
    }
    
    return movie;
}

+ (Movie *)insertUpdateMovieWithoutSavingFromDictionary:(NSDictionary *)dictionary {
    return [Movie insertUpdateMovieWithoutSavingFromDictionary:dictionary context:DEFAULT_CONTEXT];
}


+ (Movie *)insertUpdateMovieFromDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context {
    
    Movie *movie = [Movie insertUpdateMovieWithoutSavingFromDictionary:dictionary context:context];
    
    [context MR_saveToPersistentStoreWithCompletion:nil];
    
    return movie;
}

+ (Movie *)insertUpdateMovieFromDictionary:(NSDictionary *)dictionary {
    
    Movie *movie = [Movie insertUpdateMovieFromDictionary:dictionary context:DEFAULT_CONTEXT];
    
    return movie;
}

+ (NSArray *)getMoviesFromArray:(NSArray *)array context:(NSManagedObjectContext *)context {
    NSMutableArray *movies = [NSMutableArray array];
    
    for (NSDictionary *movieDictionary in array) {
        Movie *movie = [Movie insertUpdateMovieWithoutSavingFromDictionary:movieDictionary context:context];
        [movies addObject:movie];
    }
    
    return movies;
}

+ (NSArray *)insertUpdateMoviesFromArray:(NSArray *)array context:(NSManagedObjectContext *)context {
    NSArray *movies = [Movie getMoviesFromArray:array context:context];
    
    [context MR_saveToPersistentStoreWithCompletion:nil];
    
    return movies;
}

+ (NSArray *)insertUpdateMoviesFromArray:(NSArray *)array {
    
    NSArray *movies = [Movie insertUpdateMoviesFromArray:array context:DEFAULT_CONTEXT];
    
    return movies;
}

#pragma mark - Find Methods

+ (NSArray *)findAllMovies {
    NSArray *movies = [Movie MR_findAllSortedBy:PROP_STRING(releaseDate) ascending:YES];
    return movies;
}

#pragma mark - Sort Methods

+ (NSArray *)arrayBySortingMovieArray:(NSArray *)movies {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:PROP_STRING(releaseDate) ascending:YES];
    NSArray *sortedMovies = [movies sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedMovies;
}

#pragma mark - Genre Methods

- (NSString *)getGenresString {
    return [[[self.genres array] valueForKeyPath:@"@unionOfObjects.name"] componentsJoinedByString:@", "];
}

@end
