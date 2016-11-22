//
//  SectionCollectionViewCell.h
//  RuiSi
//
//  Created by aloes on 2016/11/17.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void) setUpFont;
- (void) setUpIconImageAtIndexPath:(NSIndexPath *)indexPath;
@end
