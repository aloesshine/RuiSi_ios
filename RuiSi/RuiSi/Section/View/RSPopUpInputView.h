//
//  RSPopUpInputView.h
//  RuiSi
//
//  Created by 汪泽伟 on 2017/5/29.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSPopUpInputView : UIView <UITextViewDelegate>
@property (nonatomic,weak) IBOutlet UITextView *replyTextView;
@property (nonatomic,weak) IBOutlet UILabel *replyToLabel;
@property (nonatomic,weak) IBOutlet UIImageView *avatarImageview;
@property (nonatomic,weak) IBOutlet UIButton *replyButton;
@property (nonatomic,weak) IBOutlet UIButton *showEmotionButton;
@property (nonatomic,strong)  UIView *containerView;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *replyHeight;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *textViewHeight;
@property (nonatomic,assign) BOOL isShowing;
@property (nonatomic,assign) CGFloat selfHeight;
@end
