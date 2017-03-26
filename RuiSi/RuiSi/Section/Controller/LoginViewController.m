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
//#import "DataManager.h"
//#import "SVProgressHUD.h"
@interface LoginViewController ()
@property (nonatomic,assign) BOOL isLogining;
@property (nonatomic,assign) BOOL isKeyboardShowing;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak,nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic,strong) NSTimer *loginTimer;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"登录";
    self.isLogining = NO;
    self.isKeyboardShowing = NO;
    [self.usernameField becomeFirstResponder];
}

- (IBAction)back:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) beginLogin {
    self.isLogining = YES;
    self.usernameField.enabled = NO;
    self.passwordField.enabled = NO;
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

- (void) endLogin {
    self.usernameField.enabled = YES;
    self.passwordField.enabled = YES;
    
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    self.isLogining = NO;
    
    [self.loginTimer invalidate];
    self.loginTimer = nil;
}

- (void) hideKeyboard {
    if (self.isKeyboardShowing) {
        self.isKeyboardShowing = NO;
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
//        [UIView animateWithDuration:0.3 animations:^{
//            self.containView.y      = kContainViewYNormal;
//            self.descriptionLabel.y += 5;
//            self.usernameField.y    += 10;
//            self.passwordField.y    += 12;
//            self.loginButton.y      += 14;
//        } completion:^(BOOL finished) {
//        }];
    }

}

- (IBAction)login:(UIButton *)sender
{
    if (!self.isLogining) {
        
        if (self.usernameField.text.length && self.passwordField.text.length) {
            [self hideKeyboard];
            [[DataManager manager] userLoginWithUserName:self.usernameField.text password:self.passwordField.text success:^(NSString *uid) {
                [[DataManager manager] getMemberWithUid:uid success:^(Member *member) {
                    User *user = [[User alloc] init];
                    user.member = member;
                    [DataManager manager].user = user;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
                    [self endLogin];
                    [self dismissViewControllerAnimated:YES completion:nil];
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
