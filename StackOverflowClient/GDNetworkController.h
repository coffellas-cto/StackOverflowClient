//
//  GDNetworkController.h
//  StackOverflowClient
//
//  Created by Alex G on 11.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDNetworkController : NSObject

+ (void)setToken:(NSString *)token;
+ (NSURLSessionDataTask *)searchForUsersWithQuery:(NSString *)query andOffset:(NSUInteger)offset completionHandler:(void (^)(NSArray *usersJSONArray, NSString *errorString, BOOL hasMore))completion;
+ (NSURLSessionDataTask *)searchForQuestionsWithQuery:(NSString *)query andOffset:(NSUInteger)offset  completionHandler:(void (^)(NSArray *questionsJSONArray, NSString *errorString, BOOL hasMore))completion;
+ (void)loadAvatarWithURL:(NSString *)URL indexPath:(NSIndexPath *)indexPath activityIndicator:(UIActivityIndicatorView *)activityIndicator imageView:(UIImageView *)avatarImageView completion:(void (^)(UIImage *image, NSIndexPath *indexPath))completion;

@end
