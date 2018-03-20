//
//  LoginViewController.m
//  RuiSi
//
//  Created by aloes on 2017/1/17.
//  Copyright © 2017年 aloes. All rights reserved.
//
#import "LoginViewController.h"
#import "Member.h"
#import "User.h"
#import "FLAnimatedImage.h"

@interface LoginViewController ()

@property (nonatomic, assign) BOOL isLogining;
@property (nonatomic, assign) BOOL isKeyboardShowing;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UITextField *verifycodeField;
@property (nonatomic, strong) FLAnimatedImageView *verifyImageView;

@property (nonatomic, strong) NSDictionary *htmlFieldsDictionary;
@property (nonatomic, strong) NSTimer *loginTimer;
@property (nonatomic, copy) NSURLSessionDataTask* (^requestOnceBlock)(void);

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.isLogining = NO;
    self.isKeyboardShowing = NO;
    [self setupUI];
    [self.usernameField becomeFirstResponder];
    [self configureBlocks];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.requestOnceBlock();
    });
}

- (void)setupUI
{
    self.usernameField = [[UITextField alloc] init];
    self.usernameField.placeholder = @"输入用户名";
    self.usernameField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.usernameField];
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.left.equalTo(@40);
        make.right.equalTo(@(-40));
        make.height.equalTo(@40);
    }];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameField.mas_bottom).offset(2);
        make.left.right.equalTo(self.usernameField);
        make.height.equalTo(@0.5);
    }];
    
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.placeholder = @"输入密码";
    self.passwordField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameField.mas_bottom).offset(15);
        make.left.equalTo(@40);
        make.right.equalTo(@(-40));
        make.height.equalTo(@40);
    }];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(2);
        make.left.right.equalTo(self.passwordField);
        make.height.equalTo(@0.5);
    }];
    
    self.verifycodeField = [[UITextField alloc] init];
    self.verifycodeField.placeholder = @"输入验证码";
    self.verifycodeField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.verifycodeField];
    [self.verifycodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(15);
        make.left.equalTo(@40);
        make.right.equalTo(@(-40 - 80 - 10));
        make.height.equalTo(@40);
    }];
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifycodeField.mas_bottom).offset(2);
        make.left.right.equalTo(self.verifycodeField);
        make.height.equalTo(@0.5);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[UIImage imageNamed:@"cancel_dark"] forState:UIControlStateNormal];
    [self.cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20).priorityMedium();
        make.left.equalTo(@20);
        make.height.width.equalTo(@20);
    }];
    
    self.verifyImageView = [[FLAnimatedImageView alloc] init];
    [self.view addSubview:self.verifyImageView];
    [self.verifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifycodeField);
        make.left.equalTo(self.verifycodeField.mas_right).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];

    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.backgroundColor = RSMainColor;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 20;
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:RSRGBColor(1, 1, 1, 0.6) forState:UIControlStateHighlighted];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifycodeField.mas_bottom).offset(40);
        make.left.equalTo(@60);
        make.right.equalTo(@(-60));
        make.height.equalTo(@40);
    }];
}

- (void)configureBlocks
{
    @weakify(self);
    self.requestOnceBlock = ^(void) {
        @strongify(self);
        return [[DataManager manager] requestOnceWithString:@"member.php" success:^(NSDictionary *dictionary) {
            self.htmlFieldsDictionary = [dictionary copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                SDWebImageDownloader *downloader = [SDWebImageManager sharedManager].imageDownloader;
                NSString *referer = (NSString *)[self.htmlFieldsDictionary valueForKey:@"referer"];
                [downloader setValue:referer forHTTPHeaderField:@"Referer"];
                NSString *imageUrlString = (NSString *)[self.htmlFieldsDictionary valueForKey:@"verifyImageUrlString"];
                //[self.verifyImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
                [self.verifyImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil options:SDWebImageHandleCookies];
            });
        } failure:^(NSError *error) {
            ;
        }];
    };
}

- (void)back:(UIButton *)sender
{
    if([self.usernameField isFirstResponder]) {
        [self.usernameField resignFirstResponder];
    }
    if([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    }
    if ([self.verifycodeField isFirstResponder]) {
        [self.verifycodeField resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)beginLogin
{
    self.isLogining = YES;
    self.usernameField.enabled = NO;
    self.passwordField.enabled = NO;
    self.verifycodeField.enabled = NO;
    static NSUInteger dotCount = 0;
    dotCount = 1;
    [self.loginButton setTitle:@"登录." forState:UIControlStateNormal];
    
    @weakify(self);
    self.loginTimer = [NSTimer bk_scheduledTimerWithTimeInterval:0.5 block:^(NSTimer *timer) {
        @strongify(self);
        
        if (dotCount > 3) {
            dotCount = 0;
        }
        NSString *loginString = @"登录";
        for (int i = 0; i < dotCount; i ++) {
            loginString = [loginString stringByAppendingString:@"."];
        }
        dotCount ++;
        
        [self.loginButton setTitle:loginString forState:UIControlStateNormal];
    } repeats:YES];

}

- (void)endLogin
{
    self.usernameField.enabled = YES;
    self.passwordField.enabled = YES;
    self.verifycodeField.enabled = YES;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    self.isLogining = NO;
    
    [self.loginTimer invalidate];
    self.loginTimer = nil;
}

- (void)hideKeyboard
{
    if (self.isKeyboardShowing) {
        self.isKeyboardShowing = NO;
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
}

- (void)login:(UIButton *)sender
{
    if (!self.isLogining) {
        if (self.usernameField.text.length > 0 && self.passwordField.text.length > 0 && self.verifycodeField.text.length > 0) {
            [self hideKeyboard];
            [[DataManager manager] userLoginWithUserName:self.usernameField.text password:self.passwordField.text verifycode:self.verifycodeField.text
                htmlFieldsDictionary:self.htmlFieldsDictionary
                success:^(NSString *uid) {
                [[DataManager manager] getMemberWithUid:uid success:^(Member *member) {
                    User *user = [[User alloc] init];
                    user.member = member;
                    [DataManager manager].user = user;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    [self endLogin];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [SVProgressHUD dismiss];
                    });
                } failure:^(NSError *error) {
                    [self endLogin];
                }];
            } failure:^(NSError *error) {
                NSLog(@"error code: %ld",(long)error.code);
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                [self endLogin];
            }];
            
            [self beginLogin];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
