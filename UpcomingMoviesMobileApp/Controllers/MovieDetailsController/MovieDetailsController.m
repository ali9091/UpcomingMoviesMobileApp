//
//  MovieDetailsController.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "MovieDetailsController.h"
#import "UIImageView+WebCache.h"

@interface MovieDetailsController ()

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UIImageView *backDropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterPathImageView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *backDropActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *posterPathActivityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIView *overviewLabel1View;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel1;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel2;

@end

@implementation MovieDetailsController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Populate data.
    [self populateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Methods

- (void)populateData {
    
    // Load images.
    [self populateImages];
    
    // Populate labels.
    [self populateLabels];
}

- (void)populateImages {
    [self.posterPathActivityIndicator startAnimating];
    [self.posterPathImageView sd_setImageWithURL:[NSURL URLWithString:self.movie.posterPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.posterPathActivityIndicator stopAnimating];
        if (error) {
            self.posterPathImageView.image = [UIImage imageNamed:kPlaceholderPosterPathImage];
        }
    }];
    
    [self.backDropActivityIndicator startAnimating];
    [self.backDropImageView sd_setImageWithURL:[NSURL URLWithString:self.movie.backdropPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.backDropActivityIndicator stopAnimating];
        if (error) {
            self.backDropImageView.image = [UIImage imageNamed:kPlaceholderBackdropPathImage];
        }
    }];
}

- (void)populateLabels {
    self.titleLabel.text = self.movie.title;
    self.genreLabel.text = [self.movie getGenresString];
    self.releaseDateLabel.text = [DateUtility getStringFromStyle:NSDateFormatterMediumStyle date:self.movie.releaseDate];
    [self populateOverviewLabels];
}

- (void)populateOverviewLabels {
    
    /* This is not the prettiest of of my methods but since there is
     no native way for seperating string between two labels, I had to
     write this. :)
     */
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    NSString *overview = self.movie.overview;
    NSInteger i = 0;
    for (; i < overview.length; i++) {
        NSString *text = [overview substringWithRange:NSMakeRange(0, i)];
        
        CGSize constraint = CGSizeMake(CGRectGetWidth(self.overviewLabel1View.frame),CGFLOAT_MAX);
        NSDictionary *attributes = @{NSFontAttributeName: self.overviewLabel1.font};
        CGRect rect = [text boundingRectWithSize:constraint
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      attributes:attributes
                                         context:nil];
        if (rect.size.height > CGRectGetHeight(self.overviewLabel1View.frame)) {
            break;
        }
    }
    
    BOOL appendDash = NO;
    if (i - 2 > 0 && i < overview.length) {
        i -= 2;
        NSString *iChar = [NSString stringWithFormat:@"%c" , [overview characterAtIndex:i]];
        if (![ValidationUtility isBlankLine:iChar]) {
            appendDash = YES;
        }
    }
    
    self.overviewLabel1.text = [overview substringWithRange:NSMakeRange(0, i)];
    if (appendDash) {
        self.overviewLabel1.text = [self.overviewLabel1.text stringByAppendingString:@"-"];
    }
    self.overviewLabel2.text = [overview substringWithRange:NSMakeRange(i, (overview.length - i))];
}

@end
