//
//  BaseMovieListController.h
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "ImagePrefetcher.h"

@interface BaseMovieListController : BaseController <UIScrollViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, ImagePrefetcherDelegate>

// Properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ImagePrefetcher *imagePrefetcher;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UILabel *noMoviesFoundLabel;

// View methods.
- (void)setupView;
- (void)setupSearch;
- (void)setupRefreshWithLazyLoading;

// Load methods.
- (void)loadData;
- (void)loadMoreData;
- (void)reloadTableViewData;

@end
