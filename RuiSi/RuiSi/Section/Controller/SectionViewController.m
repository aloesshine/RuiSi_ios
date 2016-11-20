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
@property (nonatomic,strong) NSArray *forumArray;
@property (nonatomic,strong) NSArray *sectionArray;
@end

@implementation SectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    
    _forumArray = @[@[@"文章天地",@"心灵花园",@"校园交易",@"我是女生",@"版聊专区",@"缘聚睿思",@"失物招领",@"西电问答",@"校园活动",@"我要毕业了",@"就业招聘"],@[@"技术博客",@"学习交流",@"软件技术交流区",@"嵌入式技术交流区",@"考研交流",@"竞赛交流",@"Abroad & English"],@[@"灌水专区",@"摄影天地",@"原创精品区",@"西电后街",@"我爱运动",@"音乐纵贯线",@"绝对漫域",@"游间客栈",@"大话体坛",@"邀请专区"],@[@"腾讯创新俱乐部",@"华为创新俱乐部"],@[@"电影",@"剧集",@"音乐",@"动漫",@"游戏",@"综艺",@"体育",@"软件",@"学习",@"纪录片",@"其他",@"西电",@"求种专区",@"新手试种专区",@"资源回收站"]];
    
    _sectionArray = @[@"西电生活",@"学术交流",@"休闲娱乐",@"社团风采专区",@"BT资源"];
   
    [self.collectionView registerNib:[UINib nibWithNibName:kSectionCollectionViewCell bundle:nil] forCellWithReuseIdentifier:kSectionCollectionViewCell];
    [self.collectionView registerNib:[UINib nibWithNibName:kSectionHeaderViewCell bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderViewCell];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.93 alpha:1];
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)layout;
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flow.headerReferenceSize = CGSizeMake(100, 35);
    flow.minimumLineSpacing = 1.0;
    flow.minimumInteritemSpacing = 1.0;
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    contentInsets.top = 20;
    [self.collectionView setContentInset:contentInsets];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _forumArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *sectionArray = [_forumArray objectAtIndex:section];
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
    collectionCell.titleLable.text = _forumArray[indexPath.section][indexPath.row];
    collectionCell.titleLable.font = [UIFont systemFontOfSize:12];
    collectionCell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0  blue:1.0 alpha:1];
    collectionCell.iconImageView = nil;
    collectionCell.countLable.text = @"0";
    collectionCell.countLable.font = [UIFont systemFontOfSize:15];
    [collectionCell configureImageViewForIndexPath:indexPath];
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
        header.headerTitleLabel.font = [UIFont systemFontOfSize:12];
        header.headerTitleLabel.textColor = [UIColor colorWithRed:0.67 green:0.12 blue:0.13 alpha:1];
        header.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.93 alpha:1];
        return header;
    }
    return nil;
}


@end
