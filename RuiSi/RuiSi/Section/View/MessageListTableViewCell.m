//
//  MessageListTableViewCell.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/16.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "MessageListTableViewCell.h"

@interface MessageListTableViewCell()

@end


@implementation MessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMessage:(Message *)message {
    _message = message;
    self.titleLabel.text = message.title;
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:message.friendAvatarURL] placeholderImage:[UIImage imageNamed:@"default_avatar_small"]];
    self.messageLabel.text = message.messageContent;
    self.messageLabel.font = [UIFont systemFontOfSize:14.0];
    self.timeLabel.text = message.messageTime;
    self.timeLabel.font = [UIFont systemFontOfSize:14.0];
}

@end
