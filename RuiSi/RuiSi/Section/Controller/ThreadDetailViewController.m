//
//  ThreadDetailViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/2.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetailViewController.h"
#import "ThreadDetail.h"
#import "ThreadDetailTitleCell.h"
#import "Thread.h"
#import "ThreadDetailInfoCell.h"
#import "ThreadDetailDTCell.h"
#import "ThreadDetailDTCell.h"
#import "DTTextAttachment.h"
#import "ProfileViewController.h"
static NSString *kThreadDetailDTCell = @"ThreadDetailDTCell";
static NSString *kThreadDetailTitleCell = @"ThreadDetailTitleCell";
@interface ThreadDetailViewController ()
@property (nonatomic,strong) ThreadDetailList *detailList;
@property (nonatomic,copy) NSURLSessionDataTask* (^getThreadDetailListBlock)(NSInteger page);
@property (nonatomic,copy) NSURLSessionDataTask* (^getMoreThreadDetailBlock)(NSInteger page);
@property (nonatomic,copy) NSURLSessionDataTask* (^getLinksBlock)();
@property (nonatomic,copy) NSURLSessionDataTask* (^getCreatorOnlyDetailListBlock)(NSInteger page);
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) UIBarButtonItem *favorButtonItem;
@property (nonatomic,strong) NSDictionary *linksDict;
@property (nonatomic,strong) NSCache *cellCache;
@end

@implementation ThreadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[ThreadDetailTitleCell class] forCellReuseIdentifier:kThreadDetailTitleCell];
    [self.tableView registerClass:[ThreadDetailDTCell class] forCellReuseIdentifier:kThreadDetailDTCell];
    self.currentPage = 1;
    [self configureRefresh];
    [self configueBlocks];
    self.getThreadDetailListBlock(1);
    self.getLinksBlock();
    [self initializeUI];
}

- (void) initializeUI {
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *favorButton = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(favor)];
    UIBarButtonItem *creatorOnlyButton = [[UIBarButtonItem alloc] initWithTitle:@"只看楼主" style:UIBarButtonItemStylePlain target:self action:@selector(lookOnly)];
    self.navigationItem.rightBarButtonItems = @[favorButton,creatorOnlyButton];
}

- (void) favor {
    NSLog(@"%@",[self.linksDict objectForKey:@"favorite"]);
}

- (void) lookOnly {
    NSLog(@"%@",[self.linksDict objectForKey:@"creatorOnly"]);
    self.getCreatorOnlyDetailListBlock(1);
}


- (void) configureRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.getThreadDetailListBlock(self.currentPage);
        if (self.detailList) {
            [self.tableView.mj_header endRefreshing];
        }
    } ];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage = self.currentPage+1;
        self.getMoreThreadDetailBlock(self.currentPage);
        if (self.detailList) {
            [self.tableView.mj_footer endRefreshing];
        }
    } ];
}
- (void) configueBlocks {
    @weakify(self);
    self.getThreadDetailListBlock = ^(NSInteger page){
        
        @strongify(self);
        self.currentPage = page;
        return [[DataManager manager] getThreadDetailListWithTid:self.tid page:page success:^(ThreadDetailList *threadDetailList) {
            self.detailList = threadDetailList;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
    
    
    self.getMoreThreadDetailBlock = ^(NSInteger page){
        @strongify(self);
        self.currentPage = page;
        return [[DataManager manager] getThreadDetailListWithTid:self.tid page:self.currentPage success:^(ThreadDetailList *threadDetailList) {
            NSMutableArray *detailLists = [[NSMutableArray alloc] initWithArray:self.detailList.list];
            [detailLists addObjectsFromArray:threadDetailList.list];
            self.detailList.list = [NSArray arrayWithArray:detailLists];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
    
    self.getLinksBlock = ^(){
        @strongify(self);
        return [[DataManager manager] getLinkDictionaryWithTid:self.tid page:1 success:^(NSDictionary *links) {
            self.linksDict = links;
        } failure:^(NSError *error) {
            ;
        }];
    };
    
    self.getCreatorOnlyDetailListBlock = ^(NSInteger page) {
        @strongify(self);
        ThreadDetail *detail = [self.detailList.list objectAtIndex:0];
        NSString *uid = detail.threadCreator.memberUid;
        self.currentPage = page;
        return [[DataManager manager] getCreatorOnlyThreadDetailListWithTid:self.thread.tid page:self.currentPage authorid:uid success:^(ThreadDetailList *threadDetailList) {
            self.detailList = threadDetailList;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else {
        return self.detailList.countOfList;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *titleCellIdentifier = @"titleCellIdentifier";
    ThreadDetailTitleCell *titleCell = (ThreadDetailTitleCell *)[tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
    if (!titleCell) {
        titleCell = [[ThreadDetailTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier];
        titleCell.navi = self.navigationController;
    }
    
    
    if (indexPath.section == 0) {
            return [self configureTitleCell:titleCell atIndexPath:indexPath];
    }
    
    if (indexPath.section == 1) {
        ThreadDetailDTCell *cell = (ThreadDetailDTCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - Configure TableViewCell
- (ThreadDetailTitleCell *) configureTitleCell:(ThreadDetailTitleCell  *)titleCell atIndexPath:(NSIndexPath *)indexPath {
    [titleCell configureTitlelabelWithThread:self.thread];
    return titleCell;
}

- (ThreadDetailDTCell *) configureDTCell:(ThreadDetailDTCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ThreadDetail *detail = self.detailList.list[indexPath.row];
    [cell configureDetail:detail];
    cell.attributedTextContentView.shouldDrawImages = YES;
    cell.attributedTextContentView.shouldDrawLinks = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [ThreadDetailTitleCell getCellHeightWithThread:self.thread];
    }
    if (indexPath.section == 1) {
        ThreadDetailDTCell *cell = (ThreadDetailDTCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        return [cell requiredRowHeightInTableView:tableView];
    }
    
    return 0;
}

- (ThreadDetailDTCell *) tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,(long)indexPath.row];
    if (!_cellCache) {
        self.cellCache = [[NSCache alloc] init];
    }
    ThreadDetailDTCell *cell = [_cellCache objectForKey:key];
    if (! cell) {
        //cell = [[ThreadDetailDTCell alloc] initWithReuseIdentifier:kThreadDetailDTCell];
        cell = [[ThreadDetailDTCell alloc] initWithReuseIdentifier:kThreadDetailDTCell accessoryType:UITableViewCellAccessoryNone];
        [_cellCache setObject:cell forKey:key];
    }
    return [self configureDTCell:cell atIndexPath:indexPath];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThreadDetail *detail = [self.detailList.list objectAtIndex:indexPath.row];
    NSString *message = detail.threadCreator.memberName;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"@%@",message] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:alertController completion:nil];
    }];
    UIAlertAction *showAction = [UIAlertAction actionWithTitle:@"查看个人资料" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        profileVC.homepage = detail.threadCreator.memberHomepage;
        [self.navigationController pushViewController:profileVC animated:YES];
    }];
    [alertController addAction:replyAction];
    [alertController addAction:showAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
