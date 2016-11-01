//
//  MovieGroup.h
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface MovieGroup : BaseModel

// Properties.
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSMutableArray *movies;

// Grouping methods.
+ (NSArray *)movieGroupByDay:(NSArray *)movies;
+ (NSMutableArray *)mergeMovieGroups:(NSArray *)movieGroups1 withMovieGroups:(NSArray *)movieGroups2;

// Filter methods.
- (void)filterByTitle:(NSString *)title;

// Count methods.
+ (NSInteger)movieCountFromArray:(NSArray *)movieGroups;

@end
