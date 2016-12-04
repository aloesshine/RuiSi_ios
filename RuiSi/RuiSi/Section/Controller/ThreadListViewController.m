//
//  ThreadListViewController.m
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadListViewController.h"
#import "Thread.h"
#import "ThreadListCell.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
#import "EXTScope.h"
#import "DataManager.h"
NSString *kThreadListCell = @"ThreadListCell";

@interface ThreadListViewController ()

@property (nonatomic,strong) ThreadList *threadList;
@property (nonatomic,copy) NSURLSessionDataTask* (^getThreadListBlock)();

@end

@implementation ThreadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.navigationItem.title = self.name;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    [self configureBlocks];
    [self.tableView registerNib:[UINib nibWithNibName:kThreadListCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kThreadListCell];
    self.getThreadListBlock();
}

- (void) configureBlocks {
    @weakify(self);
    
    self.getThreadListBlock = ^{
        @strongify(self);
        
        return [[DataManager manager] getThreadListWithFid:self.fid page:nil success:^(ThreadList *threadList) {
            @strongify(self);
            self.threadList = threadList;
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}




@end
