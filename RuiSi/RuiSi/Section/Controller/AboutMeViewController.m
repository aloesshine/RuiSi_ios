//
//  AboutMeViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/24.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "AboutMeViewController.h"
#import "AboutMeHeaderViewCell.h"
NSString *kAboutMeHeaderViewCell = @"AboutMeHeaderViewCell";
NSString *kAboutMeTableViewCell = @"AboutMeTableViewCell";
@interface AboutMeViewController ()
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *secondView;
@property (nonatomic,strong) UIImageView *userIconImageView;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *levelLabel;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.width = [[UIScreen mainScreen] bounds].size.width;
    self.height = [[UIScreen mainScreen] bounds].size.height;
    [self initUI];
    
    
}


- (void) initUI {
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, _height/3)];
    self.topView.backgroundColor = [UIColor colorWithRed:0.83 green:0.13 blue:0.16 alpha:1.0];
    
    
    self.userIconImageView.frame = CGRectMake(_width/2.0-30, _height/6-40, 60, 60);
    [self.topView addSubview:self.userIconImageView];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.frame = CGRectMake(0, -_height/6+50, _width, 20);
    self.userNameLabel.font = [UIFont systemFontOfSize:18];
    self.userNameLabel.text = @"placeHolder";
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.userNameLabel];
    
    self.levelLabel = [[UILabel alloc] init];
    self.levelLabel.frame = CGRectMake(0, _height/6+80, _width, 20);
    self.levelLabel.text = @"placeHolder";
    self.levelLabel.textColor = [UIColor whiteColor];
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.font = [UIFont systemFontOfSize:16];
    [self.topView addSubview:self.levelLabel];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.93 alpha:1.0];
    [self.view addSubview:self.topView];
    
    
    
    
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(0, _height/3, _width, 100)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    NSInteger spaceWidth = (_width - 200)/5;
    
    
    NSArray *nibContents1 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell1 = [nibContents1 lastObject];
    cell1.introLabel.text = @"浏览历史";
    cell1.frame = CGRectMake(spaceWidth, 0, 50, 80);
    
    NSArray *nibContents2 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell2 = [nibContents2 lastObject];
    cell2.introLabel.text = @"我的收藏";
    cell2.frame = CGRectMake(spaceWidth*2+50, 0, 50, 80);
    
    NSArray *nibContents3 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell3 = [nibContents3 lastObject];
    cell3.introLabel.text = @"我的好友";
    cell3.frame = CGRectMake(spaceWidth*3+50, 0, 50, 80);
    
    
    NSArray *nibContents4 = [[NSBundle mainBundle] loadNibNamed:kAboutMeHeaderViewCell owner:self options:nil];
    AboutMeHeaderViewCell *cell4 = [nibContents4 lastObject];
    cell4.introLabel.text = @"我的帖子";
    cell4.frame = CGRectMake(spaceWidth*4+50, 0, 50, 80);
    [self.secondView addSubview:cell1];
    [self.secondView addSubview:cell2];
    [self.secondView addSubview:cell3];
    [self.secondView addSubview:cell4];
    [self.view addSubview:self.secondView];
    
    
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
    return nil;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kAboutMeTableViewCell];
    if (! tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] init];
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
                
                break;
                
            default:
                break;
        }
    }
    return tableViewCell;
}

@end
