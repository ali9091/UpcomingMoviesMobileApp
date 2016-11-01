//
//  BaseController.h
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ErrorHandlingProtocol.h"

@interface BaseController : UIViewController <ErrorHandlingProtocol>

// Progress methods.
- (void)showProgress;
- (void)hideProgress;
- (void)hideAllProgress;

// Alert methods.
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)(void))handler;

@end
