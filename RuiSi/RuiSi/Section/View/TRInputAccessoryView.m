//
//  TRInputAccessoryView.m
//  RuiSi
//
//  Created by 汪泽伟 on 2017/3/28.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "TRInputAccessoryView.h"
#import "Masonry.h"
@implementation TRInputAccessoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showEmotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.showEmotionButton setTitle:@"表情" forState:UIControlStateNormal];
        [self.showEmotionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sendButton setTitle:@"发送" forState: UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [self addSubview:self.showEmotionButton];
        [self addSubview:self.sendButton];
        
        
        [self.showEmotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(5);
            
        }];
        
        
    }
    return self;
}



@end
