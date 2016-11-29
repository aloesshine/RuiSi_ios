//
//  Login.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/28.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login : NSObject
@property (nonatomic,strong) NSString *userName,*password;

+ (BOOL) isLogin;

@end
