//
//  Reply.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/4.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "Reply.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
@implementation Reply
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        
    }
    return self;
}
@end

@implementation ReplyList

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for(NSDictionary *dict in list) {
            Reply *reply = [[Reply alloc] initWithDictionary:dict];
            [list addObject:reply];
        }
    }
    return self;
}


- (NSInteger)countOfList {
    return self.list.count;
}
+ (ReplyList *)getReplyListFromResponseObject:(id)responseObject {
    NSMutableArray *elements = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCGumboNode *element = document.Query(@"body.bg").find(@"div.postlist").first();
        OCQueryObject *elementArray = element.Query(@"div");
        for(int i = 1;i < elementArray.count;i++) {
            OCGumboNode *node = [elementArray objectAtIndex:i];
            Reply *reply = [[Reply alloc] init];
            reply.replierName = (NSString *)node.Query(@"a").text();
            reply.replyID = (NSString *)node.Query(@"div.plc cl").first().attr(@"id");
            reply.homePage = (NSString *)node.Query(@"a").first().attr(@"href");
            reply.replyTime = (NSString *)node.Query(@"li.grey rela").text();
            
            [elements addObject:reply];
        }
    }
    ReplyList *list;
    if (elements.count) {
        list = [[ReplyList alloc] init];
        list.list = elements;
    }
    return list;
}

@end
