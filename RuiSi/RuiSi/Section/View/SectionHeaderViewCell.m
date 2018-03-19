//
//  SectionHeaderViewCell.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/19.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "SectionHeaderViewCell.h"

@interface SectionHeaderViewCell ()

@property (nonatomic, strong) UILabel *headerTitleLabel;

@end

@implementation SectionHeaderViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.contentView.backgroundColor = RSRGBColor(0.91, 0.93, 0.93, 1);
    
    self.headerTitleLabel = [[UILabel alloc] init];
    self.headerTitleLabel.font = [UIFont systemFontOfSize:12];
    self.headerTitleLabel.textColor = RSMainColor;
    [self.contentView addSubview:self.headerTitleLabel];
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.right.bottom.equalTo(@(-10));
    }];
}

- (void)configWithTitle:(NSString *)title
{
    self.headerTitleLabel.text = title;
}

@end
