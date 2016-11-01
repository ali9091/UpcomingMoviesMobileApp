//
//  Movie.h
//  
//
//  Created by Ali Ehsan on 10/27/16.
//
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Movie : BaseEntity

// Insert or update methods.
+ (Movie *)insertUpdateMovieWithoutSavingFromDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context;

+ (Movie *)insertUpdateMovieWithoutSavingFromDictionary:(NSDictionary *)dictionary;

+ (Movie *)insertUpdateMovieFromDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context;

+ (Movie *)insertUpdateMovieFromDictionary:(NSDictionary *)dictionary;

+ (NSArray *)getMoviesFromArray:(NSArray *)array context:(NSManagedObjectContext *)context;

+ (NSArray *)insertUpdateMoviesFromArray:(NSArray *)array context:(NSManagedObjectContext *)context ;

+ (NSArray *)insertUpdateMoviesFromArray:(NSArray *)array;

// Find methods.
+ (NSArray *)findAllMovies;

// Sort methods.
+ (NSArray *)arrayBySortingMovieArray:(NSArray *)movies;

// Genre methods.
- (NSString *)getGenresString;


@end

NS_ASSUME_NONNULL_END

#import "Movie+CoreDataProperties.h"
