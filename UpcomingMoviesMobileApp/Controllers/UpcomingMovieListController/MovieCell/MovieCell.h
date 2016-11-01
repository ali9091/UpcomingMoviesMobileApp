//
//  MovieCell.h
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/28/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCell : UITableViewCell

// Populate methods.
- (void)populateCellWithMovie:(Movie *)movie;

@end
