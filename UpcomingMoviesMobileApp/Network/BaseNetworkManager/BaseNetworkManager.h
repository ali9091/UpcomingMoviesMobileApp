//
//  BaseNetworkManager.h
//  DictationApp
//
//  Created by Ali Ehsan on 10/10/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ErrorHandlingProtocol.h"

@interface BaseNetworkManager : AFHTTPRequestOperationManager <ErrorHandlingProtocol>

// Safty methods.
- (void)insufficientParametersErrorBlock:(void (^)(NSError *error))errorBlock;

@end
