//
//  ThreadDetailInfoCell.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/7.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetailInfoCell.h"
#import "ProfileViewController.h"
#import "BlocksKit+UIKit.h"
#import "EXTScope.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
static CGFloat const kAvatarHeight = 16.0f;

@interface ThreadDetailInfoCell()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIButton *avatarButton;
@end

@implementation ThreadDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.avatarImageView = [[UIImageView alloc] init];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.layer.cornerRadius = 2;
        self.avatarImageView.clipsToBounds = YES;
        
        self.avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];

        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.clipsToBounds = YES;

        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        
        
        @weakify(self);
        [self.avatarButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            ProfileViewController *profileVC = [[ProfileViewController alloc] init];
            [self.navi pushViewController:profileVC animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}


- (void)setThreadDetail:(ThreadDetail *)threadDetail {
    _threadDetail = threadDetail;
    self.nameLabel.text = threadDetail.creatorName;
    [self.nameLabel sizeToFit];
    self.timeLabel.text = threadDetail.createTime;
    [self.timeLabel sizeToFit];
    NSURL *avatarURL = [NSURL URLWithString:threadDetail.threadCreator.memberAvatarSmall];
    [self.avatarImageView sd_setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];
}

+ (CGFloat)getCellHeightWithThreadDetail:(ThreadDetail *)threadDetail {
    return 28;
}

@end
