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
    _forumArray = @[@[@"文章天地",@"心灵花园",@"校园交易",@"我是女生",@"西电版聊专区",@"缘聚睿思",@"失物招领",@"西电问答",@"校园活动",@"我要毕业了",@"就业招聘"],@[@"技术博客",@"学习交流",@"软件技术交流区",@"嵌入式技术交流区",@"考研交流",@"竞赛交流",@"Abroad & English"],@[@"西电睿思灌水专区",@"摄影天地",@"原创精品区",@"西电后街",@"我爱运动",@"音乐纵贯线",@"绝对漫域",@"游间客栈",@"大话体坛",@"邀请专区"],@[@"腾讯创新俱乐部",@"华为创新俱乐部"],@[@"电影",@"剧集",@"音乐",@"动漫",@"游戏",@"综艺",@"体育",@"软件",@"学习",@"纪录片",@"其他",@"西电",@"求种专区",@"新手试种专区",@"资源回收站"]];
    
    _sectionArray = @[@"西电生活",@"学术交流",@"休闲娱乐",@"社团风采专区",@"BT资源"];
   
    [self.collectionView registerNib:[UINib nibWithNibName:@"SectionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kSectionCollectionViewCell];
    [self.collectionView registerClass:[SectionHeaderViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderViewCell];
    
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)layout;
    flow.sectionInset = UIEdgeInsetsMake(10, 20, 30, 20);
    flow.headerReferenceSize = CGSizeMake(100, 25);
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
    collectionCell.iconImageView = nil;
    collectionCell.countLable.text = @"0";
}

- (CGSize) collectionView :(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    int width = self.collectionView.frame.size.width/4;
    CGSize size = CGSizeMake(width, width);
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        SectionHeaderViewCell *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionHeaderViewCell forIndexPath:indexPath];
        header.headerTitleLabel.text = [_sectionArray objectAtIndex:indexPath.section];
        return header;
    }
    return nil;
}


@end
