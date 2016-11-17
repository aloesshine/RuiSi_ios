//
//  SectionViewController.m
//  RuiSi
//
//  Created by aloes on 2016/11/17.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "SectionViewController.h"
#import "SectionCollectionViewCell.h"

@interface SectionViewController() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{

    UICollectionView *mainCollectionView;
}

@end

@implementation SectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //2.初始化collectionView
    mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:mainCollectionView];
    
    //3.注册collectionViewCell
    [mainCollectionView registerClass:[SectionCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    //4.设置代理
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 通过重用标识符获取cell
    SectionCollectionViewCell *cell = (SectionCollectionViewCell *)[mainCollectionView dequeueReusableCellWithReuseIdentifier: @"cell" forIndexPath: indexPath];
    
  
    
    return cell;
}

@end
