//
//  ThreadDetailViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/2.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetailViewController.h"
#import "ThreadDetail.h"
#import "ThreadDetailTitleCell.h"
#import "Thread.h"
#import "ThreadDetailDTCell.h"
#import "DTTextAttachment.h"
#import "ProfileViewController.h"
#import "ReplyViewController.h"
#import "RSPopUpInputView.h"
static NSString *kThreadDetailDTCell = @"ThreadDetailDTCell";
static NSString *kThreadDetailTitleCell = @"ThreadDetailTitleCell";

@interface ThreadDetailViewController () <ReplyViewControllerDelegate>
@property (nonatomic,strong) ThreadDetailList *detailList;
@property (nonatomic,copy) NSURLSessionDataTask* (^getThreadDetailListBlock)(NSInteger page);
@property (nonatomic,copy) NSURLSessionDataTask* (^getMoreThreadDetailBlock)(NSInteger page);
@property (nonatomic,copy) NSURLSessionDataTask* (^getLinksBlock)();
@property (nonatomic,copy) NSURLSessionDataTask* (^getCreatorOnlyDetailListBlock)(NSInteger page);
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSDictionary *linksDict;
@property (nonatomic,strong) NSCache *cellCache;
@property (nonatomic,copy) NSString *formhash;
@property (nonatomic,assign) NSInteger pageCount;


@end

@implementation ThreadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ThreadDetailTitleCell class] forCellReuseIdentifier:kThreadDetailTitleCell];
    [self.tableView registerClass:[ThreadDetailDTCell class] forCellReuseIdentifier:kThreadDetailDTCell];
    
    
    self.currentPage = 1;
    
    [self configueBlocks];
    self.getLinksBlock();
    [self configureRefresh];
    [self.tableView.mj_header beginRefreshing];
    [self reloadVisibleCells];
    
    
}

- (void) takeActionBlock:(void (^)())block {
    block();
}


- (void) reloadVisibleCells {
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}



- (void) favorThread {
    [self takeActionBlock:^{
       [[DataManager manager] favorThreadWithTid:self.thread.tid formhash:self.formhash success:^(NSString *message) {
           NSLog(@"message is %@",message);
           if ([message isEqualToString:kFavoriteIsSuccessful]) {
               [SVProgressHUD showSuccessWithStatus:message];
           } else {
               [SVProgressHUD showErrorWithStatus:@"操作失败"];
           }
       } failure:^(NSError *error) {
           ;
       }];
    }];
}


// TODO: 解决只看楼主模式下下拉刷新获得的仍是原始数据的问题
- (void) creatorOnly {
    [SVProgressHUD showSuccessWithStatus:@"只看楼主"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.getCreatorOnlyDetailListBlock(1);
        [self reloadVisibleCells];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void) loadNextPage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.currentPage <= self.pageCount) {
            [self readyForNextPage];
            self.getMoreThreadDetailBlock(self.currentPage);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            });
        }
    });
}

- (void) loadCurrentPage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.getThreadDetailListBlock(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    });
}

- (void) readyForNextPage {
    self.currentPage = self.currentPage + 1;
}

- (void) configureRefresh {
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCurrentPage)];
    [self.tableView.mj_header setEndRefreshingCompletionBlock:^{
        [wself.tableView reloadData];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
    [self.tableView.mj_footer setEndRefreshingCompletionBlock:^{
        [wself.tableView reloadData];
    }];
}
- (void) configueBlocks {
    @weakify(self);
    self.getThreadDetailListBlock = ^(NSInteger page){
        @strongify(self);
        self.currentPage = page;
        return [[DataManager manager] getThreadDetailListAndPageCountWithTid:self.thread.tid page:page success:^(ThreadDetailList *threadDetailList, NSString *pageCount) {
            self.detailList = threadDetailList;
            self.pageCount = [pageCount integerValue];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
    
    
    self.getMoreThreadDetailBlock = ^(NSInteger page){
        @strongify(self);
        self.currentPage = page;
        return [[DataManager manager] getThreadDetailListWithTid:self.thread.tid page:self.currentPage success:^(ThreadDetailList *threadDetailList) {
            NSMutableArray *detailLists = [[NSMutableArray alloc] initWithArray:self.detailList.list];
            [detailLists addObjectsFromArray:threadDetailList.list];
            self.detailList.list = [detailLists copy];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
    
    self.getLinksBlock = ^(){
        @strongify(self);
        return [[DataManager manager] getLinkDictionaryWithTid:self.thread.tid page:1 success:^(NSDictionary *links) {
            self.linksDict = links;
            self.formhash = [self.linksDict objectForKey:@"formhash"];
        } failure:^(NSError *error) {
            ;
        }];
    };
    
    self.getCreatorOnlyDetailListBlock = ^(NSInteger page) {
        @strongify(self);
        ThreadDetail *detail = [self.detailList.list objectAtIndex:0];
        NSString *uid = detail.threadCreator.memberUid;
        self.currentPage = page;
        return [[DataManager manager] getCreatorOnlyThreadDetailListWithTid:self.thread.tid page:self.currentPage authorid:uid success:^(ThreadDetailList *threadDetailList) {
            self.detailList = threadDetailList;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else {
        return self.detailList.countOfList;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ThreadDetailTitleCell *titleCell = (ThreadDetailTitleCell *)[tableView dequeueReusableCellWithIdentifier:kThreadDetailTitleCell];
        if (!titleCell) {
            titleCell = [[ThreadDetailTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kThreadDetailTitleCell];
            titleCell.navi = self.navigationController;
        }
        titleCell.thread = self.thread;
        return titleCell;
    } else if (indexPath.section == 1) {
        ThreadDetailDTCell *cell = [self tableView:tableView preparedCellForIndexPath:indexPath];
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - Configure TableViewCell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [ThreadDetailTitleCell getCellHeightWithThread:self.thread];
    }
    if (indexPath.section == 1) {
        ThreadDetailDTCell *cell = (ThreadDetailDTCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        return [cell requiredRowHeightInTableView:tableView];
    }
    return 0;
}

- (ThreadDetailDTCell *) tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,(long)indexPath.row];
    if (!_cellCache) {
        self.cellCache = [[NSCache alloc] init];
    }
    ThreadDetailDTCell *cell = [_cellCache objectForKey:key];
    if (! cell) {
        cell = [[ThreadDetailDTCell alloc] initWithReuseIdentifier:kThreadDetailDTCell accessoryType:UITableViewCellAccessoryNone];
        [_cellCache setObject:cell forKey:key];
    }
    ThreadDetail *detail = self.detailList.list[indexPath.row];
    cell.detail = detail;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThreadDetail *detail = [self.detailList.list objectAtIndex:indexPath.row];
    NSString *message = detail.threadCreator.memberName;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"@%@",message] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReplyViewController *replyViewController = [[ReplyViewController alloc] init];
        replyViewController.delegate = self;
        if (indexPath.row == 0) {
            replyViewController.postUrlString = [self.linksDict objectForKey:@"reply"];
        } else {
            replyViewController.postUrlString = detail.replyUrlString;
        }
        replyViewController.formhash = self.formhash;

        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition
                                                    forKey:kCATransition];
        [self.navigationController pushViewController:replyViewController animated:NO];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:alertController completion:nil];
    }];
    UIAlertAction *showAction = [UIAlertAction actionWithTitle:@"查看个人资料" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        profileVC.homepage = detail.threadCreator.memberHomepage;
        [self.navigationController pushViewController:profileVC animated:YES];
    }];
    [alertController addAction:replyAction];
    [alertController addAction:showAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - ReplyViewControllerDelegate
- (void)replyViewControllerDidCancel:(ReplyViewController *)replyViewController {
    [replyViewController.replyTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)replyViewController:(ReplyViewController *)replyViewController didPublishThreadDetail:(ThreadDetail *)threadDetail {
        [self takeActionBlock:^{
            [[DataManager manager] createReplyWithUrlString:replyViewController.postUrlString formhash:replyViewController.formhash message:replyViewController.replyTextField.text success:^(NSString *message) {
                if ([message isEqualToString:kPostIsSuccessful]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [SVProgressHUD showSuccessWithStatus:@"回复成功！"];
                }
            } failure:^(NSError *error) {
                ;
            }];
        }];
}

- (void)replyViewControllerHaveNotLogin:(ReplyViewController *)replyViewController {
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD showErrorWithStatus:@"请登陆后再试！"];
}



@end
