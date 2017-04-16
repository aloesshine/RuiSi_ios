//
//  Constants.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/28.
//  Copyright © 2016年 aloes. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//#define kPublicNetURL @"http://bbs.rs.xidian.me/"
//#define kSchoolNetURL @"http://rs.xidian.edu.cn/"
#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define userDefaults [NSUserDefaults standardUserDefaults]

static NSString * const kLoginSuccessNotification = @"LoginSuccessNotification";
static NSString * const kLogoutSuccessNotification = @"LogoutSuccessNotification";
static NSString * const kPublicNetURL = @"http://bbs.rs.xidian.me/";
static NSString * const kSchoolNetURL = @"http://rs.xidian.edu.cn/";

static NSString * const kFavoriteIsSuccessful = @"FavoriteIsSuccessful";
static NSString * const kPostIsSuccessful = @"PostIsSuccessful";
#endif /* Constants_h */
