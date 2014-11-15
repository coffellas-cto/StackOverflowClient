//
//  GDUser.m
//  StackOverflowClient
//
//  Created by Alex G on 10.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDUser.h"
#import "NSString+HTML.h"

@implementation GDUser {
    NSTimeInterval _regDateTime;
}

#pragma mark - Getters

- (NSString *)regDate {
    return @"<unknown>";
}

#pragma mark - Public Methods

+ (GDUser *)userWithJSONDictionary:(NSDictionary *)dic {
    if (![dic isKindOfClass:[NSDictionary class]])
        return nil;
    
    GDUser *newUser = [[GDUser alloc] initWithUserID:dic[@"user_id"]];
    if (newUser) {
        newUser->_name = [dic[@"display_name"] kv_decodeHTMLCharacterEntities];
        newUser->_reputation = [dic[@"reputation"] unsignedIntegerValue];
        newUser->_profileImageURL = dic[@"profile_image"];
        newUser->_websiteURL = dic[@"website_url"];
        newUser->_userType = NSLocalizedString([dic[@"user_type"] capitalizedString], nil);
        newUser->_stackOverflowURL = dic[@"link"];
        newUser->_regDateTime = [dic[@"creation_date"] doubleValue];
    }
    return newUser;
}

+ (NSArray *)usersWithJSONArray:(NSArray *)JSONArray {
    NSMutableArray *retVal = [NSMutableArray array];
    for (NSDictionary *userDic in JSONArray) {
        id newUser = [self userWithJSONDictionary:userDic];
        if (newUser)
            [retVal addObject:newUser];
    }
    return retVal;
}

- (instancetype)initWithUserID:(NSNumber *)userID
{
    if (userID) {
        self = [super init];
        if (self) {
            _userID = [userID unsignedIntegerValue];
        }
        return self;
    }
    
    return nil;
}

@end
