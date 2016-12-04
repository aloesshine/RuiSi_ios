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
@interface ThreadDetailViewController ()

@property (nonatomic,strong) ThreadDetailList *detailList;
@property (nonatomic,strong) NSURLSessionDataTask* (^getThreadDetailListBlock)();
@end

@implementation ThreadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configueBlocks];
    self.getThreadDetailListBlock();
}


- (void) configueBlocks {
    @weakify(self);
    self.getThreadDetailListBlock = ^{
        @strongify(self);
        return [[DataManager manager] getThreadDetailListWithTid:self.tid page:nil success:^(ThreadDetailList *threadDetailList) {
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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.detailList countOfList];
}



@end
