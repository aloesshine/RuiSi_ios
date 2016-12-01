//
//  AboutMeViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/26.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "AboutMeViewController.h"
#import "AboutMeTableView.h"
#import "AboutMeHeaderViewCell.h"
#import "Constants.h"
NSString *kAboutMeHeaderViewCell = @"AboutMeHeaderViewCell";


@interface AboutMeViewController ()
@property (nonatomic,strong) AboutMeTableView *tableView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *secondView;
@property (nonatomic,strong) UIImageView *userIconImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *levelLabel;
@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.13 blue:0.16 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self initUI];
}


- (void) initUI {
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 190)];
    self.topView.backgroundColor = [UIColor colorWithRed:0.85 green:0.13 blue:0.16 alpha:1.0];
    
    self.userIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2-50, 20, 100, 100)];
    self.userIconImage.image = [UIImage imageNamed:@"tamarous_icon_middle"];
    self.userIconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userIconImage.layer.cornerRadius = 50;
    self.userIconImage.clipsToBounds = YES;
    
    [self.topView addSubview:self.userIconImage];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, kScreen_Width, 20)];
    self.nameLabel.text = @"Tamarous";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.nameLabel];
    
    
    self.levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, kScreen_Width, 16)];
    self.levelLabel.textColor = [UIColor whiteColor];
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.text = @"西电研一";
    self.levelLabel.font = [UIFont systemFontOfSize:16];
    [self.topView addSubview:self.levelLabel];
    
    
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, kScreen_Width, 90)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    NSInteger spaceWidth = (kScreen_Width-200)/5;
    NSArray *nibContents1 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell1 = [nibContents1 lastObject];
    cell1.frame = CGRectMake(spaceWidth, 5, 50, 80);
    cell1.introLabel.text = @"浏览历史";
    cell1.introLabel.textAlignment = NSTextAlignmentCenter;
    cell1.introLabel.font = [UIFont systemFontOfSize:16];
    [cell1.introLabel sizeToFit];
    
    cell1.iconImageView.image = [UIImage imageNamed:@"icon_mine_history"];
    
    NSArray *nibContents2 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell2 = [nibContents2 lastObject];
    cell2.frame = CGRectMake(spaceWidth*2+50, 5, 50, 80);
    cell2.introLabel.text = @"我的收藏";
    cell2.introLabel.textAlignment = NSTextAlignmentCenter;
    cell2.introLabel.font = [UIFont systemFontOfSize:16];
    [cell2.introLabel sizeToFit];
    cell2.iconImageView.image = [UIImage imageNamed:@"icon_mine_collect"];
    
    NSArray *nibContents3 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell3 = [nibContents3 lastObject];
    cell3.frame = CGRectMake(spaceWidth*3+2*50, 5, 50, 80);
    cell3.introLabel.text = @"我的好友";
    cell3.introLabel.textAlignment = NSTextAlignmentCenter;
    cell3.introLabel.font = [UIFont systemFontOfSize:16];
    [cell3.introLabel sizeToFit];
    cell3.iconImageView.image = [UIImage imageNamed:@"icon_mine_friend"];
    
    NSArray *nibContents4 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell4 = [nibContents4 lastObject];
    cell4.frame = CGRectMake(spaceWidth*4+3*50, 5, 50, 80);
    cell4.introLabel.text = @"我的帖子";
    cell4.introLabel.textAlignment = NSTextAlignmentCenter;
    cell4.introLabel.font = [UIFont systemFontOfSize:16];
    [cell4.introLabel sizeToFit];
    cell4.iconImageView.image = [UIImage imageNamed:@"icon_mine_info"];
    
    [self.secondView addSubview:cell1];
    [self.secondView addSubview:cell2];
    [self.secondView addSubview:cell3];
    [self.secondView addSubview:cell4];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.93 alpha:1.0];
    self.tableView = [[AboutMeTableView alloc] initWithFrame:CGRectMake(0, 300, kScreen_Width, 44*4)];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.secondView];
    [self.view addSubview:self.tableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
