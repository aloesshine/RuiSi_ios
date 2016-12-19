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
@implementation ThreadDetail
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
    }
    return self;
}


- (void)configureMember {
    
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
        NSLog(@"%@",htmlString);
        OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
        OCQueryObject *elementArray = document.Query(@"body").find(@".postlist").find(@".cl");
        for(OCGumboNode *node in elementArray) {
            ThreadDetail *detail = [[ThreadDetail alloc] init];
            NSString *idString = (NSString *)node.attr(@"id");
            detail.threadID = [idString substringFromIndex:3];
            detail.creatorName = (NSString *)node.Query(@".blue").first().text();
            detail.homepage = (NSString *)node.Query(@".blue").first().attr(@"href");
            detail.createTime = (NSString *)node.Query(@".rela").first().text();
            detail.content = (NSString *)node.Query(@".message").first().html();
            detail.quoteArray = [detail.content quoteArray];
            
            
#warning Parse contentArray
            NSString *mentionString = detail.content;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:mentionString];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributedString.length)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attributedString.length)];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 0.8;
            [attributedString addAttributes:@{
                                              NSParagraphStyleAttributeName:style
                                              }range:NSMakeRange(0, attributedString.length)];
            
            NSMutableArray *imageURLs = [[NSMutableArray alloc] init];
            for (SCQuote *quote in detail.quoteArray) {
                NSRange range = [mentionString rangeOfString:quote.string];
                if (range.location != NSNotFound) {
                    
                }
            }
            
            
            NSLog(@"%@",detail.content);
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


- (NSString *) spaceWithLength:(NSUInteger) length {
    NSString *spaceString = @"";
    while (spaceString.length < length) {
        spaceString = [spaceString stringByAppendingString:@" "];
    }
    return spaceString;
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
