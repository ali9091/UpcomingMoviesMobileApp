//
//  Genre+CoreDataProperties.h
//  
//
//  Created by Ali Ehsan on 10/28/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Genre.h"

NS_ASSUME_NONNULL_BEGIN

@interface Genre (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *genreID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSOrderedSet<Movie *> *movies;

@end

@interface Genre (CoreDataGeneratedAccessors)

- (void)insertObject:(Movie *)value inMoviesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMoviesAtIndex:(NSUInteger)idx;
- (void)insertMovies:(NSArray<Movie *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMoviesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMoviesAtIndex:(NSUInteger)idx withObject:(Movie *)value;
- (void)replaceMoviesAtIndexes:(NSIndexSet *)indexes withMovies:(NSArray<Movie *> *)values;
- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSOrderedSet<Movie *> *)values;
- (void)removeMovies:(NSOrderedSet<Movie *> *)values;

@end

NS_ASSUME_NONNULL_END
