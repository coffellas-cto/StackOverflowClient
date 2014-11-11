//
//  GDUser.h
//  StackOverflowClient
//
//  Created by Alex G on 10.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDUser : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *profileImageURL;
@property (nonatomic, readonly) NSString *websiteURL;
@property (nonatomic, readonly) NSString *stackOverflowURL;
@property (nonatomic, readonly) NSUInteger userID;
@property (nonatomic, readonly) NSUInteger reputation;
@property (nonatomic, readonly) NSString *userType;

+ (GDUser *)userWithJSONDictionary:(NSDictionary *)JSONdictionary;
+ (NSArray *)usersWithJSONArray:(NSArray *)JSONArray;

@end
