//
//  RSEmotionInputView.h
//  RuiSi
//
//  Created by 汪泽伟 on 2017/8/1.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSEmotionInputViewDelegate;

@interface RSEmotionButton : UIButton
@property (nonatomic,copy) NSString *textToSend;
@end


@interface RSEmotionInputView : UIView
@property (nonatomic,weak) id<RSEmotionInputViewDelegate> delegate;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIView *textField;
@property (nonatomic,assign) BOOL popAnimationEnabled;

- (instancetype) initWithTextField:(UIView *)textField delegate:(id <RSEmotionInputViewDelegate>) delegate;

@end

@protocol RSEmotionInputViewDelegate <NSObject>

- (void) emojiInputView:(RSEmotionInputView *) emojiInputView didSelectEmoji:(NSString *) emojiString;
- (void) emojiInputView:(RSEmotionInputView *) emojiInputView didPressDeleteButton:(UIButton *) deleteButton;

@end
