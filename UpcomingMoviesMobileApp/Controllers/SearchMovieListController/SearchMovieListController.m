//
//  SearchMovieListController.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "SearchMovieListController.h"
#import "MovieCell.h"
#import "MovieService.h"
#import "MovieDetailsController.h"
#import "SharedManager.h"
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface SearchMovieListController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

#pragma mark - Properties

@property (strong, nonatomic) NSMutableArray *movies;
@property (nonatomic) NSInteger page;

@end

@implementation SearchMovieListController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set query.
    self.searchController.searchBar.text = self.query;
    
    // Set navigation bar.
    [self setupNavigationBar];
    
    // Load data.
    [self showProgress];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.isMovingFromParentViewController) {
        // Delete temporary movies.
        [[SharedManager sharedManager].searchContext reset];
    }
}

- (void)setupView {
    [super setupView];
}

- (void)setupSearch {
    [super setupSearch];
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
}

- (void)setupNavigationBar {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kSearch
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
}

- (void)setupRefreshWithLazyLoading {
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self loadDataWillChangeQuery:NO];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self loadMoreData];
    }];
}

#pragma mark - Load Data

- (void)loadData {
    [self loadDataWillChangeQuery:YES];
}

- (void)loadDataWillChangeQuery:(BOOL)willChangeQuery {
    self.page = 1;
    self.query = willChangeQuery ? self.searchController.searchBar.text : self.query;
    self.tableView.showsInfiniteScrolling = YES;
    ENABLE_INTERACTION(self.tableView,NO);
    [MovieService getSearchMoviesWithQuery:self.query page:self.page success:^(NSMutableArray *movies) {
        
        // Hide progress HUDs.
        [self hideProgress];
        [self.tableView.pullToRefreshView stopAnimating];
        
        // Set the data in tableview.
        self.movies = movies;
        [self reloadAllMovies];
        
        // Prefetch images.
        [self.imagePrefetcher prefetchImagesForTableView:self.tableView];
        
        // Enable interaction with table view.
        ENABLE_INTERACTION(self.tableView,YES);
        
        
    } error:^(NSError *error) {
        [self.tableView.pullToRefreshView stopAnimating];
        [self handleFailure:error];
        ENABLE_INTERACTION(self.tableView,YES);
    }];
}

- (void)loadMoreData {
    self.page++;
    // Stop lazy loading if max page is reached.
    if (IS_NETWORK_AVALIABLE && (self.page > [SharedManager sharedManager].searchMaxPageCount)) {
        NSLog(@"Max page reached.");
        self.tableView.showsInfiniteScrolling = NO;
        return;
    }
    [MovieService getSearchMoviesWithQuery:self.query page:self.page success:^(NSMutableArray *movies) {
        // Append the movies and reload.
        [self.movies addObjectsFromArray:movies];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self reloadAllMovies];
    } error:^(NSError *error) {
        // In case of error, decrement the page so it is loaded again.
        self.page--;
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
    
}

- (void)reloadTableViewData {
    self.noMoviesFoundLabel.hidden = [self.movies count] ? YES : NO;
    [super reloadTableViewData];
}

- (void)reloadAllMovies {
    [self reloadTableViewData];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the cell.
    MovieCell *movieCell = [self.tableView dequeueReusableCellWithIdentifier:CLASS_STRING(MovieCell)];
    
    // Remove selection style.
    movieCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Get the model.
    Movie *movie = self.movies[indexPath.row];
    
    // Populate the cell.
    [movieCell populateCellWithMovie:movie];
    
    return movieCell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the model.
    Movie *movie = self.movies[indexPath.row];
    
    MovieDetailsController *movieDetailsController = GET_CONTROLLER_WITH_CLASS([MovieDetailsController class]);
    movieDetailsController.movie = movie;
    [self.navigationController pushViewController:movieDetailsController animated:YES];
}

#pragma mark - Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // Validate the query
    if ([ValidationUtility isBlankLine:searchBar.text] || searchBar.text.length < 3) {
        [self handleFailure:CREATE_ERROR(kSearchQueryLengthErrorMessage)];
        return;
    }
    
    [self loadData];
}

#pragma mark - Image Prefetcher Delegate

- (NSArray *)imagePrefetcher:(ImagePrefetcher *)imagePrefetcher urlsForIndexPath:(NSIndexPath *)indexPath {
    Movie *movie = self.movies[indexPath.row];
    
    NSMutableArray *urlArray = [NSMutableArray new];
    
    if (movie.posterPath) {
        [urlArray addObject:[NSURL URLWithString:movie.posterPath]];
    }
    
    return urlArray;
}


@end
