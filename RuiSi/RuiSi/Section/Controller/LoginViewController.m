//
//  LoginViewController.m
//  RuiSi
//
//  Created by aloes on 2017/1/17.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic,assign) BOOL isLogining;
@property (nonatomic,assign) BOOL isKeyboardShowing;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"登录";
}

- (IBAction)back:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) beginLogin {
    
}

- (void) hideKeyboard {
    
}

- (IBAction)login:(UIButton *)sender
{
    if (!self.isLogining) {
        
        if (self.usernameField.text.length && self.passwordField.text.length) {
            [self hideKeyboard];
            
            
            [self beginLogin];
            
        }
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
