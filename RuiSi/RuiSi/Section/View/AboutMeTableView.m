//
//  AboutMeTableView.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/26.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "AboutMeTableView.h"
#import "AboutMeTableViewCell.h"

NSString *kAboutMeTableViewCell = @"AboutMeTableViewCell";


@interface AboutMeTableView() <UITableViewDelegate,UITableViewDataSource>

@end


@implementation AboutMeTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}


- (void) initUI {
    self.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.93 alpha:1.0];
    self.tableFooterView = [[UIView alloc] init];
    [self registerNib:[UINib nibWithNibName:kAboutMeTableViewCell bundle:nil] forCellReuseIdentifier:kAboutMeTableViewCell];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutMeTableViewCell *tableViewCell = [self dequeueReusableCellWithIdentifier:kAboutMeTableViewCell forIndexPath:indexPath];
    if (!tableViewCell) {
        tableViewCell = [[AboutMeTableViewCell alloc] init];
    }
    [self configureCell:tableViewCell atIndexPath:indexPath];
    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return tableViewCell;
}

- (void) configureCell:(AboutMeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = @"签到中心";
                cell.iconImageView.image = [UIImage imageNamed:@"check"];
                break;
            case 1:
                cell.titleLabel.text = @"设置";
                cell.iconImageView.image = [UIImage imageNamed:@"settings"];
                break;
            case 2:
                cell.titleLabel.text = @"关于本程序";
                cell.iconImageView.image = [UIImage imageNamed:@"about"];
                break;
            case 3:
                cell.titleLabel.text = @"睿思帮助";
                cell.iconImageView.image = [UIImage imageNamed:@"help"];
                break;
            default:
                break;
        }
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutMeTableViewCell *cell = (AboutMeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.selectCellHandler) {
        self.selectCellHandler(cell,indexPath);
    }
}

@end
