//
//  BaseMovieListController.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "BaseMovieListController.h"
#import "MovieCell.h"
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface BaseMovieListController ()

@end

@implementation BaseMovieListController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup View.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    
    // Register cell.
    [self.tableView registerNib:[UINib nibWithNibName:CLASS_STRING(MovieCell) bundle:nil] forCellReuseIdentifier:CLASS_STRING(MovieCell)];
    
    // Set height of tableview cell.
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
        
    // Setup image prefetcher.
    [self setupImagePrefetcher];
    
    // Add Refresh and lazy loading.
    [self setupRefreshWithLazyLoading];
    
    // Setup search.
    [self setupSearch];
    
    UIImage *image = [UIImage imageNamed:@"gray-image"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2.0f topCapHeight:0.0f];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)setupImagePrefetcher {
    self.imagePrefetcher = [[ImagePrefetcher alloc] initWithPrefetchCount:kPrefetchRowCount];
    self.imagePrefetcher.delegate = self;
}

- (void)setupRefreshWithLazyLoading {
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self loadData];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self loadMoreData];
    }];
}

- (void)setupSearch {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    [self.view addSubview:self.searchController.searchBar];
}

#pragma mark - Load Data Methods

- (void)loadData {
    // Override me.
}

- (void)loadMoreData {
    // Override me.
}

- (void)reloadTableViewData {
    [self.tableView reloadData];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // if `decelerate` was true for `scrollViewDidEndDragging:willDecelerate:`
    // this will be called when the deceleration is done
    
    [self.imagePrefetcher prefetchImagesForTableView:self.tableView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // if `decelerate` is true, then we shouldn't start prefetching yet, because
    // `cellForRowAtIndexPath` will be hard at work returning cells for the currently visible
    // cells.
    
    if (!decelerate)
        [self.imagePrefetcher prefetchImagesForTableView:self.tableView];
}

#pragma mark - Search Results Updating Delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // Override me.
}


#pragma mark - Image Prefetcher Delegate

- (NSArray *)imagePrefetcher:(ImagePrefetcher *)imagePrefetcher urlsForIndexPath:(NSIndexPath *)indexPath {
    // Override me.
    return [NSArray new];
}


@end
