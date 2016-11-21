//
//  SectionHeaderViewCell.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/19.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "SectionHeaderViewCell.h"

@implementation SectionHeaderViewCell

- (void)setUpFontAndBackground
{
    self.headerTitleLabel.font = [UIFont systemFontOfSize:12];
    self.headerTitleLabel.textColor = [UIColor colorWithRed:0.67 green:0.12 blue:0.13 alpha:1];
    self.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.93 alpha:1];
}

@end
