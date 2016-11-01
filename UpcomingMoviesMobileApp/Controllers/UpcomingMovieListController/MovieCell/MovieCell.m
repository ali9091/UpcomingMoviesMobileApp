//
//  MovieCell.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/28/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+WebCache.h"

@interface MovieCell ()

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieGenresLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieReleaseDateLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageActivityIndicator;


@end

@implementation MovieCell

#pragma mark - View Methods

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Populate Methods

- (void)populateCellWithMovie:(Movie *)movie {
    
    // Set the image.
    [self.imageActivityIndicator startAnimating];
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:movie.posterPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imageActivityIndicator stopAnimating];
        if (error) {
            self.movieImageView.image = [UIImage imageNamed:kPlaceholderPosterPathImage];
        }
    }];
    
    // Set the labels.
    self.movieTitleLabel.text = movie.title;
    self.movieGenresLabel.text = [movie getGenresString];
    self.movieReleaseDateLabel.text = [DateUtility getStringFromStyle:NSDateFormatterMediumStyle date:movie.releaseDate];   
}

@end
