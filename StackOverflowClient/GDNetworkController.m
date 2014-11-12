//
//  GDNetworkController.m
//  StackOverflowClient
//
//  Created by Alex G on 11.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDNetworkController.h"

@interface GDNetworkController ()

@property NSString *token;

@end

@implementation GDNetworkController

#pragma mark - Public Class Methods

+ (void)setToken:(NSString *)token {
    [[self controller] setToken:token];
}

+ (void)searchForUsersWithQuery:(NSString *)query completionHandler:(void (^)(NSArray *usersJSONArray, NSString *errorString))completion {
    NSString *params = [[NSString stringWithFormat:@"&order=desc&inname=%@", query] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self performRequestWithParams:params completionHandler:completion];
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

+ (void)performRequestWithParams:(NSString *)params completionHandler:(void (^)(id results, NSString *errorString))completion {
    NSString *requestString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/users?site=stackoverflow&token=%@", [[self controller] token]];
    if (params) {
        requestString = [requestString stringByAppendingString:params];
    }
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:requestString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
        
    }] resume];
}

@end
