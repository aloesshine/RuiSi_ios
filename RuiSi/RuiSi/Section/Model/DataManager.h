//
//  DataManager.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/2.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <AFNetworking.h>


@interface DataManager : NSObject

@property (nonatomic,strong) User *user;

+ (instancetype) manager;
+ (BOOL) isSchoolNet;
@end
