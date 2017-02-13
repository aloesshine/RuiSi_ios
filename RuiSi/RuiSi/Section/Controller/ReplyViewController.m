//
//  ReplyViewController.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/2/12.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "ReplyViewController.h"
@interface ReplyViewController ()
@property (nonatomic,strong) IBOutlet UITextField *replyTextField;
@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.title = @"回复";
    [self.replyTextField becomeFirstResponder];
}

- (void) loadView {
    [super loadView];
    [self congifureNavigationBarItems];
    [self configureTextViews];
}

- (void) configureTextViews {
    
    self.replyTextField = [[UITextField alloc] initWithFrame:self.view.frame];
    self.replyTextField.backgroundColor = [UIColor whiteColor];
    self.replyTextField.font = [UIFont systemFontOfSize:17.0f];
    self.replyTextField.textColor = [UIColor blackColor];
    self.replyTextField.returnKeyType = UIReturnKeyNext;
    self.replyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.replyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.replyTextField.clearButtonMode = UITextFieldViewModeNever;
    self.replyTextField.placeholder = @"说点什么吧";
    [self.view addSubview:self.replyTextField];
    
}

- (void) congifureNavigationBarItems {
    UIBarButtonItem *publishBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = publishBarButtonItem;
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
}
- (void) cancel {
    [self.replyTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) publish {
    NSLog(@"published!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
