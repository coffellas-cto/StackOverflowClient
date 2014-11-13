//
//  GDNetworkController.m
//  StackOverflowClient
//
//  Created by Alex G on 11.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDNetworkController.h"
#import "GDCacheController.h"

@interface GDNetworkController ()

@property NSString *token;

@end

@implementation GDNetworkController

#pragma mark - Public Class Methods

+ (void)setToken:(NSString *)token {
    [[self controller] setToken:token];
}

+ (NSURLSessionDataTask *)searchForUsersWithQuery:(NSString *)query completionHandler:(void (^)(NSArray *usersJSONArray, NSString *errorString))completion {
    NSString *params = [[NSString stringWithFormat:@"users?inname=%@", query] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self performRequestWithParams:params completionHandler:completion];
}

+ (NSURLSessionDataTask *)searchForQuestionsWithQuery:(NSString *)query completionHandler:(void (^)(NSArray *questionsJSONArray, NSString *errorString))completion {
    NSString *params = [[NSString stringWithFormat:@"questions?tagged=%@", query] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self performRequestWithParams:params completionHandler:completion];
}

+ (void)loadAvatarWithURL:(NSString *)URL indexPath:(NSIndexPath *)indexPath activityIndicator:(UIActivityIndicatorView *)activityIndicator imageView:(UIImageView *)avatarImageView completion:(void (^)(UIImage *image, NSIndexPath *indexPath))completion {
    UIImage *avatarImage = [GDCacheController objectForKey:URL];
    if (avatarImage) {
        avatarImageView.image = avatarImage;
    }
    else {
        __block UIActivityIndicatorView *activityIndicatorBlock = activityIndicator;
        __block NSIndexPath *indexPathBlock = indexPath;
        __block NSString *URLBlock = URL;
        [activityIndicator startAnimating];
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            UIImage *newAvatar = [UIImage imageWithData:data];
            if (newAvatar)
                [GDCacheController setObject:newAvatar forKey:URLBlock ofLength:[data length]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityIndicatorBlock stopAnimating];
                completion(newAvatar, indexPathBlock);
            });
        }] resume];
    }
}

#pragma mark - Private Class Methods

+ (instancetype)controller {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSURLSessionDataTask *)performRequestWithParams:(NSString *)params completionHandler:(void (^)(id results, NSString *errorString))completion {
    NSString *requestString = @"https://api.stackexchange.com/2.2/";
    requestString = [requestString stringByAppendingString:params];
    requestString = [requestString stringByAppendingString:[NSString stringWithFormat:@"&order=desc&site=stackoverflow&token=%@", [[self controller] token]]];
    
    NSURLSessionDataTask *retVal = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:requestString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *errorString = nil;
        id retVal = nil;
        if (error) {
            errorString = [NSString stringWithFormat:@"Request error: %@", error.localizedDescription];
            if (data) {
                [errorString stringByAppendingFormat:@"\n%@", [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]];
            }
        }
        else {
            NSDictionary *JSONdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error == nil) {
                retVal = JSONdic[@"items"];
                errorString = retVal ? nil : @"No 'items' object in JSON response";
            }
            else {
                errorString = [NSString stringWithFormat:@"Couldn't parse JSON response: %@", error.localizedDescription];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(retVal, errorString);
        });
        
    }];
    [retVal resume];
    
    return retVal;
}

@end
