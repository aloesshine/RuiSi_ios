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
#import "MessageListViewController.h"
#import "Member.h"
#import "SettingsViewController.h"
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
    [self setupNotifications];
}


- (void) setupNotifications {
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:kLoginSuccessNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:[DataManager manager].user.member.memberAvatarMiddle] placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];
        self.nameLabel.hidden = NO;
        self.isLogged = YES;
        self.nameLabel.text = [userDefaults objectForKey:kUserName];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kLogoutSuccessNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        self.avatarImage.image = [UIImage imageNamed:@"defaultAvatar"];
        self.isLogged =  NO;
        self.nameLabel.text = @"请点击头像登录";
    }];
    
    
}
- (void) showUnloggedMessage {
    if (self.isLogged) {
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还未登录，请登陆后再使用"];
        [SVProgressHUD dismissWithDelay:1];
    }
}

- (void) askIfWillLogin {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您尚未登陆" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *gotoLogin = [UIAlertAction actionWithTitle:@"前往登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }];
    UIAlertAction *cancelLogin = [UIAlertAction actionWithTitle:@"暂时不登陆" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    [alertController addAction:gotoLogin];
    [alertController addAction:cancelLogin];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) setupTopView {
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    self.topView.backgroundColor = [UIColor colorWithRed:0.85 green:0.13 blue:0.16 alpha:1.0];
    
    self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2-50,40, 100, 100)];
    self.avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImage.layer.cornerRadius = 50;
    self.avatarImage.clipsToBounds = YES;
    
    self.avatarButton = [[UIButton alloc] initWithFrame:self.avatarImage.frame];
    self.avatarButton.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:self.avatarButton];
    [self.avatarButton addTarget:self action:@selector(avatarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topView addSubview:self.avatarImage];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, kScreen_Width, 20)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.nameLabel];
    
    
    if (self.isLogged) {
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString: [userDefaults objectForKey:kUserAvatarURL]] placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];
        self.nameLabel.text = [userDefaults objectForKey:kUserName];
    } else {
        self.avatarImage.image = [UIImage imageNamed:@"defaultAvatar"];
        self.nameLabel.text = @"请点击头像登录";
    }
}

- (void) setupSecondView {
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, kScreen_Width, 90)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    
    
    NSInteger spaceWidth = (kScreen_Width-200)/5;
    NSArray *nibContents1 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *myMessagesCell = [nibContents1 lastObject];
    myMessagesCell.frame = CGRectMake(spaceWidth, 5, 50, 80);
    myMessagesCell.introLabel.text = @"我的消息";
    myMessagesCell.introLabel.textAlignment = NSTextAlignmentCenter;
    myMessagesCell.introLabel.font = [UIFont systemFontOfSize:16];
    [myMessagesCell.introLabel sizeToFit];
    myMessagesCell.iconImageView.image = [UIImage imageNamed:@"messages"];
    [myMessagesCell bk_whenTapped:^{
        if (self.isLogged) {
            MessageListViewController *messageListViewController = [[MessageListViewController alloc] init];
            [self.navigationController pushViewController:messageListViewController animated:YES];
        } else {
            [self showUnloggedMessage];
        }
    }];
    
    
    NSArray *nibContents2 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *myCollectionsCell = [nibContents2 lastObject];
    myCollectionsCell.frame = CGRectMake(spaceWidth*2+50, 5, 50, 80);
    myCollectionsCell.introLabel.text = @"我的收藏";
    myCollectionsCell.introLabel.textAlignment = NSTextAlignmentCenter;
    myCollectionsCell.introLabel.font = [UIFont systemFontOfSize:16];
    [myCollectionsCell.introLabel sizeToFit];
    myCollectionsCell.iconImageView.image = [UIImage imageNamed:@"favorite"];
    [myCollectionsCell  bk_whenTapped:^{
        if (self.isLogged) {
            ThreadListViewController *threadListViewController = [[ThreadListViewController alloc] init];
            threadListViewController.hidesBottomBarWhenPushed = YES;
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
    AboutMeHeaderViewCell *myPostsCell = [nibContents3 lastObject];
    myPostsCell.frame = CGRectMake(spaceWidth*3+2*50, 5, 50, 80);
    myPostsCell.introLabel.text = @"我的帖子";
    myPostsCell.introLabel.textAlignment = NSTextAlignmentCenter;
    myPostsCell.introLabel.font = [UIFont systemFontOfSize:16];
    [myPostsCell.introLabel sizeToFit];
    myPostsCell.iconImageView.image = [UIImage imageNamed:@"posts"];
    [myPostsCell bk_whenTapped:^{
        if (self.isLogged) {
            ThreadListViewController *threadListViewController = [[ThreadListViewController alloc] init];
            threadListViewController.hidesBottomBarWhenPushed = YES;
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
    AboutMeHeaderViewCell *myProfileCell = [nibContents4 lastObject];
    myProfileCell.frame = CGRectMake(spaceWidth*4+3*50, 5, 50, 80);
    myProfileCell.introLabel.text = @"我的资料";
    myProfileCell.introLabel.textAlignment = NSTextAlignmentCenter;
    myProfileCell.introLabel.font = [UIFont systemFontOfSize:16];
    [myProfileCell.introLabel sizeToFit];
    myProfileCell.iconImageView.image = [UIImage imageNamed:@"info"];
    [myProfileCell bk_whenTapped:^{
        if (self.isLogged) {
            ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
            profileViewController.hidesBottomBarWhenPushed = YES;
            profileViewController.homepage = [userDefaults objectForKey:kUserHomepage];
            [self.navigationController pushViewController:profileViewController animated:YES];
        } else {
            [self showUnloggedMessage];
        }
    }];
    
    [self.secondView addSubview:myMessagesCell];
    [self.secondView addSubview:myCollectionsCell];
    [self.secondView addSubview:myPostsCell];
    [self.secondView addSubview:myProfileCell];
}

- (void) setupTableView {
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.93 alpha:1.0];
    self.tableView = [[AboutMeTableView alloc] initWithFrame:CGRectMake(0, 300, kScreen_Width, 44*4)];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.selectCellHandler = ^(AboutMeTableViewCell *cell,NSIndexPath *indexPath) {

        [weakSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row == 1) {
            SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            settingsViewController.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:settingsViewController animated:YES];
        }
    };
}

- (void) setupSubviews {
    [self setupTopView];
    [self setupSecondView];
    [self setupTableView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.secondView];
    [self.view addSubview:self.tableView];
}

- (void) avatarButtonTapped:(id) sender {
    if (self.isLogged) {
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        profileVC.homepage = [userDefaults objectForKey:kUserHomepage];
        [self.navigationController pushViewController:profileVC animated:YES];
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
        
    }
}


@end
