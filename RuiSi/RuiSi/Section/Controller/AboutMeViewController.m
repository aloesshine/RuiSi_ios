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
#import "ThreadListViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "Member.h"

//#import "Constants.h"
//#import "UIView+BlocksKit.h"
//#import "SVProgressHUD.h"
//#import "UIImageView+WebCache.h"
//#import "DataManager.h"
NSString *kAboutMeHeaderViewCell = @"AboutMeHeaderViewCell";


@interface AboutMeViewController ()
@property (nonatomic,strong) AboutMeTableView *tableView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *secondView;
@property (nonatomic,strong) UIImageView *avatarImage;
@property (nonatomic,strong) UIButton *avatarButton;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,assign) BOOL isLogged;
@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.13 blue:0.16 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.isLogged = [DataManager isUserLogined];
    [self setupSubviews];
    [self configureNotifications];
}


- (void) configureNotifications {
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:kLoginSuccessNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:[DataManager manager].user.member.memberAvatarMiddle] placeholderImage:[UIImage imageNamed:@"default_avatar_middle"]];
        self.nameLabel.hidden = NO;
        self.isLogged = YES;
        self.nameLabel.text = [userDefaults objectForKey:kUserName];
    }];
}
- (void) showUnloggedMessage {
    if (self.isLogged) {
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还未登录，请登陆后再使用"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}


- (void) setupSubviews {
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    self.topView.backgroundColor = [UIColor colorWithRed:0.85 green:0.13 blue:0.16 alpha:1.0];
    
    self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2-50,40, 100, 100)];
    self.avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImage.layer.cornerRadius = 50;
    self.avatarImage.clipsToBounds = YES;
    
    self.avatarButton = [[UIButton alloc] initWithFrame:self.avatarImage.frame];
    self.avatarButton.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:self.avatarButton];
    
    [self.avatarButton bk_whenTapped:^{
        if (self.isLogged) {
            ProfileViewController *profileVC = [[ProfileViewController alloc] init];
            profileVC.homepage = [userDefaults objectForKey:kUserHomepage];
            [self.navigationController pushViewController:profileVC animated:YES];
        } else {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
    }];
    [self.topView addSubview:self.avatarImage];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, kScreen_Width, 20)];
    //self.nameLabel.text = @"Tamarous";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.nameLabel];
    
    
    if (self.isLogged) {
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString: [userDefaults objectForKey:kUserAvatarURL]] placeholderImage:[UIImage imageNamed:@"default_avatar_middle"]];
        self.nameLabel.text = [userDefaults objectForKey:kUserName];
    } else {
        self.avatarImage.image = [UIImage imageNamed:@"default_avatar_middle"];
        self.nameLabel.text = @"请点击头像登录";
    }
    
    
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, kScreen_Width, 90)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    NSInteger spaceWidth = (kScreen_Width-200)/5;
    
    NSArray *nibContents1 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell1 = [nibContents1 lastObject];
    cell1.frame = CGRectMake(spaceWidth, 5, 50, 80);
    cell1.introLabel.text = @"我的消息";
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
    [cell2  bk_whenTapped:^{
        if (self.isLogged) {
            ThreadListViewController *threadListViewController = [[ThreadListViewController alloc] init];
            __weak ThreadListViewController *threadListViewController_ = threadListViewController;
            threadListViewController.needToGetMore = NO;
            threadListViewController.name = @"我的收藏";
            threadListViewController.getThreadListBlock = ^(NSInteger page) {
                return [[DataManager manager] getFavoriteThreadListWithUid:[userDefaults objectForKey:kUserID] success:^(ThreadList *threadList) {
                    threadListViewController_.threadList = threadList;
                    [threadListViewController_.tableView reloadData];
                } failure:^(NSError *error) {
                    
                }];
            };
            [self.navigationController pushViewController:threadListViewController animated:YES];
        } else {
            [self showUnloggedMessage];
        }
    }];
    
    
    NSArray *nibContents3 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell3 = [nibContents3 lastObject];
    cell3.frame = CGRectMake(spaceWidth*3+2*50, 5, 50, 80);
    cell3.introLabel.text = @"我的帖子";
    cell3.introLabel.textAlignment = NSTextAlignmentCenter;
    cell3.introLabel.font = [UIFont systemFontOfSize:16];
    [cell3.introLabel sizeToFit];
    cell3.iconImageView.image = [UIImage imageNamed:@"icon_mine_friend"];
    [cell3 bk_whenTapped:^{
        if (self.isLogged) {
            ThreadListViewController *threadListViewController = [[ThreadListViewController alloc] init];
            __weak ThreadListViewController *threadListViewController_ = threadListViewController;
            threadListViewController.needToGetMore = NO;
            threadListViewController_.name = @"我的帖子";
            threadListViewController.getThreadListBlock = ^(NSInteger page) {
                return [[DataManager manager] getThreadListWithUid:[userDefaults objectForKey:kUserID] success:^(ThreadList *threadList) {
                    threadListViewController_.threadList = threadList;
                    [threadListViewController_.tableView reloadData];
                } failure:^(NSError *error) {
                    
                }];
            };
            [self.navigationController pushViewController:threadListViewController animated:YES];
        } else {
            [self showUnloggedMessage];
        }
    }];
    
    NSArray *nibContents4 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell4 = [nibContents4 lastObject];
    cell4.frame = CGRectMake(spaceWidth*4+3*50, 5, 50, 80);
    cell4.introLabel.text = @"我的资料";
    cell4.introLabel.textAlignment = NSTextAlignmentCenter;
    cell4.introLabel.font = [UIFont systemFontOfSize:16];
    [cell4.introLabel sizeToFit];
    cell4.iconImageView.image = [UIImage imageNamed:@"icon_mine_info"];
    [cell4 bk_whenTapped:^{
        if (self.isLogged) {
            ProfileViewController *profileVC = [[ProfileViewController alloc] init];
            profileVC.homepage = [userDefaults objectForKey:kUserHomepage];
            [self.navigationController pushViewController:profileVC animated:YES];
        } else {
            [self showUnloggedMessage];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }];
    
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
