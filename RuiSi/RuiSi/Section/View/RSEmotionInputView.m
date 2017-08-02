//
//  RSEmotionInputView.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/8/1.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "RSEmotionInputView.h"
static const CGFloat EmojiHeight = 50;
static const CGFloat EmojiWidth = 50;
static const CGFloat EmojiFontSize = 32;

@implementation RSEmotionButton
@end


@interface RSEmotionInputView  () <UIScrollViewDelegate>
@property (nonatomic,strong) NSArray *emojis;
@end

@implementation RSEmotionInputView

- (CGRect) defaultFrame {
    return CGRectMake(0, 0, kScreen_Width, 216);
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIWithFrame:frame];
    }
    return self;
}

- (void) initUIWithFrame:(CGRect) frame {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = [self defaultFrame];
    }
    self.frame = frame;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RSEmotionList" ofType:@"plist"];
    self.emojis = [NSArray arrayWithContentsOfFile:plistPath];
    NSInteger rowNum = (CGRectGetHeight(frame)/EmojiHeight);
    NSInteger colNum = (CGRectGetWidth(frame)/EmojiWidth);
    NSInteger numberOfPage = ceil((float)[self.emojis count] / (float)(rowNum*colNum));
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame)*numberOfPage, CGRectGetHeight(frame));
    
    [self addSubview:self.scrollView];
    
    
    NSInteger row = 0;
    NSInteger col = 0;
    NSInteger page = 0;
    NSInteger emojiPointer = 0;
    for(int i = 0; i < [self.emojis count] + numberOfPage -1;i++) {
        if (i %(rowNum*colNum) == 0) {
            page++;
            row = 0;
            col = 0;
        } else if (i % colNum == 0) {
            row += 1;
            col = 0;
        }
        
        CGRect currentRect = CGRectMake((page-1)*CGRectGetWidth(frame)+col*EmojiWidth, row*EmojiHeight, EmojiWidth, EmojiHeight);
        if(row == (rowNum-1) && col == (colNum-1)) {
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteButton addTarget:self action:@selector(deleteButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            deleteButton.frame = currentRect;
            deleteButton.tintColor = [UIColor blackColor];
            [self.scrollView addSubview:deleteButton];
        } else {
            NSDictionary *dict = self.emojis[emojiPointer++];
            RSEmotionButton *emojiButton = [RSEmotionButton buttonWithType:UIButtonTypeCustom];
            emojiButton.titleLabel.font = [UIFont fontWithName:@"Apple color emoji" size:EmojiFontSize];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:[dict objectForKey:@"image"] ofType:@"png"];
            NSData *pngData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
            UIImage *pngImage = [UIImage imageWithData:pngData];
            emojiButton.imageView.image = pngImage;
            emojiButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            emojiButton.textToSend = [dict objectForKey:@"text"];
            [emojiButton addTarget:self action:@selector(emojiButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            
            emojiButton.frame = currentRect;
            [self.scrollView addSubview:emojiButton];
        }
        
    }
    
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.currentPage = 0;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = numberOfPage;
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:numberOfPage];
    self.pageControl.frame = CGRectMake(CGRectGetMidX(frame)-pageControlSize.width/2, CGRectGetHeight(frame)-pageControlSize.height+5, pageControlSize.width, pageControlSize.height);
    [self.pageControl addTarget:self action:@selector(pageControlTouched:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    
    self.popAnimationEnabled = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
}



- (void) emojiButtonTouched:(RSEmotionButton *) emojiButton {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.byValue = @0.3;
    animation.duration = 0.1;
    animation.autoreverses = YES;
    [emojiButton.layer addAnimation:animation forKey:nil];
    if(self.popAnimationEnabled) {
        RSEmotionButton *animationEmojiButton = [RSEmotionButton buttonWithType:UIButtonTypeCustom];
        animationEmojiButton.imageView.image = emojiButton.imageView.image;
        animationEmojiButton.textToSend = emojiButton.textToSend;
        animationEmojiButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        animationEmojiButton.frame = [emojiButton.superview convertRect:emojiButton.frame toView:self];
        [self addSubview:animationEmojiButton];
        
        CGPoint newPoint = [self.textField convertPoint:self.textField.center toView:self];
        [UIView animateWithDuration:0.3 animations:^{
            animationEmojiButton.center = newPoint;
            animationEmojiButton.alpha = 0;
        } completion:^(BOOL finished) {
            if(finished) {
                if([self.delegate respondsToSelector:@selector(emojiInputView:didSelectEmoji:)]) {
                    [self.delegate emojiInputView:self didSelectEmoji:emojiButton.textToSend];
                }
            }
            [animationEmojiButton removeFromSuperview];
        }];
    } else {
        if([self.delegate respondsToSelector:@selector(emojiInputView:didSelectEmoji:)]) {
            [self.delegate emojiInputView:self didSelectEmoji:emojiButton.textToSend];
        }
    }
}

- (void) deleteButtonTouched:(UIButton *) deleteButton {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.toValue = @0.9;
    animation.duration = 0.1;
    animation.autoreverses = YES;
    [deleteButton.layer addAnimation:animation forKey:nil];
    
    if([self.delegate respondsToSelector:@selector(emojiInputView:didPressDeleteButton:)]) {
        [self.delegate emojiInputView:self didPressDeleteButton:deleteButton];
    }
}

- (void) pageControlTouched:(UIPageControl *)pageControl {
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds)*pageControl.currentPage;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSInteger newPageNumber = floor((scrollView.contentOffset.x - pageWidth/2) / pageWidth)+1;
    if(self.pageControl.currentPage == newPageNumber) {
        return;
    } else {
        self.pageControl.currentPage = newPageNumber;
    }
}


- (instancetype) initWithTextField:(UIView *)textField delegate:(id<RSEmotionInputViewDelegate>)delegate {
    self = [super init];
    if(self) {
        self.delegate = delegate;
        self.textField = textField;
    }
    return self;
}


@end
