//
//  ThreadDetailTitleCell.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/6.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Thread.h"
@interface ThreadDetailTitleCell : UITableViewCell
@property (nonatomic,strong) Thread *thread;

+(CGFloat) getCellHeightWithThread:(Thread *)thread;
@end
