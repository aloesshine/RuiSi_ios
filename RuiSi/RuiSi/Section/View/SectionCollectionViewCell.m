//
//  SectionCollectionViewCell.m
//  RuiSi
//
//  Created by aloes on 2016/11/17.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "SectionCollectionViewCell.h"

@interface SectionCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation SectionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@(-15));
        make.centerX.equalTo(@0);
        make.width.height.equalTo(@30);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(5);
        make.left.equalTo(@5);
        make.right.equalTo(@(-5));
        make.bottom.equalTo(@(-5));
    }];
}

- (void)configWithTitle:(NSString *)title image:(UIImage *)image
{
    self.titleLabel.text = title;
    self.iconImageView.image = image;
}

@end
