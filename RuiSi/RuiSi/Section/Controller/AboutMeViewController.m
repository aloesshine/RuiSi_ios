//
//  AboutMeViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/24.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "AboutMeViewController.h"
#import "AboutMeHeaderView.h"
@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AboutMeHeaderView *headerView = [[AboutMeHeaderView alloc] init];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 4;
    } else if (section == 1){
        return 1;
    } else {
        return 0;
    }
}


@end
