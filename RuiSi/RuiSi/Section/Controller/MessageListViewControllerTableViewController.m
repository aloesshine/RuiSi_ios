//
//  MessageListViewControllerTableViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/16.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "MessageListViewControllerTableViewController.h"
#import "Message.h"
#import "DataManager.h"
#import "MessageListTableViewCell.h"
#import "UIImageView+WebCache.h"
NSString *kMessageListTableViewCell = @"MessageListTableViewCell";
@interface MessageListViewControllerTableViewController ()
@property (nonatomic,strong) MessageList *messageList;
@property (nonatomic,strong) NSURLSessionDataTask * (^ getMessageListBlock)();
@end

@implementation MessageListViewControllerTableViewController

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
    MessageListTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:kMessageListTableViewCell];
    
    return tableViewCell;
}


- (void) configureCell:(MessageListTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messageList.list[indexPath.row];
    cell.titleLabel.text = message.title;
    cell.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:message.friendAvatarURL] placeholderImage:[UIImage imageNamed:@"default_avatar_small"]];
    cell.messageLabel.text = message.messageContent;
    cell.messageLabel.font = [UIFont systemFontOfSize:14.0];
    cell.timeLabel.text = message.messageTime;
    cell.timeLabel.font = [UIFont systemFontOfSize:14.0];
}
@end
