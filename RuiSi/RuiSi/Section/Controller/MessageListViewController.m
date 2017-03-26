//
//  MessageListViewControllerTableViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/16.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "MessageListViewController.h"
#import "Message.h"
#import "DataManager.h"
#import "MessageListTableViewCell.h"
#import "UIImageView+WebCache.h"
NSString *kMessageListTableViewCell = @"MessageListTableViewCell";
@interface MessageListViewController ()
@property (nonatomic,strong) MessageList *messageList;
@property (nonatomic,strong) NSURLSessionDataTask * (^ getMessageListBlock)();
@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:kMessageListTableViewCell bundle:nil] forCellReuseIdentifier:kMessageListTableViewCell];
    [self configueBlock];
    self.getMessageListBlock();
}

- (void) configueBlock {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.messageList.countOfList;
}


- (MessageListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageListTableViewCell];
    if (! cell) {
        cell = [[MessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMessageListTableViewCell];
    }
    Message *message = self.messageList.list[indexPath.row];
    cell.message = message;
    return cell;
}

@end
