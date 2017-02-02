//
//  ProfileViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/7.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ProfileViewController.h"
//#import "Constants.h"
#import "Member.h"
//#import "DataManager.h"
//#import "EXTScope.h"
//#import "UIImageView+WebCache.h"
@interface ProfileViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UIImageView *avatarImageView;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIView *topView;
@property (strong,nonatomic) Member *user;

@end

@implementation ProfileViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.13 blue:0.16 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.user = [Member getMemberWithHomepage:_homepage];
    [self setupSubviews];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}



- (void) setupSubviews {
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 180)];
    self.topView.backgroundColor = [UIColor colorWithRed:0.85 green:0.13 blue:0.16 alpha:1.0];
    
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2-50, 20, 100, 100)];
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.user.memberAvatarMiddle] placeholderImage:[UIImage imageNamed:@"default_avatar_middle"]];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.layer.cornerRadius = 50;
    self.avatarImageView.clipsToBounds = YES;
    [self.topView addSubview:self.avatarImageView];
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.avatarImageView.frame.size.height + 10, kScreen_Width, 20)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.text = self.user.memberName;
    [self.topView addSubview:self.nameLabel];
    
    [self.view addSubview:self.topView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height, kScreen_Width, kScreen_Height-self.topView.frame.size.height)];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
    [self configureCell:cell AtIndexPath:indexPath];
    return cell;
}


- (void) configureCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.textLabel.text = @"积分";
        cell.detailTextLabel.text = self.user.memberCredicts;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"金币";
        cell.detailTextLabel.text = self.user.memberCoins;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"上传量";
        cell.detailTextLabel.text = self.user.memberUploads;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"下载量";
        cell.detailTextLabel.text = self.user.memberDownloads;
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"发种数";
        cell.detailTextLabel.text = self.user.memberTorrents;
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"筹码";
        cell.detailTextLabel.text = self.user.memberChip;
    } else if (indexPath.row == 6) {
        cell.textLabel.text = @"保种度";
        cell.detailTextLabel.text = self.user.memberRatio;
    } else {
        cell.textLabel.text = @"人品";
        cell.detailTextLabel.text = self.user.memberPin;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
