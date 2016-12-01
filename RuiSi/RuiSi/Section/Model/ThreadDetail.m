//
//  ThreadDetail.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetail.h"

@implementation ThreadDetail
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.threadCreateTime = [dict objectForKey:@"thread_createtime"];
        self.threadContents = [dict objectForKey:@"contents"];
        self.threadID = [dict objectForKey:@"id"];
    }
    return self;
}
@end
