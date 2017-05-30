//
//  RSPopUpInputView.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/5/29.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "RSPopUpInputView.h"

@implementation RSPopUpInputView

- (void) awakeFromNib {
    [super awakeFromNib];
    self.replyTextView.delegate = self;
    self.replyTextView.text = @"说点什么？";
    self.replyTextView.textColor = [UIColor grayColor];
    
    self.replyTextView.layer.borderWidth = 1;
    self.replyTextView.layer.borderColor = [[UIColor colorWithRed:52/255.0 green:197/255.0f blue:170/255.0f alpha:1.0] CGColor];
    
    self.selfHeight = 50;
    self.avatarImageview.layer.cornerRadius = self.avatarImageview.bounds.size.width/2;
    
    self.replyButton.enabled =false;
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor blackColor];
    self.containerView.alpha = 0.3;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


- (void) keyboardWillShow:(NSNotification *)notification {
    self.isShowing = YES;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.superview insertSubview:self.containerView belowSubview:self];
    self.containerView.frame = self.superview.bounds;
    [CATransaction commit];
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardBounds = [(NSValue *)userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [(NSNumber *)userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat deltaY = keyboardBounds.size.height;
    self.selfHeight = self.selfHeight+20;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_selfHeight));
    }];
    
    self.replyHeight.constant = 20;
    
    void ( ^animations)() = ^(void) {
        self.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        [self layoutIfNeeded];
    };
    
    if (duration > 0 ) {
        UIViewAnimationOptions options = UIViewAnimationOptionTransitionNone;
        NSUInteger value = (NSUInteger)([(NSNumber *)userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16);
        [UIView animateWithDuration:duration delay:0 options:options animations:animations completion:nil];
    } else {
        animations();
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    self.isShowing = false;
    [self.containerView removeFromSuperview];
    double duration = [(NSNumber *)userInfo[UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    self.replyHeight.constant = 0;
    self.selfHeight = self.selfHeight-20;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_selfHeight));
    }];
    
    void (^ animations)() = ^(void) {
        self.transform = CGAffineTransformIdentity;
        [self layoutIfNeeded];
    };
    
    if (duration > 0) {
        UIViewAnimationOptions options = UIViewAnimationOptionTransitionNone;
        NSUInteger value = (NSUInteger)([(NSNumber *)userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16);
        [UIView animateWithDuration:duration delay:0 options:options animations:animations completion:nil];
    } else {
        animations();
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text  isEqualToString:@"说点什么？"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"说点什么？";
        textView.textColor = [UIColor grayColor];
    }
    
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height;
    textView.frame = frame;
    
    if ([textView.text isEqualToString:@""]) {
        self.replyButton.enabled = NO;
    } else {
        self.replyButton.enabled = YES;
    }
    
    if (self.isShowing) {
        self.selfHeight = textView.contentSize.height + 40;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(textView.contentSize.height + 40));
        }];
    } else {
        self.selfHeight = textView.contentSize.height + 20;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(textView.contentSize.height+20));
        }];
    }
    
    [self setNeedsLayout];
}

@end
