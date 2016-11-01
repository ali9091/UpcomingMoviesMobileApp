//
//  Genre.h
//  
//
//  Created by Ali Ehsan on 10/28/16.
//
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@class Movie;

NS_ASSUME_NONNULL_BEGIN

@interface Genre : BaseEntity

// Insert or update methods.
+ (Genre *)insertUpdateGenreWithoutSavingFromDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context;

+ (Genre *)insertUpdateGenreFromDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context;

+ (Genre *)insertUpdateGenreFromDictionary:(NSDictionary *)dictionary;

+ (NSArray *)getGenresFromArray:(NSArray *)array context:(NSManagedObjectContext *)context;

+ (NSArray *)insertUpdateGenresFromArray:(NSArray *)array context:(NSManagedObjectContext *)context;

+ (NSArray *)insertUpdateGenresFromArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END

#import "Genre+CoreDataProperties.h"
