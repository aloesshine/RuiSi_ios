//
//  Reply.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "Reply.h"

@implementation Reply

@end


@implementation ReplyList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for(NSDictionary *dict in list) {
            Reply *reply = [[Reply alloc] initWithDictionary:dict];
            [list addObject:reply];
        }
        self.list = list;
    }
    return self;
}

@end
