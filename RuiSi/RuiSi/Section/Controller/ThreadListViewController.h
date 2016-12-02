//
//  ThreadListViewController.h
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadListViewController : UITableViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic,strong) NSString *fid;
@end
