//
//  MovieSection.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/28/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "MovieSection.h"

@interface MovieSection ()

@property (weak, nonatomic) IBOutlet UILabel *sectionDateLabel;

@end

@implementation MovieSection

#pragma mark - Populate Methods

- (void)populateCellWithMovieGroup:(MovieGroup *)movieGroup {
    self.sectionDateLabel.text = [DateUtility getStringFromStringFormat:kDayMonthYearDateFormat date:movieGroup.date];
}

@end
