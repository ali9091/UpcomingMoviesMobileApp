//
//  Constants.h
//  DictationApp
//
//  Created by Ali Ehsan on 10/10/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#import <UIKit/UIKit.h>

/* TMDb */
static NSString *const kAPIKey = @"1f54bd990f1cdfb230adb312546d765d";

/* Application */
#define APP_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

/* Interaction */
#define ENABLE_INTERACTION(interactiveView,enabled) interactiveView.userInteractionEnabled = enabled

/* Network */
#define IS_NETWORK_AVALIABLE ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
#define SHOW_NETWORK_INDICATOR [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HIDE_NETWORK_INDICATOR [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

/* Screen */
#define SCREEN_WIDTH (NSInteger)[[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT (NSInteger)[[UIScreen mainScreen] bounds].size.height
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/* Storyboard */
static NSString *const kMainStoryBoard = @"Main";
#define GET_CONTROLLER_WITH_CLASS(controllerClass) [[UIStoryboard storyboardWithName:kMainStoryBoard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(controllerClass)];

/* Error constants. */
#define CREATE_ERROR(errorString) [NSError errorWithDomain:kDefaultErrorDomain code:kDefaultErrorCode userInfo:[NSMutableDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey]]
#define CREATE_ERROR_WITH_CODE(errorCode,errorString) [NSError errorWithDomain:kDefaultErrorDomain code:errorCode userInfo:[NSMutableDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey]]
#define CLASS_STRING(myClass) NSStringFromClass([myClass class])
static NSString *const kDefaultErrorDomain = @"UpcomingMoviesMobileApp";
static NSInteger const kDefaultErrorCode = 444;

/* Property */
#define PROP_STRING(prop) NSStringFromSelector(@selector(prop))

/* Core Data */
#define DEFAULT_CONTEXT [NSManagedObjectContext MR_defaultContext]

/* Auto Layout */
#define ANIMATE_LAYOUT [UIView animateWithDuration:0.25 animations:^{[self.view layoutIfNeeded];}];

/* Color */
#define GET_COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define CLEAR_COLOR [UIColor clearColor]
#define BLACK_COLOR GET_COLOR(0,0,0)
#define DARK_GRAY_COLOR GET_COLOR(45,45,45)
#define WHITE_COLOR GET_COLOR(255,255,255)

/* Error */
static NSString *const kError = @"Error";
static NSString *const kInsufficientParametersErrorMessage = @"Can not call API. Insufficient parameters.";
static NSString *const kNoInternetConnectionErrorMessage = @"The internet connection appears to be offline.";
static NSString *const kSearchQueryLengthErrorMessage = @"Please enter 3 characters for searching.";


/* Other constants. */
static NSString *const kOK = @"OK";
static NSString *const kYes = @"Yes";
static NSString *const kNo = @"No";
static NSString *const kPlist = @"plist";

/* Image */
static NSInteger const kPrefetchRowCount = 5;
static NSString *const kPlaceholderPosterPathImage = @"placeholder.png";
static NSString *const kPlaceholderBackdropPathImage = @"placeholder-detail.png";
static NSString *const kSearch = @"Search";

/* Date */
static NSString *const kDayMonthYearDateFormat = @"dd MMM yyyy";

/* URLs */
static NSString * const kImageBaseURL = @"https://image.tmdb.org/t/p/w500";

#endif /* Constants_h */
