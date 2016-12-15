//
//  ThreadDetailInfoCell.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/7.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreadDetail.h"
@interface ThreadDetailInfoCell : UITableViewCell
@property (nonatomic,strong) ThreadDetail *threadDetail;
@property (nonatomic,assign) UINavigationController *navi;
+ (CGFloat) getCellHeightWithThreadDetail:(ThreadDetail *)threadDetail;

@end
