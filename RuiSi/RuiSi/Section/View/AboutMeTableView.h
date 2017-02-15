//
//  AboutMeTableView.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/26.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AboutMeTableViewCell;
@interface AboutMeTableView : UITableView
@property (nonatomic,copy) void (^selectCellHandler) (AboutMeTableViewCell *cell,NSIndexPath *indexPath);
@end
