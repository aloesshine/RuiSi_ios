//
//  ThreadDetailViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/2.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetailViewController.h"
#import "ThreadDetail.h"
#import "DataManager.h"
#import "EXTScope.h"
#import "MJRefresh.h"
#import "ThreadDetailTitleCell.h"
#import "ThreadDetailBodyCell.h"
#import "Thread.h"
#import "ThreadDetailInfoCell.h"
#import "DTAttributedTextCell.h"
#import "DTLazyImageView.h"
#import "DTImageTextAttachment.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
static NSString *DTCellIdentifier = @"DTCellIdentifier";

@interface ThreadDetailViewController () <DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>
@property (nonatomic,strong) ThreadDetailList *detailList;
@property (nonatomic,copy) NSURLSessionDataTask* (^getThreadDetailListBlock)(NSInteger page);
@property (nonatomic,copy) NSURLSessionDataTask* (^getMoreThreadDetailBlock)(NSInteger page);
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) UIBarButtonItem *favoriteButtonItem;
@property (nonatomic,strong) NSCache *cellCache;
@end

@implementation ThreadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.currentPage = 1;
    [self configureRefresh];
    [self configueBlocks];
    self.getThreadDetailListBlock(1);
}


- (void) configureRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.getThreadDetailListBlock(self.currentPage);
        if (self.detailList) {
            [self.tableView.mj_header endRefreshing];
        }
    } ];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage = self.currentPage+1;
        self.getMoreThreadDetailBlock(self.currentPage);
        if (self.detailList) {
            [self.tableView.mj_footer endRefreshing];
        }
    } ];
}
- (void) configueBlocks {
    @weakify(self);
    self.getThreadDetailListBlock = ^(NSInteger page){
        
        @strongify(self);
        self.currentPage = page;
        return [[DataManager manager] getThreadDetailListWithTid:self.tid page:page success:^(ThreadDetailList *threadDetailList) {
            self.detailList = threadDetailList;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
    
    
    self.getMoreThreadDetailBlock = ^(NSInteger page){
        @strongify(self);
        self.currentPage = page;
        return [[DataManager manager] getThreadDetailListWithTid:self.tid page:self.currentPage success:^(ThreadDetailList *threadDetailList) {
            NSMutableArray *detailLists = [[NSMutableArray alloc] initWithArray:self.detailList.list];
            [detailLists addObjectsFromArray:threadDetailList.list];
            self.detailList.list = [NSArray arrayWithArray:detailLists];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            ;
        }];
    };
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *titleCellIdentifier = @"titleCellIdentifier";
    ThreadDetailTitleCell *titleCell = (ThreadDetailTitleCell *)[tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
    if (!titleCell) {
        titleCell = [[ThreadDetailTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier];
        titleCell.navi = self.navigationController;
    }
    
    static NSString *bodyCellIdentifier = @"bodyCellIdentifier";
    ThreadDetailBodyCell *bodyCell = (ThreadDetailBodyCell *)[tableView dequeueReusableCellWithIdentifier:bodyCellIdentifier];
    if (! bodyCell) {
        bodyCell = [[ThreadDetailBodyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bodyCellIdentifier];
        bodyCell.navi = self.navigationController;
    }
    
    if (indexPath.section == 0) {
            return [self configureTitleCell:titleCell atIndexPath:indexPath];
    }
    
    if (indexPath.section == 1) {
        DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - Configure TableViewCell
- (ThreadDetailTitleCell *) configureTitleCell:(ThreadDetailTitleCell  *)titleCell atIndexPath:(NSIndexPath *)indexPath {
    [titleCell configureTitlelabelWithThread:self.thread];
    return titleCell;
}

- (DTAttributedTextCell *) configureDTCell:(DTAttributedTextCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ThreadDetail *detail = self.detailList.list[indexPath.row];
    [cell setHTMLString:detail.content];
    return cell;
}

- (ThreadDetailBodyCell *) configureBodyCell:(ThreadDetailBodyCell *) bodyCell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ThreadDetail *detail = self.detailList.list[indexPath.row];
        [bodyCell configureTDWithThreadDetail:detail];
        //NSLog(@"%@",detail.attributedString);
        @weakify(self);
        [bodyCell setReloadCellBlock:^{
            @strongify(self);
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    return bodyCell;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        CGFloat aspectRatio = frame.size.height / frame.size.width;
        CGFloat width = kScreen_Width - 16*2;
        CGFloat height = width * aspectRatio;
        UIView *view = [[UIView alloc] initWithFrame:frame];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.backgroundColor = [UIColor grayColor];
        [imageView sd_setImageWithURL:attachment.contentURL placeholderImage:[UIImage imageNamed:@"default_avatar_middle"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [ThreadDetailTitleCell getCellHeightWithThread:self.thread];
    }
    if (indexPath.section == 1) {
        DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        return [cell requiredRowHeightInTableView:tableView];
    }
    
    return 0;
}

- (DTAttributedTextCell *) tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,(long)indexPath.row];
    if (!_cellCache) {
        self.cellCache = [[NSCache alloc] init];
    }
    DTAttributedTextCell *cell = [_cellCache objectForKey:key];
    if (! cell) {
        cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:DTCellIdentifier];
        [_cellCache setObject:cell forKey:key];
    }
    return [self configureDTCell:cell atIndexPath:indexPath];
}

@end
