//
//  SectionCollectionViewCell.h
//  RuiSi
//
//  Created by aloes on 2016/11/17.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLable;
@property (nonatomic, weak) IBOutlet UILabel *countLable;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void) configureImageViewForIndexPath:(NSIndexPath *) indexPath;
- (void) setUpFont;
@end
