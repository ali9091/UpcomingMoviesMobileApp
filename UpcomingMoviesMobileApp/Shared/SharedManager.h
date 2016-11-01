//
//  SharedManager.h
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class is used as a singleton to store data temporarily and is accessible in classes 
@interface SharedManager : NSObject

// Properties.
@property (strong, nonatomic) NSManagedObjectContext *searchContext;
@property (nonatomic) NSInteger searchMaxPageCount;
@property (nonatomic) NSInteger upcomingMaxPageCount;

// Initialization methods.
+ (SharedManager *)sharedManager;

@end
