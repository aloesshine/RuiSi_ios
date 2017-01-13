//
//  ThreadDetailBodyCell.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/7.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreadDetail.h"
@interface ThreadDetailBodyCell : UITableViewCell
@property (nonatomic,strong) ThreadDetail *threadDetail;
@property (nonatomic,strong) UINavigationController *navi;
@property (nonatomic,copy) void (^reloadCellBlock)();

+ (CGFloat) getCellHeightWithThreadDetail:(ThreadDetail *)threadDetail;
- (void) configureTDWithThreadDetail:(ThreadDetail *)threadDetail;
@end
