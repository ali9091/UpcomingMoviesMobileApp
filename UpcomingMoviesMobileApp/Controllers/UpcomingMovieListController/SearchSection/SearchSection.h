//
//  SearchSection.h
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 11/1/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchSection;

@protocol SearchSectionDelegate <NSObject>

- (void)searchSectionDidSelectSearchButton:(SearchSection *)searchSection;

@end

@interface SearchSection : UITableViewHeaderFooterView

// Properties
@property (weak, nonatomic) id <SearchSectionDelegate> delegate;

@end
