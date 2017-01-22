//
//  ThreadDetail.m
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadDetail.h"
#import "NSString+SCMention.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
#import "DataManager.h"
#import "Constants.h"


@implementation ThreadDetail


- (NSString *) spaceWithLength:(NSUInteger) length {
    NSString *spaceString = @"";
    while (spaceString.length < length) {
        spaceString = [spaceString stringByAppendingString:@" "];
    }
    return spaceString;
}

@end


@interface ThreadDetailList()

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

+ (NSString *) formatHMTLString:(NSString *) htmlString {
    NSString *string = htmlString;
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return string;
}

+ (ThreadDetailList *)getThreadDetailListFromResponseObject:(id)responseObject {
    NSMutableArray *threadDetailArray = [[NSMutableArray alloc] init];
    @autoreleasepool {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCQueryObject *elementArray = document.Query(@"body").find(@".postlist").find(@".cl");

        NSInteger countOfArray = [elementArray count];
        for (int i = 0; i < countOfArray-1;i++)
        {
            OCGumboNode *node = [elementArray objectAtIndex:i];

            ThreadDetail *detail = [[ThreadDetail alloc] init];
            NSString *idString = (NSString *)node.attr(@"id");
            detail.threadID = [idString substringFromIndex:3];
            detail.creatorName = (NSString *)node.Query(@".blue").first().text();
            detail.homepage = (NSString *)node.Query(@".blue").first().attr(@"href");
            detail.createTime = (NSString *)node.Query(@".rela").textArray().lastObject;
            if ([detail.createTime rangeOfString:@"\n"].location != NSNotFound) {
                detail.createTime = [detail.createTime stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            }
            if (i == 0) {
                //detail.favoriteURL = (NSString *)node.Query(@".rela").find(@"a").first().attr(@"href");
            } else {
                //detail.replyURL = (NSString *)node.Query(@".button").first().attr(@"href");
            }
            NSString *contentHTML = (NSString *)node.Query(@".message").first().html();
            detail.content = contentHTML;
        
            detail.threadCreator = [Member getMemberWithHomepage:detail.homepage];
            [threadDetailArray addObject:detail];
        }
        ThreadDetail *detail = [threadDetailArray objectAtIndex:0];
        OCGumboNode *node = [elementArray objectAtIndex:countOfArray-1];
        detail.favoriteURL = (NSString *)node.Query(@"form").first().attr(@"action");
    }
    ThreadDetailList *list;
    if (threadDetailArray.count) {
        list = [[ThreadDetailList alloc] init];
        list.list = threadDetailArray;
    }
    return list;
}


@end


@implementation RSContentBaseModel

- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}

@end

@implementation RSContentStringModel

- (instancetype) init {
    if (self = [super init]) {
        self.contentType = RSContentTypeString;
    }
    return self;
}

@end


@implementation RSContentImageModel

- (instancetype) init {
    if (self = [super init]) {
        self.contentType = RSContentTypeImage;
    }
    return self;
}

@end
