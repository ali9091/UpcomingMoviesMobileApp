//
//  BaseController.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "BaseController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface BaseController ()

@end

@implementation BaseController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Progress Methods

- (void)showProgress {
    NSLog(@"%@", self.view);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)hideAllProgress {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - Alert Methods

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self showAlertWithTitle:title message:message handler:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)(void))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Error Handling Protocol

- (void)handleFailure:(NSError *)error {
    [self hideProgress];
    [self showAlertWithTitle:kError message:error.localizedDescription];
}

@end
