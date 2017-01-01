//
//  ThreadDetailViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/2.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetailViewController.h"
#import "ThreadDetail.h"
#import "DataManager.h"
#import "EXTScope.h"
#import "MJRefresh.h"
#import "ThreadDetailTitleCell.h"
#import "ThreadDetailBodyCell.h"
#import "Thread.h"
#import "ThreadDetailInfoCell.h"
@interface ThreadDetailViewController ()

@property (nonatomic,strong) ThreadDetailList *detailList;
@property (nonatomic,strong) Thread *thread;
@property (nonatomic,strong) NSURLSessionDataTask* (^getThreadDetailListBlock)(NSInteger page);
@property (nonatomic,strong) NSURLSessionDataTask* (^getMoreThreadDetailBlock)(NSInteger page);
@property (nonatomic,assign) NSInteger currentPage;
@end

@implementation ThreadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    [self configureRefresh];
    [self configueBlocks];
    self.getThreadDetailListBlock(1);
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.detailList countOfList];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *titleCellIdentifier = @"titleCellIdentifier";
    ThreadDetailTitleCell *titleCell = (ThreadDetailTitleCell *)[tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
    if (!titleCell) {
        titleCell = [[ThreadDetailTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier];
        titleCell.navi = self.navigationController;
    }
    
//    static NSString *infoCellIdentifier = @"infoCellIdentifier";
//    ThreadDetailInfoCell *infoCell = (ThreadDetailInfoCell *)[tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
//    if (!infoCell) {
//        infoCell = [[ThreadDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellIdentifier];
//        infoCell.navi = self.navigationController;
//    }
    
    static NSString *bodyCellIdentifier = @"bodyCellIdentifier";
    ThreadDetailBodyCell *bodyCell = (ThreadDetailBodyCell *)[tableView dequeueReusableCellWithIdentifier:bodyCellIdentifier];
    if (! bodyCell) {
        bodyCell = [[ThreadDetailBodyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bodyCellIdentifier];
        bodyCell.navi = self.navigationController;
    }
    
    if (indexPath.section == 0) {
        return [self configureTitleCell:titleCell atIndexPath:indexPath];
    }
    
    if (indexPath.section == 1) {
        return [self configureBodyCell:bodyCell atIndexPath:indexPath];
    }
    return [UITableViewCell new];
}

#pragma mark - Configure TableViewCell
- (ThreadDetailTitleCell *) configureTitleCell:(ThreadDetailTitleCell  *)titleCell atIndexPath:(NSIndexPath *)indexPath {
    titleCell.thread = self.thread;
    return titleCell;
}

- (ThreadDetailBodyCell *) configureBodyCell:(ThreadDetailBodyCell *) bodyCell atIndexPath:(NSIndexPath *)indexPath {
    bodyCell.threadDetail = self.detailList.list[indexPath.row];
    
    @weakify(self);
    [bodyCell setReloadCellBlock:^{
        @strongify(self);
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];
    return bodyCell;
}

@end
