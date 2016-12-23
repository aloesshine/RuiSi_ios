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
@interface ThreadDetailViewController ()

@property (nonatomic,strong) ThreadDetailList *detailList;
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


@end
