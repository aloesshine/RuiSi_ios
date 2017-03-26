//
//  PostViewCell.h
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Thread.h"
@interface ThreadListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hasPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (strong,nonatomic) Thread *thread;

@end
