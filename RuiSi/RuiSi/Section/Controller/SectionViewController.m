//
//  SectionViewController.m
//  RuiSi
//
//  Created by aloes on 2016/11/17.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "SectionViewController.h"
#import "SectionCollectionViewCell.h"
#import "SectionHeaderViewCell.h"
NSString *kSectionCollectionViewCell = @"SectionCollectionViewCell";
NSString *kSectionHeaderViewCell = @"SectionHeaderViewCell";

@interface SectionViewController()
@property (nonatomic,strong) NSArray *itemArray;
@property (nonatomic,strong) NSArray *sectionArray;
- (void) setupArray;
@end

@implementation SectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupArray];

   
    [self.collectionView registerNib:[UINib nibWithNibName:kSectionCollectionViewCell bundle:nil] forCellWithReuseIdentifier:kSectionCollectionViewCell];
    [self.collectionView registerNib:[UINib nibWithNibName:kSectionHeaderViewCell bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderViewCell];
    
    // 这三行代码可以解决ScrollView被Tab Bar遮挡的问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.93 alpha:1];
    
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)layout;
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flow.headerReferenceSize = CGSizeMake(100, 35);
    flow.minimumLineSpacing = 1.0;
    flow.minimumInteritemSpacing = 1.0;
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
}


- (void)setupArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"section" ofType:@"plist"];
    _itemArray = [NSArray arrayWithContentsOfFile:path];
    _sectionArray = @[@"西电生活",@"学术交流",@"休闲娱乐",@"社团风采专区",@"BT资源"];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _itemArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *sectionArray = [_itemArray objectAtIndex:section];
    return sectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 通过重用标识符获取cell
    SectionCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kSectionCollectionViewCell forIndexPath:indexPath];
    [self configureCell:cell forItemAtIndexPath:indexPath];
    return cell;
}


- (void) configureCell:(SectionCollectionViewCell *)collectionCell forItemAtIndexPath:(NSIndexPath *)indexPath {
    collectionCell.titleLable.text = _itemArray[indexPath.section][indexPath.row];

    collectionCell.countLable.text = @"0";
    
    [collectionCell configureImageViewForIndexPath:indexPath];
    [collectionCell setUpFont];
}

- (CGSize) collectionView :(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = (self.collectionView.frame.size.width - 3) /4.0;
    CGSize size = CGSizeMake(width, width);
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        SectionHeaderViewCell *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionHeaderViewCell forIndexPath:indexPath];
        header.headerTitleLabel.text = _sectionArray[indexPath.section];
        [header setUpFontAndBackground];
        return header;
    }
    return nil;
}


@end
