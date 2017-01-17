//
//  TextField.m
//  RuiSi
//
//  Created by aloes on 2017/1/17.
//  Copyright © 2017年 aloes. All rights reserved.
//

#import "TextField.h"

@interface TextField() <UITextFieldDelegate>

@end

@implementation TextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self becomeFirstResponder];
}



@end
