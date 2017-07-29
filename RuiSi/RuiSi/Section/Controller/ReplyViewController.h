//
//  ReplyViewController.h
//  RuiSi
//
//  Created by 汪泽伟 on 2017/2/12.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReplyViewController;
@protocol ReplyViewControllerDelegate <NSObject>
- (void) replyViewControllerDidCancel:(ReplyViewController *)replyViewController;
- (void) replyViewController:(ReplyViewController *)replyViewController didPublishThreadDetail:(ThreadDetail *)threadDetail;
- (void) replyViewControllerHaveNotLogin:(ReplyViewController *)replyViewController;
@end

@interface ReplyViewController : UIViewController
@property (nonatomic,copy) NSString *postUrlString;
@property (nonatomic,copy) NSString *formhash;
@property (nonatomic,weak) id<ReplyViewControllerDelegate> delegate;
@property (nonatomic,strong)  UITextField *replyTextField;
@end

