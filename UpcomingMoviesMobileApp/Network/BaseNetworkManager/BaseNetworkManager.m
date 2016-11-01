//
//  BaseNetworkManager.m
//  DictationApp
//
//  Created by Ali Ehsan on 10/10/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "BaseNetworkManager.h"

@implementation BaseNetworkManager

#pragma mark - Safty Methods

- (void)insufficientParametersErrorBlock:(void (^)(NSError *error))errorBlock {
    NSError *error = CREATE_ERROR(kInsufficientParametersErrorMessage);
    errorBlock(error);
}

#pragma mark - Error Handling Protocol

- (void)handleFailure:(NSError *)error {
    NSLog(@"%@: %@", kError, [error localizedDescription]);
}

@end
