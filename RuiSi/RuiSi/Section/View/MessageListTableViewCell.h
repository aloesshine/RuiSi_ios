//
//  MessageListTableViewCell.h
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/16.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
@interface MessageListTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UILabel *messageLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) Message *message;
@end
