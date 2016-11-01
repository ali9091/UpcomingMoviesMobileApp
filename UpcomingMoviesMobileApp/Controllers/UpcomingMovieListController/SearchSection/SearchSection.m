//
//  SearchSection.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 11/1/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "SearchSection.h"

@implementation SearchSection

#pragma mark - Action Methods

- (IBAction)searchButtonSelected:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchSectionDidSelectSearchButton:)]) {
        [self.delegate searchSectionDidSelectSearchButton:self];
    }
}

@end
