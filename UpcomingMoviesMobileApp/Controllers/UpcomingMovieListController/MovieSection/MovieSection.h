//
//  MovieSection.h
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/28/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieGroup.h"

@interface MovieSection : UITableViewHeaderFooterView

// Populate methods.
- (void)populateCellWithMovieGroup:(MovieGroup *)movieGroup;

@end
