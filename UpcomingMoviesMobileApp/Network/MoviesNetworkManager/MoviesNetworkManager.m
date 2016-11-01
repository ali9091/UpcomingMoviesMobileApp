//
//  MoviesNetworkManager.m
//  UpcomingMoviesMobileApp
//
//  Created by Ali Ehsan on 10/27/16.
//  Copyright © 2016 TkXel. All rights reserved.
//

#import "MoviesNetworkManager.h"

static NSString * const kBaseURL = @"http://api.themoviedb.org/3/";
static NSString * const kResponseErrorKey = @"com.alamofire.serialization.response.error.response";
static NSString * const kDataErrorKey = @"com.alamofire.serialization.response.error.data";

@implementation MoviesNetworkManager

#pragma mark - Initialization Methods

+ (MoviesNetworkManager *)sharedManager {
    static MoviesNetworkManager *networkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[MoviesNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    return networkManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

#pragma mark - AFNetworking Methods

- (AFHTTPRequestOperation *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation * _Nonnull, id _Nonnull))success failure:(void (^)(AFHTTPRequestOperation * _Nullable, NSError * _Nonnull))failure {
    
    return [super GET:URLString parameters:parameters success:success failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSError *serverError = [MoviesNetworkManager getServerErrorFromError:error];
        failure(operation, serverError);
    }];
}

#pragma mark - Error Methods

+ (NSError *)getServerErrorFromError:(NSError *)error {
    
    // Get the status code.
    NSInteger serverErrorCode = error.code;
    NSHTTPURLResponse *responseError = error.userInfo[kResponseErrorKey];
    if (responseError) {
        serverErrorCode = responseError.statusCode;
    }
    
    // Get the server error message.
    NSString *serverErrorMessage = error.localizedDescription;
    NSError *parseError = nil;
    NSDictionary *errorDictionary = [NSJSONSerialization JSONObjectWithData:error.userInfo[kDataErrorKey] options:0 error:&parseError];
    if (!parseError) {
        NSArray *allErrors = errorDictionary[@"errors"];
        serverErrorMessage = [allErrors componentsJoinedByString:@"\n"];
    }
    return CREATE_ERROR_WITH_CODE(serverErrorCode, serverErrorMessage);
}

#pragma mark - API Methods

- (void)getUpcomingMoviesWithPage:(NSInteger)page success:(void(^)(NSDictionary *json))successBlock error:(void(^)(NSError *error))errorBlock {
    
    NSString *URLString = @"movie/upcoming";
    
    NSDictionary *parameters = @{
                                 @"api_key": kAPIKey,
                                 @"page": @(page)
                                 };
    
    [self GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self handleFailure:error];
        errorBlock(error);
    }];
}

- (void)getAllGenresWithSuccess:(void(^)(NSDictionary *json))successBlock error:(void(^)(NSError *error))errorBlock {
    
    NSString *URLString = @"genre/movie/list";
    NSDictionary *parameters = @{
                                 @"api_key": kAPIKey
                                 };
    
    [self GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self handleFailure:error];
        errorBlock(error);
    }];
}


- (void)getSearchMoviesWithQuery:(NSString *)query page:(NSInteger)page success:(void(^)(NSDictionary *json))successBlock error:(void(^)(NSError *error))errorBlock {
    
    if (!query) {
        [self insufficientParametersErrorBlock:errorBlock];
        return;
    }
    
    NSString *URLString = @"search/movie";
    NSDictionary *parameters = @{
                                 @"api_key": kAPIKey,
                                 @"query": query,
                                 @"page": @(page)
                                 };
    
    [self GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self handleFailure:error];
        errorBlock(error);
    }];
}


@end
