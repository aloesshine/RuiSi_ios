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

@interface SectionViewController() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *countArray;

@end

@implementation SectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = RSMainColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"板块";
    
    [self setupArray];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    // 这三行代码可以解决ScrollView被Tab Bar遮挡的问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flow.headerReferenceSize = CGSizeMake(100, 35);
        flow.minimumLineSpacing = 1.0;
        flow.minimumInteritemSpacing = 1.0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
        _collectionView.backgroundColor = RSRGBColor(0.91,0.93,0.93,1);
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SectionCollectionViewCell class] forCellWithReuseIdentifier:kSectionCollectionViewCell];
        [_collectionView registerClass:[SectionHeaderViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderViewCell];
    }
    return _collectionView;
}

- (void)setupArray
{
    if ([DataManager isUserLogined]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sectionLogging" ofType:@"plist"];
        self.itemArray = [NSArray arrayWithContentsOfFile:path];
        self.sectionArray = @[@"西电生活",@"学术交流",@"休闲娱乐",@"社团风采专区",@"BT资源",@"站务管理"];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sectionNotLogging" ofType:@"plist"];
        self.itemArray = [NSArray arrayWithContentsOfFile:path];
        self.sectionArray = @[@"西电生活",@"学术交流",@"休闲娱乐",@"社团风采专区",@"站务管理"];
    
        NSMutableArray *countMutableArray = [[NSMutableArray alloc] init];
        NSString *urlString = [kPublicNetURL stringByAppendingString:@"/forum.php?forumlist=1&mobile=2"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSError *error = nil;
        NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"Error is %@",error);
            return;
        }
        HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
        if (error) {
            NSLog(@"Error is %@",error);
        }
        HTMLNode *bodyNode = [parser body];
        NSArray *divNodes = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"sub_forum bm_c" allowPartial:NO];
        
        for(HTMLNode *divNode in divNodes) {
            NSArray *listNodes = [divNode findChildTags:@"li"];
            NSMutableArray *numMutableArray = [[NSMutableArray alloc] init];
            for (HTMLNode *listNode in listNodes) {
                if ( [listNode findChildTag:@"span"] == NULL) {
                    [numMutableArray addObject:@"0"];
                } else {
                    HTMLNode *node = [listNode findChildTag:@"span"];
                    if ([[node getAttributeNamed:@"class"] isEqualToString:@"num"])
                    {
                        [numMutableArray addObject:[node contents]];
                    }
                }
            }
            [countMutableArray addObject:numMutableArray];
        }
        self.countArray = [countMutableArray copy];
    }
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.itemArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray *)[self.itemArray objectAtIndex:section]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSectionCollectionViewCell forIndexPath:indexPath];
    NSDictionary *dict = self.itemArray[indexPath.section][indexPath.row];
    [cell configWithTitle:dict[@"name"] image:[UIImage imageNamed:(NSString *)[dict valueForKey:@"image"]]];
    return cell;
}

- (CGSize)collectionView :(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat width = (self.collectionView.frame.size.width - 3) /4.0;
    CGSize size = CGSizeMake(width, width);
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        SectionHeaderViewCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionHeaderViewCell forIndexPath:indexPath];
        [header configWithTitle:_sectionArray[indexPath.section]];
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
