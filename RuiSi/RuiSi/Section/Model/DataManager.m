//
//  DataManager.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/2.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
@end

@implementation DataManager

- (instancetype) init {
    if (self = [super init]) {
        
    }
    
    return self;
}

+ (instancetype) manager {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}

+ (BOOL)isSchoolNet {
    return false;
}

@end
