//
//  Helper.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/7.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
@interface Helper : NSObject

+ (CGFloat) getTextWidthWithText:(NSString *)text Font:(UIFont *)font;
+ (CGFloat) getTextHeightWithText:(NSString *)text Font:(UIFont *)font Width:(CGFloat)width;
@end
