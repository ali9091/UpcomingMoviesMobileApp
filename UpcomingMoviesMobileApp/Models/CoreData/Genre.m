//
//  Genre.m
//  
//
//  Created by Ali Ehsan on 10/28/16.
//
//

#import "Genre.h"
#import "Movie.h"

@implementation Genre

// Insert code here to add functionality to your managed object subclass

#pragma mark - Insert or update Methods

+ (Genre *)insertUpdateGenreWithoutSavingFromDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context {
    Genre *genre = [Genre MR_findFirstByAttribute:PROP_STRING(genreID) withValue:dictionary[@"id"] inContext:context];
    
    // If genre is not found then create the genre.
    if (!genre) {
        genre = [Genre MR_createEntityInContext:context];
    }
    
    // Update or insert values from dictionary.
    [genre MR_importValuesForKeysWithObject:dictionary];
    
    return genre;
}

+ (Genre *)insertUpdateGenreWithoutSavingFromDictionary:(NSDictionary *)dictionary {
    return [Genre insertUpdateGenreWithoutSavingFromDictionary:dictionary context:DEFAULT_CONTEXT];
}


+ (Genre *)insertUpdateGenreFromDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context {
    
    Genre *genre = [Genre insertUpdateGenreWithoutSavingFromDictionary:dictionary context:context];
    
    [context MR_saveToPersistentStoreWithCompletion:nil];
    
    return genre;
}

+ (Genre *)insertUpdateGenreFromDictionary:(NSDictionary *)dictionary {
    
    Genre *genre = [Genre insertUpdateGenreFromDictionary:dictionary context:DEFAULT_CONTEXT];
    
    return genre;
}

+ (NSArray *)getGenresFromArray:(NSArray *)array context:(NSManagedObjectContext *)context {
    NSMutableArray *genres = [NSMutableArray array];
    
    for (NSDictionary *genreDictionary in array) {
        Genre *genre = [Genre insertUpdateGenreWithoutSavingFromDictionary:genreDictionary context:context];
        [genres addObject:genre];
    }
    
    return genres;
}

+ (NSArray *)insertUpdateGenresFromArray:(NSArray *)array context:(NSManagedObjectContext *)context {
    NSArray *genres = [Genre getGenresFromArray:array context:context];
    
    [context MR_saveToPersistentStoreWithCompletion:nil];
    
    return genres;
}

+ (NSArray *)insertUpdateGenresFromArray:(NSArray *)array {
    
    NSArray *genres = [Genre insertUpdateGenresFromArray:array context:DEFAULT_CONTEXT];
    
    return genres;
}



#pragma mark - Movies Methods

- (void)addMoviesObject:(Movie *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.movies];
    [tempSet addObject:value];
    self.movies = tempSet;
}

@end
