//
//  CollectionsTableViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/13.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "CollectionsTableViewController.h"
#import "EXTScope.h"
#import "DataManager.h"
#import "Collections.h"
#import "Collection.h"
#import "ThreadDetailViewController.h"
@interface CollectionsTableViewController ()
@property (nonatomic,strong) NSArray *collections;
@property (nonatomic,copy) NSURLSessionDataTask * ( ^ getCollectionsBlock)(NSString *uid);
@end

@implementation CollectionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlock];
    self.getCollectionsBlock(self.uid);
}


- (void) configureBlock {
    @weakify(self);
    self.getCollectionsBlock = ^ (NSString *uid) {
        @strongify(self);
        return [[DataManager manager] getCollectionsWithUid:uid success:^(NSArray *collections) {
            self.collections = [NSArray arrayWithArray:collections];
        } failure:^(NSError *error) {
            
        }];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.collections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (! tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
    }
    Collection *collection = [self.collections objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = collection.title;
    tableViewCell.textLabel.font = [UIFont systemFontOfSize:16.0];
    tableViewCell.textLabel.textAlignment = NSTextAlignmentLeft;
    [tableViewCell.textLabel sizeToFit];
    
    
    tableViewCell.detailTextLabel.text = collection.spanNum;
    tableViewCell.detailTextLabel.textColor = [UIColor blueColor];
    tableViewCell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    [tableViewCell.detailTextLabel sizeToFit];
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThreadDetailViewController *detailViewController = [[ThreadDetailViewController alloc] init];
    Collection *col = [self.collections objectAtIndex:indexPath.row];
    detailViewController.tid = col.tid;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
