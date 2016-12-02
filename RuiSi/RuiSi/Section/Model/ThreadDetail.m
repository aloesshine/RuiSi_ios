//
//  ThreadDetail.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetail.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
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

@implementation ThreadDetailList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for( NSDictionary *dict in list) {
            ThreadDetail *detail = [[ThreadDetail alloc] initWithDictionary:dict];
            [list addObject:detail];
        }
        self.list = list;
    }
    return self;
}

- (NSInteger)countOfList {
    return self.list.count;
}

+ (ThreadDetailList *)getThreadDetailListWithURL:(NSString *)urlString {
#warning "Todo"
    NSMutableArray *elements = [[NSMutableArray alloc] init];
    ThreadDetailList *list;
    @autoreleasepool {
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:urlString];
        NSString *htmlString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    }
    if (elements.count) {
        list = [[ThreadDetailList alloc] init];
        list.list = elements;
    }
    return list;
}

@end
