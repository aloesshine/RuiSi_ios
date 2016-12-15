//
//  Helper.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/7.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "Helper.h"

@implementation Helper
+ (CGFloat)getTextWidthWithText:(NSString *)text Font:(UIFont *)font {
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 };
    CGRect expectedLabelRect = [text boundingRectWithSize: CGSizeMake(CGFLOAT_MAX, CGFLOAT_MIN) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGRectGetWidth(expectedLabelRect);
}


+ (CGFloat)getTextHeightWithText:(NSString *)text Font:(UIFont *)font Width:(CGFloat)width {
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 };
    CGRect expectedLabelRect = [text boundingRectWithSize: CGSizeMake(width, CGFLOAT_MIN) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGRectGetHeight(expectedLabelRect);
}
@end
