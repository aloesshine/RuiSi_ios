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
      //  _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
      //  [_button setImage:[UIImage imageNamed:@"common_561_icon"] forState:UIControlStateNormal];
      //  [_button setTitle:@"XX" forState:UIControlStateNormal];
    }
    return self;
}

- (void)configureImageViewForIndexPath:(NSIndexPath *)indexPath {
    
    NSString *fileName = [NSString stringWithFormat:@"%ld_%ld.png",(long)(indexPath.section+1),(long)(indexPath.row+1)];
    
    [self.iconImageView setImage:[UIImage imageNamed:fileName]];
}
@end
