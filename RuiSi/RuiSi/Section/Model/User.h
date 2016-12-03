//
//  User.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/28.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"
@interface User : NSObject
@property (nonatomic,strong) Member *member;
@property (nonatomic,assign,getter=isLogin) BOOL login;
@end
