//
//  PostViewCell.m
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadListCell.h"

@implementation ThreadListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setThread:(Thread *)thread {
    _thread = thread;
    self.titleLabel.text = thread.title;
    if (thread.author == nil) {
        self.authorLabel.hidden = YES;
    } else {
        self.authorLabel.text = thread.author;
    }
    self.reviewCountLabel.text = thread.reviewCount;
    if (thread.hasPic) {
        self.hasPicImageView.image = [UIImage imageNamed:@"icon_tu"];
    }
}

@end
