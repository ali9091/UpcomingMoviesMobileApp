//
//  ImagePrefetcher.h
//  Nin60
//
//  Created by Ali Ehsan on 7/31/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImagePrefetcher;

@protocol ImagePrefetcherDelegate <NSObject>

- (NSArray *)imagePrefetcher:(ImagePrefetcher *)imagePrefetcher urlsForIndexPath:(NSIndexPath *)indexPath;

@end

@interface ImagePrefetcher : NSObject

@property (nonatomic) NSInteger prefetchCount;
@property (weak, nonatomic) id <ImagePrefetcherDelegate> delegate;

- (instancetype)initWithPrefetchCount:(NSInteger)prefetchCount;
- (void)prefetchImagesForTableView:(UITableView *)tableView;

@end
