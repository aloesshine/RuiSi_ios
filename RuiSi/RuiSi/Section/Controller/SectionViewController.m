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
#import "ThreadListViewController.h"

NSString *kSectionCollectionViewCell = @"SectionCollectionViewCell";
NSString *kSectionHeaderViewCell = @"SectionHeaderViewCell";
NSString *kshowThreadListSegue = @"showThreadList";

@interface SectionViewController()
@property (nonatomic,strong) NSArray *itemArray;
@property (nonatomic,strong) NSArray *sectionArray;
@property (nonatomic,strong) NSArray *countArray;
@property (nonatomic,assign) BOOL isLogin;
@end

@implementation SectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.13 blue:0.16 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"手机睿思";
    self.isLogin = [userDefaults objectForKey:kUserIsLogin];
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
    
    if ([DataManager isUserLogined])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sectionLogging" ofType:@"plist"];
        _itemArray = [NSArray arrayWithContentsOfFile:path];
        _sectionArray = @[@"西电生活",@"学术交流",@"休闲娱乐",@"社团风采专区",@"BT资源",@"站务管理"];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sectionNotLogging" ofType:@"plist"];
        _itemArray = [NSArray arrayWithContentsOfFile:path];
        _sectionArray = @[@"西电生活",@"学术交流",@"休闲娱乐",@"社团风采专区",@"站务管理"];
        
        
        NSMutableArray *countMutableArray = [[NSMutableArray alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://bbs.rs.xidian.me/forum.php?forumlist=1&mobile=2"];
        NSError *error = nil;
        NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        
        if (error)
        {
            NSLog(@"Error is %@",error);
            return;
        }
        HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
        if (error)
        {
            NSLog(@"Error is %@",error);
        }
        HTMLNode *bodyNode = [parser body];
        NSArray *divNodes = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"sub_forum bm_c" allowPartial:NO];
        
        for(HTMLNode *divNode in divNodes)
        {
            NSArray *listNodes = [divNode findChildTags:@"li"];
            NSMutableArray *numMutableArray = [[NSMutableArray alloc] init];
            for (HTMLNode *listNode in listNodes)
            {
                if ( [listNode findChildTag:@"span"] == NULL)
                {
                    [numMutableArray addObject:@"0"];
                }
                else
                {
                    HTMLNode *node = [listNode findChildTag:@"span"];
                    if ([[node getAttributeNamed:@"class"] isEqualToString:@"num"])
                    {
                        [numMutableArray addObject:[node contents]];
                    }
                }
            }
            [countMutableArray addObject:numMutableArray];
        }
        
        _countArray = [NSArray arrayWithArray:countMutableArray];
    }
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
    SectionCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kSectionCollectionViewCell forIndexPath:indexPath];
    [self configureCell:cell forItemAtIndexPath:indexPath];
    return cell;
}


- (void) configureCell:(SectionCollectionViewCell *)collectionCell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *titleDict = _itemArray[indexPath.section][indexPath.row];
    collectionCell.titleLabel.text = titleDict[@"name"];
    collectionCell.countLabel.text = _countArray[indexPath.section][indexPath.row];
    
    
    [collectionCell setUpIconImageAtIndexPath:indexPath];
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

// 点击某个cell时
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *titleDict = _itemArray[indexPath.section][indexPath.row];
    
    ThreadListViewController *destViewController = [[ThreadListViewController alloc] init];
    destViewController.hidesBottomBarWhenPushed = YES;
    destViewController.url = titleDict[@"url"];
    destViewController.name = titleDict[@"name"];
    destViewController.fid = titleDict[@"fid"];
    destViewController.needToGetMore = YES;
    __weak ThreadListViewController *wdestViewController = destViewController;
    destViewController.getThreadListBlock = ^(NSInteger page){
        return [[DataManager manager] getThreadListWithFid:wdestViewController.fid page:page success:^(ThreadList *threadList) {
            wdestViewController.threadList = threadList;
            [wdestViewController.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
    destViewController.getMoreListBlock = ^(NSInteger page) {
        return [[DataManager manager] getThreadListWithFid:wdestViewController.fid page:page success:^(ThreadList *threadList) {
            NSMutableArray *threadLists = [[NSMutableArray alloc] initWithArray:wdestViewController.threadList.list];
            [threadLists addObjectsFromArray:threadList.list];
            wdestViewController.threadList.list = [threadLists copy];
            [wdestViewController.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
    [self.navigationController pushViewController:destViewController animated:YES];
}


@end
