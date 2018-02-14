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
@property (nonatomic,assign) BOOL isLogining;
@property (nonatomic,assign) BOOL isKeyboardShowing;
@property (nonatomic,weak) IBOutlet UITextField *usernameField;
@property (nonatomic,weak) IBOutlet UITextField *passwordField;
@property (nonatomic,weak) IBOutlet UIButton *loginButton;
@property (nonatomic,weak) IBOutlet UIButton *cancelButton;
@property (nonatomic,weak) IBOutlet UITextField *verifycodeField;
@property (nonatomic,weak) IBOutlet FLAnimatedImageView *verifyImageView;
@property (nonatomic,strong) NSDictionary *htmlFieldsDictionary;
@property (nonatomic,strong) NSTimer *loginTimer;
@property (nonatomic,copy) NSURLSessionDataTask* (^requestOnceBlock)(void);
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"登录";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.isLogining = NO;
    self.isKeyboardShowing = NO;
    [self.usernameField becomeFirstResponder];
    [self configureBlocks];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.requestOnceBlock();
    });
}

- (void) configureBlocks {
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
                [self.verifyImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
            });
        } failure:^(NSError *error) {
            ;
        }];
    };
}

- (IBAction)back:(UIButton *)sender
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

- (void) beginLogin {
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

- (void) endLogin {
    self.usernameField.enabled = YES;
    self.passwordField.enabled = YES;
    self.verifycodeField.enabled = YES;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    self.isLogining = NO;
    
    [self.loginTimer invalidate];
    self.loginTimer = nil;
}

- (void) hideKeyboard {
    if (self.isKeyboardShowing) {
        self.isKeyboardShowing = NO;
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
}

- (IBAction)login:(UIButton *)sender
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
