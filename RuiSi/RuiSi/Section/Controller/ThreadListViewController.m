//
//  ThreadListViewController.m
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadListViewController.h"
#import "ThreadDetailViewController.h"
#import "Thread.h"
#import "ThreadListCell.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
#import "EXTScope.h"
#import "DataManager.h"
#import "MJRefresh.h"
NSString *kThreadListCell = @"ThreadListCell";
NSString *kShowThreadDetail = @"showThreadDetail";
@interface ThreadListViewController ()

@property (nonatomic,strong) ThreadList *threadList;
@property (nonatomic,copy) NSURLSessionDataTask* (^getThreadListBlock)(NSInteger page);
@property (nonatomic,copy) NSURLSessionDataTask* (^getMoreListBlock)(NSInteger page);
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation ThreadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    // 设置标题
    self.navigationItem.title = self.name;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self configureRefresh];
    
    [self configureBlocks];
    [self.tableView registerNib:[UINib nibWithNibName:kThreadListCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kThreadListCell];
    self.getThreadListBlock(1);
}

- (void) configureRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.getThreadListBlock(self.currentPage);
        if (self.threadList) {
            [self.tableView.mj_header endRefreshing];
            
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage = self.currentPage+1;
        self.getMoreListBlock(self.currentPage);
        if (self.threadList) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}



- (void) configureBlocks {
    @weakify(self);
    
    self.getThreadListBlock = ^(NSInteger page){
        @strongify(self);
        
        
        self.currentPage = page;
        return [[DataManager manager] getThreadListWithFid:self.fid page:page success:^(ThreadList *threadList) {
            @strongify(self);
            self.threadList = threadList;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
    
    
    self.getMoreListBlock = ^(NSInteger page) {
        @strongify(self);
        self.currentPage = page;
        return [[DataManager manager] getThreadListWithFid:self.fid page:page success:^(ThreadList *threadList) {
            @strongify(self);
            
            NSMutableArray *threadLists = [[NSMutableArray alloc] initWithArray:self.threadList.list];
            [threadLists addObjectsFromArray:threadList.list];
            self.threadList.list = [NSArray arrayWithArray:threadLists];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_threadList countOfList];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThreadListCell *cell = [tableView dequeueReusableCellWithIdentifier:kThreadListCell forIndexPath:indexPath];
    
    Thread *thread = _threadList.list[indexPath.row];
    
    cell.titleLabel.text = thread.title;
    cell.authorLabel.text = thread.author;
    cell.reviewCountLabel.text = thread.reviewCount;
    cell.hasPicImageView.image = thread.hasPic == YES ? [UIImage imageNamed:@"icon_tu"] : NULL;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowThreadDetail]) {
        UINavigationController *navController = segue.destinationViewController;
        ThreadDetailViewController *threadDetailViewController =  [navController.viewControllers firstObject];
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        Thread *thread = [self.threadList.list objectAtIndex:[index row]];
        threadDetailViewController.tid = thread.tid;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kShowThreadDetail sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}




@end
