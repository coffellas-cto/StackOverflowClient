//
//  GDTagsCell.m
//  StackOverflowClient
//
//  Created by Alex G on 13.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDTagsCell.h"
#import "GDTagCell.h"

@interface GDTagsCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation GDTagsCell {
    __weak IBOutlet UICollectionView *collection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GDTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAG_CELL" forIndexPath:indexPath];
    cell.titleLabel.text = _tagsArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_tagsArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"GDTagCell" bundle:nil];
    [collection registerNib:nib forCellWithReuseIdentifier:@"TAG_CELL"];
    GDTagCell *sizingCell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    sizingCell.titleLabel.text = _tagsArray[indexPath.row];
    return [sizingCell intrinsicContentSize];
}

#pragma mark - Life Cycle

- (void)awakeFromNib {
    // Initialization code
    _tagsArray = [NSMutableArray array];
    UINib *nib = [UINib nibWithNibName:@"GDTagCell" bundle:nil];
    [collection registerNib:nib forCellWithReuseIdentifier:@"TAG_CELL"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
