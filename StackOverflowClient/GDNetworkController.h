//
//  GDNetworkController.h
//  StackOverflowClient
//
//  Created by Alex G on 11.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDNetworkController : NSObject

+ (void)setToken:(NSString *)token;
+ (NSURLSessionDataTask *)searchForUsersWithQuery:(NSString *)query completionHandler:(void (^)(NSArray *usersJSONArray, NSString *errorString))completion;
+ (NSURLSessionDataTask *)searchForQuestionsWithQuery:(NSString *)query completionHandler:(void (^)(NSArray *questionsJSONArray, NSString *errorString))completion;

@end
