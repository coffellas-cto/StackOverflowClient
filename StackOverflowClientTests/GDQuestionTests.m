//
//  GDQuestionTests.m
//  StackOverflowClient
//
//  Created by Alex G on 12.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GDQuestion.h"

@interface GDQuestionTests : XCTestCase

@end

@implementation GDQuestionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQuestionJSONParsing {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"questions" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(jsonData, @"Can't read JSON file");
    
    NSError *error;
    NSDictionary *JSONdic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    XCTAssertNotNil(JSONdic, @"Can't convert JSON data into object");
    XCTAssertTrue([JSONdic isKindOfClass:[NSDictionary class]], @"JSON object is not a dictionary");

    NSArray *JSONArray = JSONdic[@"items"];
    XCTAssertNotNil(JSONArray, @"No 'items' in JSON dictionary");
    XCTAssertTrue([JSONArray isKindOfClass:[NSArray class]], @"JSON object is not an array");
    
    NSArray *questionsArray = [GDQuestion questionsWithJSONArray:JSONArray];
    XCTAssertNotNil(questionsArray, @"Questions array is nil");
    XCTAssertTrue([questionsArray isKindOfClass:[NSArray class]], @"Questions object is not an array");
    XCTAssertEqual([questionsArray count], 1, @"Questions array count isn't 1");
    
    GDQuestion *question = questionsArray[0];
    XCTAssertTrue([question isKindOfClass:[GDQuestion class]], @"Question object is not of GDQuestion class");
    
    XCTAssertTrue([question.title isEqualToString:@"Phonegap, onscreen keyboard on iOS is shifting my content"], @"Title is wrong");
    XCTAssertTrue([question.link isEqualToString:@"http://stackoverflow.com/questions/26898655/phonegap-onscreen-keyboard-on-ios-is-shifting-my-content"], @"Link is wrong");
    XCTAssertEqual(question.answerCount, 1, @"Wrong answers count");
    XCTAssertEqual(question.viewCount, 5, @"Wrong views count");
    XCTAssertEqual(question.questionID, 26898655, @"Wrong id");
    XCTAssertTrue(question.answered, @"Wrong answered field");
    XCTAssertTrue([question.tags isKindOfClass:[NSArray class]], @"'tags' is not an array");
    XCTAssertEqual([question.tags count], 3, @"Wrong tags count");
    for (NSUInteger i = 0; i < [question.tags count]; i++) {
        NSString *tag = question.tags[i];
        XCTAssertTrue([tag isKindOfClass:[NSString class]], @"tag is not a string");
        switch (i) {
            case 0:
                XCTAssertTrue([tag isEqualToString:@"ios"]);
                break;
            case 1:
                XCTAssertTrue([tag isEqualToString:@"css"]);
                break;
            case 2:
                XCTAssertTrue([tag isEqualToString:@"cordova"]);
                break;
                
            default:
                break;
        }
    }
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
