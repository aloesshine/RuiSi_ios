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
            detail.content = (NSString *)node.Query(@".message").first().html();
            detail.threadCreator = [Member getMemberWithHomepage:detail.homepage];
            if (i != 0) {
                if (node.Query(@".button").first()) {
                    detail.replyUrlString = (NSString *)node.Query(@".button").first().attr(@"href");
                }
            }
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

+ (NSDictionary *)getLinkDictionaryFromResponseObject:(id)responseObject {
    @autoreleasepool {
        NSDictionary *dictionary;
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCGumboNode *node = document.Query(@"body").find(@".postlist").find(@".cl").first();
        NSString *favorUrlString = (NSString *)node.Query(@".favbtn").first().attr(@"href");
        NSString *creatorUrlString = (NSString *)document.Query(@"body").find(@".postlist").find(@"h2").find(@".blue").first().attr(@"href");
        node = document.Query(@"body").find(@".postlist").find(@".cl").last();
        NSString *replyUrlString = (NSString *)node.Query(@"form").first().attr(@"action");
        NSString *formhash = (NSString *)node.Query(@"input").first().attr(@"value");
        dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:favorUrlString,@"favorite",creatorUrlString,@"creatorOnly",replyUrlString,@"reply",formhash,@"formhash", nil];
        return dictionary;
    }
    return nil;
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
