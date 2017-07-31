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

- (void) setupTopViewUsingPureLayout {
    self.topView.backgroundColor = [UIColor colorWithRed:0.85 green:0.13 blue:0.16 alpha:1.0];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.topView autoSetDimension:ALDimensionHeight toSize:200];
    
    self.nameLabel = [[UILabel alloc] init];
    self.avatarImage = [[UIImageView alloc] init];
    self.avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topView addSubview:self.avatarImage];
    [self.topView addSubview:self.avatarButton];
    [self.topView addSubview:self.nameLabel];
    
    [self.avatarImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40];
    [self.avatarImage autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [self.avatarImage autoSetDimensionsToSize:CGSizeMake(100, 100)];
    self.avatarImage.layer.cornerRadius = 50;
    self.avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImage.clipsToBounds = YES;
    
    self.avatarButton = [[UIButton alloc] initWithFrame:self.avatarImage.frame];
    self.avatarButton.backgroundColor = [UIColor clearColor];
    [self.avatarButton addTarget:self action:@selector(avatarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.avatarImage withOffset:20];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    
    if (self.isLogged) {
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:kUserAvatarURL]] placeholderImage:[UIImage imageNamed:@"defaultAvatar"]];
        self.nameLabel.text = [userDefaults objectForKey:kUserName];
    } else {
        self.avatarImage.image = [UIImage imageNamed:@"defaultAvatar"];
        self.nameLabel.text = @"请点击头像登陆";
    }
}


- (void) setupSecondViewUsingPureLayout {
    
    self.secondView.backgroundColor = [UIColor whiteColor];
    [self.secondView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.secondView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.secondView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topView];
    [self.secondView autoSetDimension:ALDimensionHeight toSize:90];
    
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:self.secondView.frame];
    //[self.secondView addSubview:self.stackView];
    NSArray *nibs1 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *messageCell = [nibs1 lastObject];
    [messageCell autoSetDimensionsToSize:CGSizeMake(50, 80)];
    messageCell.introLabel.text = @"我的消息";
    messageCell.introLabel.textAlignment = NSTextAlignmentCenter;
    messageCell.introLabel.font = [UIFont systemFontOfSize:16];
    [messageCell.introLabel sizeToFit];
    messageCell.iconImageView.image = [UIImage imageNamed:@"messages"];
    [messageCell bk_whenTapped:^{
        if ([DataManager isUserLogined]) {
            MessageListViewController *messageListViewController = [[MessageListViewController alloc] init];
            [self.navigationController pushViewController:messageListViewController animated:YES];
        } else {
            [self showUnloggedMessage];
        }
    }];

    
    NSArray *nibs2 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *collectionsCell = [nibs2 lastObject];
    [collectionsCell autoSetDimensionsToSize:CGSizeMake(50, 80)];
    collectionsCell.introLabel.text = @"我的收藏";
    collectionsCell.introLabel.textAlignment = NSTextAlignmentCenter;
    collectionsCell.introLabel.font = [UIFont systemFontOfSize:16];
    [collectionsCell.introLabel sizeToFit];
    collectionsCell.iconImageView.image = [UIImage imageNamed:@"favorite"];
    [collectionsCell  bk_whenTapped:^{
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

    
    NSArray *nibs3 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *postsCell = [nibs3 lastObject];
    [postsCell autoSetDimensionsToSize:CGSizeMake(50, 80)];
    postsCell.introLabel.text = @"我的帖子";
    postsCell.introLabel.textAlignment = NSTextAlignmentCenter;
    postsCell.introLabel.font = [UIFont systemFontOfSize:16];
    [postsCell.introLabel sizeToFit];
    postsCell.iconImageView.image = [UIImage imageNamed:@"posts"];
    [postsCell bk_whenTapped:^{
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
    
    NSArray *nibs4 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *profileCell = [nibs4 lastObject];
    [profileCell autoSetDimensionsToSize:CGSizeMake(50, 80)];
    profileCell.introLabel.text = @"我的资料";
    profileCell.introLabel.textAlignment = NSTextAlignmentCenter;
    profileCell.introLabel.font = [UIFont systemFontOfSize:16];
    [profileCell.introLabel sizeToFit];
    profileCell.iconImageView.image = [UIImage imageNamed:@"info"];
    [profileCell bk_whenTapped:^{
        if (self.isLogged) {
            ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
            profileViewController.hidesBottomBarWhenPushed = YES;
            profileViewController.homepage = [userDefaults objectForKey:kUserHomepage];
            [self.navigationController pushViewController:profileViewController animated:YES];
        } else {
            [self showUnloggedMessage];
        }
    }];
    
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    [stackView addArrangedSubview:messageCell];
    [stackView addArrangedSubview:collectionsCell];
    [stackView addArrangedSubview:postsCell];
    [stackView addArrangedSubview:profileCell];
    [self.secondView addSubview:stackView];
    
}

- (void) setupSecondView {
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, kScreen_Width, 90)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    NSInteger spaceWidth = (kScreen_Width-200)/5;
    NSArray *nibContents1 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *messageCell = [nibContents1 lastObject];
    messageCell.frame = CGRectMake(spaceWidth, 5, 50, 80);
    messageCell.introLabel.text = @"我的消息";
    messageCell.introLabel.textAlignment = NSTextAlignmentCenter;
    messageCell.introLabel.font = [UIFont systemFontOfSize:16];
    [messageCell.introLabel sizeToFit];
    messageCell.iconImageView.image = [UIImage imageNamed:@"messages"];
    [messageCell bk_whenTapped:^{
        if (self.isLogged) {
            MessageListViewController *messageListViewController = [[MessageListViewController alloc] init];
            [self.navigationController pushViewController:messageListViewController animated:YES];
        } else {
            [self showUnloggedMessage];
        }
    }];
    
    
    NSArray *nibContents2 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *collectionsCell = [nibContents2 lastObject];
    collectionsCell.frame = CGRectMake(spaceWidth*2+50, 5, 50, 80);
    collectionsCell.introLabel.text = @"我的收藏";
    collectionsCell.introLabel.textAlignment = NSTextAlignmentCenter;
    collectionsCell.introLabel.font = [UIFont systemFontOfSize:16];
    [collectionsCell.introLabel sizeToFit];
    collectionsCell.iconImageView.image = [UIImage imageNamed:@"favorite"];
    [collectionsCell  bk_whenTapped:^{
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
    AboutMeHeaderViewCell *postsCell = [nibContents3 lastObject];
    postsCell.frame = CGRectMake(spaceWidth*3+2*50, 5, 50, 80);
    postsCell.introLabel.text = @"我的帖子";
    postsCell.introLabel.textAlignment = NSTextAlignmentCenter;
    postsCell.introLabel.font = [UIFont systemFontOfSize:16];
    [postsCell.introLabel sizeToFit];
    postsCell.iconImageView.image = [UIImage imageNamed:@"posts"];
    [postsCell bk_whenTapped:^{
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
    AboutMeHeaderViewCell *profileCell = [nibContents4 lastObject];
    profileCell.frame = CGRectMake(spaceWidth*4+3*50, 5, 50, 80);
    profileCell.introLabel.text = @"我的资料";
    profileCell.introLabel.textAlignment = NSTextAlignmentCenter;
    profileCell.introLabel.font = [UIFont systemFontOfSize:16];
    [profileCell.introLabel sizeToFit];
    profileCell.iconImageView.image = [UIImage imageNamed:@"info"];
    [profileCell bk_whenTapped:^{
        if (self.isLogged) {
            ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
            profileViewController.hidesBottomBarWhenPushed = YES;
            profileViewController.homepage = [userDefaults objectForKey:kUserHomepage];
            [self.navigationController pushViewController:profileViewController animated:YES];
        } else {
            [self showUnloggedMessage];
        }
    }];
    
    [self.secondView addSubview:messageCell];
    [self.secondView addSubview:collectionsCell];
    [self.secondView addSubview:postsCell];
    [self.secondView addSubview:profileCell];
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

- (void) setupTableViewUsingPureLayout {
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.secondView withOffset:50.0];
    [self.tableView autoSetDimension:ALDimensionHeight toSize:4*44];
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

- (void) setupSubViewsUsingPureLayout {
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.93 alpha:1.0];
    self.topView = [[UIView alloc] init];
    self.tableView = [[AboutMeTableView alloc] initWithFrame:CGRectZero];
    self.secondView = [[UIView alloc] init];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.secondView];
    [self.view addSubview:self.tableView];
    [self setupTopViewUsingPureLayout];
    [self setupSecondViewUsingPureLayout];
    [self setupTableViewUsingPureLayout];
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
