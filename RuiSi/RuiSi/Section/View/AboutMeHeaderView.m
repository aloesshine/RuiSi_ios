//
//  AboutMeHeaderView.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/24.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "AboutMeHeaderView.h"

@implementation AboutMeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userIconImageView = [[UIImageView alloc] init];
        self.historyImageView = [[UIImageView alloc] init];
        self.favoritesImageView = [[UIImageView alloc] init];
        self.threadsImageView = [[UIImageView alloc] init];
        self.friendsImageView = [[UIImageView alloc] init];
        
        [self addSubview:self.userIconImageView];
        [self addSubview:self.historyImageView];
        [self addSubview:self.favoritesImageView];
        [self addSubview:self.threadsImageView];
        [self addSubview:self.friendsImageView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
