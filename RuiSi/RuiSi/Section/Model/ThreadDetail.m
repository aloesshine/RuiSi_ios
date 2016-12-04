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


+ (ThreadDetailList *)getThreadDetailListFromResponseObject:(id)responseObject {
    NSMutableArray *threadDetailArray = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCGumboNode *element = document.Query(@"body.bg").find(@"div.postlist").first();
        OCQueryObject *elementArray = element.Query(@"div");
        for(OCGumboNode *node in elementArray) {
            ThreadDetail *detail = [[ThreadDetail alloc] init];
            detail.threadID = (NSString *)node.Query(@"div.plc cl").first().attr(@"id");
            detail.creatorName = (NSString *)node.Query(@"ul.authi").first().text();
            detail.homepage = (NSString *)node.Query(@"a").first().attr(@"href");
            detail.createTime = (NSString *)node.Query(@"li.grey rela").first().text();
            [threadDetailArray addObject:detail];
        }
    }
    
    ThreadDetailList *list;
    if (threadDetailArray.count) {
        list = [[ThreadDetailList alloc] init];
        list.list = threadDetailArray;
    }
    return list;
}

@end
