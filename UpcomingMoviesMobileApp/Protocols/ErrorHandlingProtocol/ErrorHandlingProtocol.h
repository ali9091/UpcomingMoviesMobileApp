//
//  ErrorHandlingProtocol.h
//  DictationApp
//
//  Created by Ali Ehsan on 10/10/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ErrorHandlingProtocol <NSObject>

- (void)handleFailure:(NSError *)error;

@end
