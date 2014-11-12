//
//  GDQuestion.h
//  StackOverflowClient
//
//  Created by Alex G on 12.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDUser.h"

@interface GDQuestion : NSObject

@property (readonly, nonatomic) GDUser *owner;
@property (readonly, nonatomic) NSArray *tags;
@property (readonly, nonatomic) BOOL answered;
@property (readonly, nonatomic) NSUInteger viewCount;
@property (readonly, nonatomic) NSUInteger answerCount;
@property (readonly, nonatomic) NSString *link;
@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) NSUInteger questionID;

+ (GDQuestion *)questionWithJSONDictionary:(NSDictionary *)JSONdictionary;
+ (NSArray *)questionsWithJSONArray:(NSArray *)JSONArray;

@end
