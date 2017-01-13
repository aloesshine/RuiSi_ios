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
@interface CollectionsTableViewController ()
@property (nonatomic,strong) NSArray *collections;
@property (nonatomic,strong) NSURLSessionDataTask * ( ^ getCollectionsBlock)(NSString *uid);
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

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

@end
