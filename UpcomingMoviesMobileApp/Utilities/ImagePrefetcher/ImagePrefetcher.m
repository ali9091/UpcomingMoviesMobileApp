//
//  ImagePrefetcher.m
//  Nin60
//
//  Created by Ali Ehsan on 7/31/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "ImagePrefetcher.h"
#import "SDWebImagePrefetcher.h"

@implementation ImagePrefetcher

- (instancetype)initWithPrefetchCount:(NSInteger)prefetchCount {
    self = [super init];
    if (self) {
        self.prefetchCount = prefetchCount;
    }
    return self;
}

#pragma mark - Prefetching Methods

- (void)prefetchImagesForTableView:(UITableView *)tableView
{
    NSArray *indexPaths = [tableView indexPathsForVisibleRows];
    if ([indexPaths count] == 0) {
        return;
    }
    
    NSIndexPath *minimumIndexPath = indexPaths[0];
    NSIndexPath *maximumIndexPath = [indexPaths lastObject];
    
    // they should be sorted already, but if not, update min and max accordingly
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        if (indexPath.section < minimumIndexPath.section || (indexPath.section == minimumIndexPath.section && indexPath.row < minimumIndexPath.row)) minimumIndexPath = indexPath;
        if (indexPath.section > maximumIndexPath.section || (indexPath.section == maximumIndexPath.section && indexPath.row > maximumIndexPath.row)) maximumIndexPath = indexPath;
    }
    
    // build array of imageURLs for cells to prefetch
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    indexPaths = [self tableView:tableView priorIndexPathCount:self.prefetchCount fromIndexPath:minimumIndexPath];
    for (NSIndexPath *indexPath in indexPaths) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePrefetcher:urlsForIndexPath:)]) {
            NSArray *urlArray = [self.delegate imagePrefetcher:self urlsForIndexPath:indexPath];
            if (urlArray) {
                [imageURLs addObjectsFromArray:urlArray];
            }
        }
    }
    indexPaths = [self tableView:tableView nextIndexPathCount:self.prefetchCount fromIndexPath:maximumIndexPath];
    for (NSIndexPath *indexPath in indexPaths) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePrefetcher:urlsForIndexPath:)]) {
            NSArray *urlArray = [self.delegate imagePrefetcher:self urlsForIndexPath:indexPath];
            if (urlArray) {
                [imageURLs addObjectsFromArray:urlArray];
            }
        }
    }
    
    // now prefetch
    //NSLog(@"Image URLs: %@", imageURLs);
    if ([imageURLs count] > 0)
    {
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageURLs];
    }
}

/** Retrieve NSIndexPath for a certain number of rows preceding particular NSIndexPath in the table view.
 *
 * @param  tableView  The tableview for which we're going to retrieve indexPaths.
 * @param  count      The number of rows to retrieve
 * @param  indexPath  The indexPath where we're going to start (presumably the first visible indexPath)
 *
 * @return            An array of indexPaths.
 */

- (NSArray *)tableView:(UITableView *)tableView priorIndexPathCount:(NSInteger)count fromIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    for (NSInteger i = 0; i < count; i++) {
        if (row == 0) {
            if (section == 0) {
                return indexPaths;
            } else {
                section--;
                row = [tableView numberOfRowsInSection:section] - 1;
            }
        } else {
            row--;
        }
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    return indexPaths;
}

/** Retrieve NSIndexPath for a certain number of following particular NSIndexPath in the table view.
 *
 * @param  tableView  The tableview for which we're going to retrieve indexPaths.
 * @param  count      The number of rows to retrieve
 * @param  indexPath  The indexPath where we're going to start (presumably the last visible indexPath)
 *
 * @return            An array of indexPaths.
 */

- (NSArray *)tableView:(UITableView *)tableView nextIndexPathCount:(NSInteger)count fromIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSInteger rowCountForSection = [tableView numberOfRowsInSection:section];
    
    for (NSInteger i = 0; i < count; i++) {
        row++;
        if (row == rowCountForSection) {
            row = 0;
            section++;
            if (section == [tableView numberOfSections]) {
                return indexPaths;
            }
            rowCountForSection = [tableView numberOfRowsInSection:section];
        }
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    return indexPaths;
}

@end
