//
//  GDQuestionsViewController.m
//  StackOverflowClient
//
//  Created by Alex G on 12.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDQuestionsViewController.h"
#import "GDQuestion.h"
#import "GDNetworkController.h"

@interface GDQuestionsViewController () {
    NSMutableArray *questionsArray;
    NSURLSessionDataTask *curDataTask;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GDQuestionsViewController

#pragma mark - Private Methods
- (void)cancelCurTask {
    if ([curDataTask state] != NSURLSessionTaskStateCompleted) {
        [curDataTask cancel];
    }
}

#pragma mark - UITableView Delegates Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL" forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [questionsArray count];
}

#pragma mark - UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSLog(@"%@", searchBar.text);
    
    NSString *searchText = searchBar.text;
    if ([searchText isEqualToString:@""] || (searchText == nil)) {
        return;
    }
    
    [self cancelCurTask];
    curDataTask = [GDNetworkController searchForQuestionsWithQuery:searchText completionHandler:^(NSArray *questionsJSONArray, NSString *errorString) {
        NSArray *newQuestionsArray = [GDQuestion questionsWithJSONArray:questionsJSONArray];
        questionsArray = [NSMutableArray arrayWithArray:newQuestionsArray];
        [_tableView reloadData];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView.estimatedRowHeight = 420;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    questionsArray = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
