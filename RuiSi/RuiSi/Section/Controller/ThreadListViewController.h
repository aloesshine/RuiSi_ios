//
//  ThreadListViewController.h
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Thread.h"
@interface ThreadListViewController : UITableViewController
@property (nonatomic,copy) NSURLSessionDataTask* (^getThreadListBlock)(NSInteger page);
@property (nonatomic,copy) NSURLSessionDataTask* (^getMoreListBlock)(NSInteger page);
@property (nonatomic,strong) ThreadList *threadList;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic,copy) NSString *fid;
@property (nonatomic,assign) BOOL needToGetMore;

- (void) readyForNextPage;
@end
