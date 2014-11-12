//
//  GDQuestion.m
//  StackOverflowClient
//
//  Created by Alex G on 12.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDQuestion.h"

@implementation GDQuestion

+ (GDQuestion *)questionWithJSONDictionary:(NSDictionary *)dic {
    if (![dic isKindOfClass:[NSDictionary class]])
        return nil;
    
    GDQuestion *q = [[GDQuestion alloc] initWithID:dic[@"question_id"]];
    if (q) {
        q->_owner = [GDUser userWithJSONDictionary:dic[@"owner"]];
        q->_tags = dic[@"tags"];
        q->_answered = [dic[@"is_answered"] boolValue];
        q->_answerCount = [dic[@"answer_count"] unsignedIntegerValue];
        q->_link = dic[@"link"];
        q->_title = dic[@"title"];
        q->_viewCount = [dic[@"view_count"] unsignedIntegerValue];
    }
    return q;
}

+ (NSArray *)questionsWithJSONArray:(NSArray *)JSONArray {
    if (![JSONArray isKindOfClass:[NSArray class]])
        return nil;
    
    NSMutableArray *retVal = [NSMutableArray array];
    for (id obj in retVal) {
        id newQuestion = [self questionWithJSONDictionary:obj];
        if (newQuestion)
            [retVal addObject:newQuestion];
    }
    return retVal;
}

- (instancetype)initWithID:(NSNumber *)questionID
{
    if (!questionID)
        return nil;
    
    self = [super init];
    if (self) {
        _questionID = [questionID unsignedIntegerValue];
    }
    return self;
}

@end
