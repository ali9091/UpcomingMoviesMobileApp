//
//  UpcomingMovieListController.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "UpcomingMovieListController.h"
#import "MovieSection.h"
#import "MovieService.h"
#import "MovieGroup.h"
#import "MovieCell.h"
#import "SearchSection.h"
#import "SDWebImagePrefetcher.h"
#import "MovieDetailsController.h"
#import "SearchMovieListController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface UpcomingMovieListController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SearchSectionDelegate>

@property (strong, nonatomic) NSMutableArray *movieGroups;
@property (strong, nonatomic) NSMutableArray *filteredMovieGroups;

@end

@implementation UpcomingMovieListController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load data.
    [self showProgress];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    [super setupView];
    
    // Setup navigation bar.
    [self setupNavigationBar];
    
    // Register section.
    [self.tableView registerNib:[UINib nibWithNibName:CLASS_STRING(MovieSection) bundle:nil] forHeaderFooterViewReuseIdentifier:CLASS_STRING(MovieSection)];
    [self.tableView registerNib:[UINib nibWithNibName:CLASS_STRING(SearchSection) bundle:nil] forHeaderFooterViewReuseIdentifier:CLASS_STRING(SearchSection)];
    
    // Set height of tableview section.
    self.tableView.estimatedSectionHeaderHeight = self.tableView.sectionHeaderHeight;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;

}

- (void)setupSearch {
    [super setupSearch];
    self.definesPresentationContext = YES;
    self.searchController.searchBar.delegate = self;
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.barStyle =  UIBarStyleBlack;
}

#pragma mark - Load Data

- (void)loadData {
    self.tableView.showsInfiniteScrolling = YES;
    ENABLE_INTERACTION(self.tableView,NO);
    [MovieService getUpcomingMoviesWithSuccess:^(NSMutableArray *movieGroups) {
        
        // Set Page.
        USER_DEFAULTS.upcomingPage = 1;
        
        // Hide progress HUDs.
        [self hideProgress];
        [self.tableView.pullToRefreshView stopAnimating];
        
        // Set the data in tableview.
        self.movieGroups = movieGroups;
        [self reloadAllMovies];
        
        // Prefetch images.
        [self.imagePrefetcher prefetchImagesForTableView:self.tableView];
        
        // Enable interaction with table view.
        ENABLE_INTERACTION(self.tableView,YES);
        
        // Incase user is offline, show error message.
        if (!IS_NETWORK_AVALIABLE) {
            [self handleFailure:CREATE_ERROR(kNoInternetConnectionErrorMessage)];
        }
        
    } error:^(NSError *error) {
        [self.tableView.pullToRefreshView stopAnimating];
        [self handleFailure:error];
        ENABLE_INTERACTION(self.tableView,YES);
    }];
}

- (void)loadMoreData {
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Load more data...");
    // We are storing upcoming page in user defaults for offline support.
    USER_DEFAULTS.upcomingPage++;
    // Stop lazy loading if max page is reached.
    if (IS_NETWORK_AVALIABLE && (USER_DEFAULTS.upcomingPage > [SharedManager sharedManager].upcomingMaxPageCount)) {
        NSLog(@"Max page reached.");
        self.tableView.showsInfiniteScrolling = NO;
        return;
    }
    NSLog(@"**********************************Page %ld", (long)USER_DEFAULTS.upcomingPage);
    [MovieService loadMoreUpcomingMoviesWithPage:USER_DEFAULTS.upcomingPage success:^(NSMutableArray *movieGroups) {
        // Append the movies groups and reload.
        self.movieGroups = [MovieGroup mergeMovieGroups:self.movieGroups withMovieGroups:movieGroups];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self reloadAllMovies];
    } error:^(NSError *error) {
        // In case of error, decrement the page so it is loaded again.
        USER_DEFAULTS.upcomingPage--;
        [self.tableView.infiniteScrollingView stopAnimating];
        [self handleFailure:error];
    }];
}

- (void)reloadTableViewData {
    self.noMoviesFoundLabel.hidden = [self.movieGroups count] ? YES : NO;
    [super reloadTableViewData];
}

- (void)reloadAllMovies {
    [self filterMoviesForSearchText:self.searchController.searchBar.text];
    [self reloadTableViewData];
}

#pragma mark - Filter Methods

- (void)filterMoviesForSearchText:(NSString *)searchText {
    if (searchText.length == 0) {
        self.tableView.showsInfiniteScrolling = YES;
        self.filteredMovieGroups =  [[NSMutableArray alloc] initWithArray:self.movieGroups copyItems:YES];
    }
    else {
        self.tableView.showsInfiniteScrolling = NO;
        self.filteredMovieGroups =  [self filterMovieGroupsFromMovieGroups:self.movieGroups text:searchText];
    }
    
    [self removeEmptyMovieGroupsFromMovieGroup:self.filteredMovieGroups];
}

- (void)removeEmptyMovieGroupsFromMovieGroup:(NSMutableArray *)movieGroup {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.movies.@count > 0"];
    [self.filteredMovieGroups filterUsingPredicate:predicate];
}

- (NSMutableArray *)filterMovieGroupsFromMovieGroups:(NSMutableArray *)movieGroup text:(NSString *)text {
    NSMutableArray *filterMovieGroups =  [[NSMutableArray alloc] initWithArray:movieGroup copyItems:YES];
    for (MovieGroup *movieGroup in filterMovieGroups) {
        [movieGroup filterByTitle:text];
    }
    return filterMovieGroups;
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger count = [self.filteredMovieGroups count];
    
    // If last section and search is active then add the search cell in the last row.
    count = (self.searchController.active) ? count + 1 : count;
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Search section.
    if (section >= [self.filteredMovieGroups count]) {
        return 0;
    }
    
    MovieGroup *movieGroup = self.filteredMovieGroups[section];
    
    NSInteger count = [movieGroup.movies count];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the cell.
    MovieCell *movieCell = [self.tableView dequeueReusableCellWithIdentifier:CLASS_STRING(MovieCell)];
    
    // Remove selection style.
    movieCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Get the data.
    MovieGroup *movieGroup = self.filteredMovieGroups[indexPath.section];
    Movie *movie = movieGroup.movies[indexPath.row];
    
    // Populate the cell.
    [movieCell populateCellWithMovie:movie];
    
    return movieCell;
}

#pragma mark - Table View Delegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // Search section.
    if (section >= [self.filteredMovieGroups count]) {
        SearchSection *searchSection = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:CLASS_STRING(SearchSection)];
        searchSection.delegate = self;
        return searchSection;
    }
    
    // Get the section.
    MovieSection *movieSection = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:CLASS_STRING(MovieSection)];
    
    // Get the model.
    MovieGroup *movieGroup = self.filteredMovieGroups[section];
    
    // Populate the section.
    [movieSection populateCellWithMovieGroup:movieGroup];
    
    return movieSection;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the model.
    MovieGroup *movieGroup = self.filteredMovieGroups[indexPath.section];
    Movie *movie = movieGroup.movies[indexPath.row];
    
    MovieDetailsController *movieDetailsController = GET_CONTROLLER_WITH_CLASS([MovieDetailsController class]);
    movieDetailsController.movie = movie;
    [self.navigationController pushViewController:movieDetailsController animated:YES];
}

#pragma mark - Search Results Updating Delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self reloadAllMovies];
}

#pragma mark - Search Controller Delegate

- (void)didPresentSearchController:(UISearchController *)searchController {
    [self reloadAllMovies];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    [self reloadAllMovies];
}

#pragma mark - Image Prefetcher Delegate

- (NSArray *)imagePrefetcher:(ImagePrefetcher *)imagePrefetcher urlsForIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *urlArray = [NSMutableArray new];
    
    if (indexPath.section >= [self.filteredMovieGroups count]) {
        return urlArray;
    }
    
    MovieGroup *movieGroup = self.filteredMovieGroups[indexPath.section];
    Movie *movie = movieGroup.movies[indexPath.row];
    
    if (movie.posterPath) {
        [urlArray addObject:[NSURL URLWithString:movie.posterPath]];
    }
    
    return urlArray;
}

#pragma mark - Search Section Delegate

- (void)searchSectionDidSelectSearchButton:(SearchSection *)searchSection {
    NSString *query = self.searchController.searchBar.text;
    
    // Validate the query
    if ([ValidationUtility isBlankLine:query] || query.length < 3) {
        [self handleFailure:CREATE_ERROR(kSearchQueryLengthErrorMessage)];
        return;
    }
    
    SearchMovieListController *searchMovieListController = GET_CONTROLLER_WITH_CLASS([SearchMovieListController class]);
    searchMovieListController.query = self.searchController.searchBar.text;
    [self.navigationController pushViewController:searchMovieListController animated:YES];
}

@end
