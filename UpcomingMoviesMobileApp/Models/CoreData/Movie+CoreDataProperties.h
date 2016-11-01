//
//  Movie+CoreDataProperties.h
//  
//
//  Created by Ali Ehsan on 10/28/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Movie.h"
#import "Genre.h"

NS_ASSUME_NONNULL_BEGIN

@interface Movie (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *adult;
@property (nullable, nonatomic, retain) NSString *backdropPath;
@property (nullable, nonatomic, retain) id genreIDs;
@property (nullable, nonatomic, retain) NSNumber *movieID;
@property (nullable, nonatomic, retain) NSString *originalLanguage;
@property (nullable, nonatomic, retain) NSString *originalTitle;
@property (nullable, nonatomic, retain) NSString *overview;
@property (nullable, nonatomic, retain) NSNumber *popularity;
@property (nullable, nonatomic, retain) NSString *posterPath;
@property (nullable, nonatomic, retain) NSDate *releaseDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *video;
@property (nullable, nonatomic, retain) NSNumber *voteAverage;
@property (nullable, nonatomic, retain) NSNumber *voteCount;
@property (nullable, nonatomic, retain) NSOrderedSet<Genre *> *genres;

@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)insertObject:(Genre *)value inGenresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromGenresAtIndex:(NSUInteger)idx;
- (void)insertGenres:(NSArray<Genre *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeGenresAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInGenresAtIndex:(NSUInteger)idx withObject:(Genre *)value;
- (void)replaceGenresAtIndexes:(NSIndexSet *)indexes withGenres:(NSArray<Genre *> *)values;
- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSOrderedSet<Genre *> *)values;
- (void)removeGenres:(NSOrderedSet<Genre *> *)values;

@end

NS_ASSUME_NONNULL_END
