//
//  LogInViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/1/13.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "LogInViewController.h"
#import "EXTScope.h"
#import "UIView+BlocksKit.h"
#import "Constants.h"
@interface LogInViewController ()<UITextFieldDelegate>
@property (strong,nonatomic) UITextField *userName;
@property (strong,nonatomic) UITextField *userPassword;
@property (strong,nonatomic) UIButton *loginButton;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubsviews];
    [self.userName becomeFirstResponder];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}


- (void) closeKeyboard:(id)sender {
    NSLog(@"tap");
}

- (void) setupSubsviews {
    UITextField* userName = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, kScreen_Width, 44)];
    userName.placeholder = @"用户名/邮箱/Email";
    userName.textAlignment = NSTextAlignmentLeft;
    userName.font = [UIFont systemFontOfSize:16.0];
    userName.delegate = self;
    self.userName = userName;
    [self.view addSubview:self.userName];
    
    UITextField* userPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 144, kScreen_Width, 44)];
    userPassword.placeholder = @"输入密码";
    userPassword.textAlignment = NSTextAlignmentLeft;
    userPassword.font = [UIFont systemFontOfSize:16.0];
    userPassword.delegate = self;
    self.userPassword = userPassword;
    [self.view addSubview:self.userPassword];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width/2-100/2, userPassword.frame.origin.y + userPassword.frame.size.height + 44, 100, 44)];
    loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginButton.titleLabel.text = @"登录";
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    loginButton.titleLabel.textColor = [UIColor blackColor];
    self.loginButton = loginButton;
    [self.view addSubview:self.loginButton];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) saveUserNameAndPassword {
    
}


@end
