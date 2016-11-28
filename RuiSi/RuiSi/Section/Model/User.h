//
//  User.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/11/28.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic,strong) NSString *homepage;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *iconUrl;
@property (nonatomic,strong) NSString *score;
@property (nonatomic,strong) NSString *coinsNumber;
@property (nonatomic,strong) NSString *uploadNumber;
@property (nonatomic,strong) NSString *downloadNumber;
@property (nonatomic,strong) NSString *torrentNumber;
@property (nonatomic,strong) NSString *counters;//筹码
@property (nonatomic,strong) NSString *saveRatio;
@property (nonatomic,strong) NSString *characterNumber;
@end
