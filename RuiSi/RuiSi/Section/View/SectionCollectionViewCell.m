//
//  SectionCollectionViewCell.m
//  RuiSi
//
//  Created by aloes on 2016/11/17.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "SectionCollectionViewCell.h"

@implementation SectionCollectionViewCell

- (void)setUpFont
{
        self.titleLable.font = [UIFont systemFontOfSize:12];
        self.countLable.font = [UIFont systemFontOfSize:15];
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0  blue:1.0 alpha:1];
}

- (void)configureImageViewForIndexPath:(NSIndexPath *)indexPath {
    
    NSString *fileName = [NSString stringWithFormat:@"%ld_%ld",(indexPath.section+1),(indexPath.row+1)];
    
    self.iconImageView.image = [UIImage imageNamed:fileName];
}
@end
