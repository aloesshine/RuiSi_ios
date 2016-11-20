//
//  SectionCollectionViewCell.m
//  RuiSi
//
//  Created by aloes on 2016/11/17.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "SectionCollectionViewCell.h"

@implementation SectionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

- (void)configureImageViewForIndexPath:(NSIndexPath *)indexPath {
    
    NSString *fileName = [NSString stringWithFormat:@"%ld_%ld",(indexPath.section+1),(indexPath.row+1)];
    
    self.iconImageView.image = [UIImage imageNamed:fileName];
}
@end
